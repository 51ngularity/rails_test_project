# frozen_string_literal: true

# class documentation comment placeholder
class Product < ApplicationRecord
  validates :name, presence: true, length: { minimum: 3, maximum: 100 }, uniqueness: { case_sensitive: false }
  validates :description, presence: true, length: { minimum: 10, maximum: 5000 }
end
