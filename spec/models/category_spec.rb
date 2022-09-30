require 'rails_helper'

RSpec.describe Category, type: :model do
  subject { FactoryBot.build(:category) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  describe 'associations' do
    it { should belong_to(:owner).class_name('User') }
  end

  context 'with valid name' do
    it { should be_valid }
  end

  context 'with not valid name' do
    it 'is not valid without a name' do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid with not unique name' do
      FactoryBot.create(:category, name: 'Horror')
      subject.name = 'Horror'

      expect(subject).to_not be_valid
    end
  end
end
