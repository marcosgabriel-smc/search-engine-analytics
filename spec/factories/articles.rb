FactoryBot.define do
  factory :article do
    title { "Article Title" }
    content { "This is the article content. It is a mock content with at least 300 characters. " + ("a" * 300)}
  end
end
