class Product < ApplicationRecord 
  validates :name, presence: true, length: { minimum: 3, maximum: 100}
  validates :description, presence: true, length: { minimum: 10, maximum: 5000}
end