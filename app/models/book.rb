class Book < ApplicationRecord
  belongs_to :owner, class_name: 'User'

  validates :title, presence: true
  validate :validate_categories

  private

  def validate_categories
    errors.add(:categories, :invalid) if !categories.is_a?(Array) || categories.any? { |item| item.class != Integer }
  end
end
