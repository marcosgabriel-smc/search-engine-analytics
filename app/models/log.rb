class Log < ApplicationRecord
  ip_regex = /\A(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\z/
  validates :input, presence: true, length: {minimum: 3}
  validates :ip, presence: true, format: { with: ip_regex, message: "must be a valid IPv4 address" }
  validates :city, presence: true
  validates :country, presence: true
end
