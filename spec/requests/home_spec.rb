require 'rails_helper'

RSpec.describe "Home", type: :request do
  describe "GET /" do
    it "opens up the url shortener page" do
      get home_path
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /" do
    it "should have more records after adding this" do
      before_count = Url.count
      post home_path, params: {url: {url: 'http://unrealasia.net'}}
      expect(Url.count).not_to eq(before_count)
    end

    it "should have a redirect status" do
      post home_path, params: {url: {url: 'http://unrealasia.net'}}
      expect(response).to have_http_status(302)
      follow_redirect!

      expect(response.body).to include("Here is your shortened URL")
    end

    it "should have the new variable" do
      post home_path, params: {url: {url: 'http://localhost'}}
      expect(response).to redirect_to(assigns(:url))
    end

    it "should only be in 6 characters" do
      post home_path, params: {url: {url: 'http://unrealasia.net'}}
      expect(Url.last.shortcode.size).to eq(6)
    end

    it "should show error if there is no url parameter" do
      post home_path, params: {urlwrong: {url: 'http://unrealasia.net'}}
      expect(response).to have_http_status(302)
      follow_redirect!

      expect(response.body).to include("url parameter is empty")
    end

    it "should show error if there url is invalid" do
      post home_path, params: {url: {url: 'file://unrealasia.net'}}
      expect(response).to have_http_status(302)
      follow_redirect!

      expect(response.body).to include("invalid URL")
    end
  end

  describe "POST /add" do
    it "should have more records after adding" do
      before_count = Url.count
      post add_home_path, params: {url: {url: 'http://unrealasia.net'}}
      expect(response).to have_http_status(200)
      expect(Url.count).not_to eq(before_count)
    end

    it "should only be in 6 characters" do
      post add_home_path, params: {url: {url: 'http://unrealasia.net'}}
      expect(response).to have_http_status(200)
      expect(Url.last.shortcode.size).to eq(6)
    end

    it "should show error if there is no url parameter" do
      post add_home_path, params: {urlwrong: {url: 'http://unrealasia.net'}}
      expect(response).to have_http_status(200)

      json = JSON.parse(response.body)
      expect(json['errors']).not_to be_nil
    end

    it "should show error if url is invalid" do
      post add_home_path, params: {url: {url: 'file://unrealasia.net'}}
      expect(response).to have_http_status(200)

      json = JSON.parse(response.body)
      expect(json['errors']).not_to be_nil
    end
  end

  describe "GET /randomLink" do
    it "should redirect to the link according to the shortcode" do
      post add_home_path, params: {url: {url: 'http://unrealasia.net'}}
      expect(response).to have_http_status(200)

      url = Url.find_by(url: 'http://unrealasia.net')
      get "/#{url.shortcode}"
      expect(response).to have_http_status(302)
    end
  end
end
