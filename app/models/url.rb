class Url < ApplicationRecord

  validates :url, presence: true, format: { 
    with: /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?$/ix,
    message: 'Invalid URL',
    multiline: true }
end
