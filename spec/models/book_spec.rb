require 'rails_helper'

RSpec.describe Book, type: :model do
  subject(:book) { FactoryBot.build(:book) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:author) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:owner).class_name('User') }
  end

  context 'with valid attributes' do
    it { is_expected.to be_valid }
  end

  context 'with invalid attributes' do
    it 'is invalid without a title' do
      book.title = nil
      expect(book).to_not be_valid
    end

    it 'is invalid without an author' do
      book.author = nil
      expect(book).to_not be_valid
    end

    it 'is invalid if categories include other data types than integer' do
      book.categories << 1.2
      expect(book).to_not be_valid

      book.categories.pop
      book.categories << 'string'
      expect(book).to_not be_valid

      book.categories.pop
      book.categories << []
      expect(book).to_not be_valid

      book.categories.pop
      book.categories << {}
      expect(book).to_not be_valid
    end
  end
end
