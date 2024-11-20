class Post < ApplicationRecord
 has_one_attached :image
 validates :image, presence: true
 validates :description, presence: true, length: { minimum: 10}
 belongs_to :user
end
