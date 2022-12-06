class CreateTableLikeUser < ActiveRecord::Migration[7.0]
  def change
    create_table :likes_users do |t|
      t.references :user, foreign_key: true
      t.references :recipe, foreign_key: true
    end
  end
end
