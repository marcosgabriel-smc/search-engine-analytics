class Log < ApplicationRecord
  validates :input, presence: true, length: {minimum: 3}
  validates :ip, presence: true, format: { with: /\A(?:[0-9]{1,3}\.){3}[0-9]{1,3}\z/, message: "must be a valid IPv4 address" }
  validates :city, presence: true
  validates :country, presence: true
end
