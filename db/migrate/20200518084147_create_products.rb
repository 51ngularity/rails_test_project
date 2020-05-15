class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name, limit: 100
      t.text :description, limit: 10000
    end
  end
end
