class AddImageUrl < ActiveRecord::Migration[7.0]
  def change
    add_column :recipes, :image_url, :string
    add_column :ingredients, :image_url, :string
  end
end
