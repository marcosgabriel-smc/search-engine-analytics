FactoryBot.define do
  factory :log do
    input { "What is love? Baby dont hurt me" }
    ip { "192.168.1.1" }
    city { "Rio de Janeiro" }
    country { "Brazil" }
  end
end
