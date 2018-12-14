class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:add]

  def show
    @url = Url.find_by(shortcode: params[:shortcode])
  end

  def create
    begin
      charset = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a

      # raise error when there is no url parameter
      raise RuntimeError, "url parameter is empty" if params.dig(:url, :url).nil?
      # raise error when url is invalid - this includes http:// and https://
      raise RuntimeError, "invalid URL" if params[:url][:url] !~ /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?$/ix
      # if everything is okay, then continue
      url = Url.find_by(url: params[:url][:url])

      if url.nil?
        url = Url.new(url_params)
	url.shortcode = (0...6).map{ charset[rand(charset.size)] }.join
        url.save!
      end	

      respond_to do |format|
        format.html { redirect_to home_path(shortcode: url.shortcode), notice: 'Here is your shortened URL'}
      end
    rescue RuntimeError => e
      flash[:error] = e.message
      redirect_to home_path
    end
  end

  def link
    begin
      shortcode = request.path_info[1..-1]
      url = Url.find_by!(shortcode: shortcode)
      redirect_to url.url
    rescue ActiveRecord::RecordNotFound => e
      flash[:error] = 'Shortened link is invalid'
      redirect_to home_path
    end

  end

  def add
    begin 
      charset = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a
 
      # raise error when there is no url parameter
      raise RuntimeError, "url parameter is empty" if params.dig(:url, :url).nil?
      # raise error when url is invalid - this includes http:// and https://
      raise RuntimeError, "invalid URL" if params[:url][:url] !~ /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?$/ix
      # if everything is okay, then continue
      url = Url.find_by(url: params[:url][:url])

      if url
        render json: {link:
                       {url: url.url,
                         short_url: url.shortcode},
                         errors: []
                     }
      else	
        # make sure new url does have parameter sanization (url_params)
        url = Url.new(url_params)
        url.shortcode = (0...6).map{ charset[rand(charset.size)] }.join
        url.save
        render json: {link:
                       {url: url.url,
                         short_url: url.shortcode},
                         errors: []
                     }
      end
    rescue RuntimeError => e
      render json: {link: {url: 'invalid', short_url: 'invalid'}, errors: [error: e.message] }
    end
  end

  private

  def url_params
    params.require(:url).permit(:url)
  end
end
