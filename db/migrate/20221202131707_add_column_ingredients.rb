class AddColumnIngredients < ActiveRecord::Migration[7.0]
  def change
    add_column :ingredients, :quantity, :float
    add_column :ingredients, :price, :float
  end
end
