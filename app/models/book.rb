class Book < ApplicationRecord
  belongs_to :owner, class_name: 'User'

  validates :title, :author, presence: true
  validate :validate_categories

  enum status: { "idea": 0, "to read": 1, "read": 2, "to buy": 3 }

  default_scope { order(:title) }

  private

  def validate_categories
    errors.add(:categories, :invalid) if !categories.is_a?(Array) || categories.any? { |item| item.class != Integer }
  end
end
