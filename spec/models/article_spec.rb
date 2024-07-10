# spec/models/article_spec.rb
require 'rails_helper'

RSpec.describe Article, type: :model do
  context 'validations' do

    it 'is valid with a title and content' do
      article = build(:article)
      expect(article).to be_valid
    end

    it 'is invalid without a title' do
      article = build(:article, title: nil)
      expect(article).not_to be_valid
      expect(article.errors[:title]).to include("can't be blank")
    end

    it 'is invalid without content' do
      article = build(:article, content: nil)
      expect(article).not_to be_valid
      expect(article.errors[:content]).to include("can't be blank")
    end

    it 'is invalid with a duplicate title' do
      create(:article, title: 'Unique Title')
      article = build(:article, title: 'Unique Title')
      expect(article).not_to be_valid
      expect(article.errors[:title]).to include("has already been taken")
    end

    it 'is invalid if the content has less than 300 characters' do
      content = 'a' * 299
      article = build(:article, content: content)
      expect(article).not_to be_valid
      expect(article.errors[:content]).to include("Your content must have at least 300 characters.")
    end

    it 'is valid if the content has exactly 300 characters' do
      content = 'a' * 300
      article = build(:article, content: content)
      expect(article).to be_valid
    end

    it 'is invalid if the content exceeds 3000 characters' do
      content = 'a' * 3001
      article = build(:article, content: content)
      expect(article).not_to be_valid
      expect(article.errors[:content]).to include("Your content must not exceed 3000 characters.")
    end

    it 'is valid if the content has exactly 3000 characters' do
      content = 'a' * 3000
      article = build(:article, content: content)
      expect(article).to be_valid
    end
  end
end
