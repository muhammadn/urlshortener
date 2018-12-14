module GetData
  extend ActiveSupport::Concern

  def url_data(params)
      charset = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a
      raise RuntimeError, "URL parameter is missing!" if !params.dig(:url, :url)
      url = Url.find_by(url: params[:url][:url])

      if url.nil?
        # make sure new url does have parameter sanization (url_params)
        url = Url.new(url_params)
        url.shortcode = (0...6).map{ charset[rand(charset.size)] }.join
        url.save!
      end
  end
end
