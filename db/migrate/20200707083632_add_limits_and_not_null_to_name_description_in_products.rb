class AddLimitsAndNotNullToNameDescriptionInProducts < ActiveRecord::Migration[6.0]
  def change
    Product.where(name: nil).update_all(name: "placeholder: #{Faker::Company.unique.name}")
    Product.where(description: nil).update_all(description: "placeholder: #{Faker::Company.catch_phrase}")

    change_column :products, :name, :string, null: false, limit: 100
    change_column :products, :description, :text, null: false, limit: 2000
  end
end
