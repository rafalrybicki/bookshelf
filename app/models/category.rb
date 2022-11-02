class Category < ApplicationRecord
  belongs_to :owner, class_name: 'User'

  validates :name, presence: true, uniqueness: true

  scope :with_books, lambda { |user_id|
                       Category.find_by_sql(['
                        SELECT
                          categories.id,
                          categories.name,
                          COUNT(books) as size
                        FROM
                          categories
                          LEFT JOIN books ON categories.id = ANY(books.categories)
                        WHERE
                          categories.owner_id = ?
                        GROUP BY
                          categories.id
                        ORDER BY
                          categories.name
                      ', user_id])
                     }
end
