class AddUrlToRecipe < ActiveRecord::Migration[7.0]
  def change
    add_column :recipes, :url, :string
  end
end
