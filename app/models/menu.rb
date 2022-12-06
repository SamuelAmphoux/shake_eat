class Menu < ApplicationRecord
  belongs_to :user
  has_many :menu_recipes, dependent: :destroy
  has_many :recipes, through: :menu_recipes
  has_many :recipe_ingredients, through: :recipes
  has_many :ingredients, through: :recipe_ingredients

  validates :budget, :number_of_people, :number_of_recipes, presence: true
end
