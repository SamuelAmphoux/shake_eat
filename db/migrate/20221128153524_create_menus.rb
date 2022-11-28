class CreateMenus < ActiveRecord::Migration[7.0]
  def change
    create_table :menus do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :budget
      t.integer :number_of_people
      t.integer :number_of_recipes

      t.timestamps
    end
  end
end
