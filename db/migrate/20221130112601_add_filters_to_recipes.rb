class AddFiltersToRecipes < ActiveRecord::Migration[7.0]
  def change
    add_column :recipes, :pork_free, :boolean, default: false
    add_column :recipes, :fish_free, :boolean, default: false
    add_column :recipes, :dairy_free, :boolean, default: false
    add_column :recipes, :vegetarian, :boolean, default: false
    add_column :recipes, :gluten_free, :boolean, default: false
    add_column :recipes, :sugar_conscious, :boolean, default: false
  end
end
