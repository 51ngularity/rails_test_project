FactoryBot.define do
  factory :product do
    name  { "valid name" }
    description { "valid description" }
  end

  factory :random_product, class: Product do
    name  { Faker::Company.unique.name }
    description { Faker::Company.catch_phrase }
  end
end
