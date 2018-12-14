require 'rails_helper'

RSpec.describe Url, type: :model do
  it 'is not valid without url input' do
    url = Url.new(url: nil)
    expect(url).to_not be_valid
  end

  it 'is not valid when it is not a URL' do
    url = Url.new(url: 'file://test')
    expect(url).to_not be_valid
  end

  it 'is valid when it is a correct URL' do
    url = Url.new(url: 'http://unrealasia.net')
    expect(url).to be_valid
  end
end
