require 'rails_helper'

RSpec.describe Category, type: :model do
  subject(:category) { FactoryBot.build(:category) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:owner).class_name('User') }
  end

  context 'with valid name' do
    it { is_expected.to be_valid }
  end

  context 'with not valid name' do
    it 'is not valid without a name' do
      category.name = nil
      expect(category).to_not be_valid
    end

    it 'is not valid with not unique name' do
      FactoryBot.create(:category, name: 'Horror')
      category.name = 'Horror'

      expect(category).to_not be_valid
    end
  end
end
