class Article < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  validates :content, presence: true, length: {
    minimum: 300,
    too_short: 'Your content must have at least 300 characters.',
    maximum: 3000,
    too_long: 'Your content must not exceed 3000 characters.'
  }
end
