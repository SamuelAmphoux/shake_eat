class AddFiltersToMenu < ActiveRecord::Migration[7.0]
  def change
    add_column :menus, :pork_free, :boolean, default: false
    add_column :menus, :fish_free, :boolean, default: false
    add_column :menus, :dairy_free, :boolean, default: false
    add_column :menus, :vegetarian, :boolean, default: false
    add_column :menus, :gluten_free, :boolean, default: false
    add_column :menus, :sugar_conscious, :boolean, default: false
  end
end
