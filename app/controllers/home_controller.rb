class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:add]
  include GetData

  def show
    @url = Url.find_by(shortcode: params[:shortcode])
  end

  def create
    begin
      url = url_data(params)

      respond_to do |format|
        format.html { redirect_to home_path(shortcode: url.shortcode), notice: 'Click your short url below' }
      end
    rescue ActiveRecord::RecordInvalid, RuntimeError => e
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
        url = url_data(params) 
        render json: {link:
                       {url: url.url,
                         short_url: url.shortcode},
                         errors: []
                     }
    rescue ActiveRecord::RecordInvalid, RuntimeError => e
      render json: {link: {url: 'invalid', short_url: 'invalid'}, errors: [error: e.message] }
    end
  end

  private

  def url_params
    params.require(:url).permit(:url)
  end
end
