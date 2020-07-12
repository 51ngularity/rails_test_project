class AddTimestampsToProducts < ActiveRecord::Migration[6.0]
  def change
    add_timestamps :products, null: true

    fake_date = DateTime.new(2000, 1, 1)
    Product.update_all(created_at: fake_date, updated_at: fake_date)

    change_column_null :products, :created_at, false
    change_column_null :products, :updated_at, false
  end
end
