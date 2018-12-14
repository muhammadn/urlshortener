require 'faker'
charset = [('a'..'z'), ('A'..'Z'), (0..9)]

FactoryBot.define do
  factory :url do
    shortcode { (0...6).map{ charset[rand(charset.size)] }.join }
    url Faker::Internet.url
  end
end
