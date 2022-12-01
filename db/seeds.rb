# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# puts "Clearing"
# Recipe.destroy_all
# Ingredient.destroy_all

# puts "Seeding"

# @recipe_all = []
# @ingredients = []

# 10.times do
#   puts "Creating Recipe n°#{@recipe_all.size}"
#   recipe = Recipe.create(
#     price: rand(50),
#     name: Faker::Food.dish,
#     description: Faker::Food.description
#   )
#   5.times do
#     puts "Creating Ingredient n°#{Ingredient.all.size}"
#     ingredient = Ingredient.create(
#       name: Faker::Food.ingredient,
#       unit: Faker::Food.metric_measurement,
#       unit_price: rand(2)
#     )

#     RecipeIngredient.create!(
#       recipe: recipe,
#       ingredient: ingredient,
#       quantity: rand(10)
#     )
#   end
#   @recipe_all << recipe
# end

# puts "Finished Creating Recipes and Ingredients"
# puts "Finished seeding"

require "json"
require "open-uri"

# https://api.edamam.com/api/recipes/v2?type=public&random=true&app_id=50212685&app_key=c18db5713a9acae377c0803ae0f745c4&mealType=Dinner&imageSize=LARGE"

url = "https://api.edamam.com/api/recipes/v2?type=public&"
app_id = 50212685
app_key = "c18db5713a9acae377c0803ae0f745c4"
# reset db
puts "Resetting database..."
Recipe.destroy_all
Ingredient.destroy_all
puts "Creating the 'yanis@gmail.com' user"
@user = User.create!(
  email: "yanis@gmail.com",
  password: "password"
)
puts "Creating 20 recipes..."
@recipes = []
response = JSON.load(URI.open("#{url}random=true&app_id=#{app_id}&app_key=#{app_key}&mealType=Dinner&imageSize=LARGE"))
response["hits"].each do |hit|
  recipe = Recipe.create!(
    name: hit["recipe"]["label"],
    image_url: hit["recipe"]["image"],
    url: hit["recipe"]["url"],
    price: 0,
    pork_free: hit["recipe"]["healthLabels"].include?("Pork-Free"),
    fish_free: hit["recipe"]["healthLabels"].include?("Fish-Free"),
    dairy_free: hit["recipe"]["healthLabels"].include?("Dairy-Free"),
    vegetarian: hit["recipe"]["healthLabels"].include?("Vegetarian"),
    gluten_free: hit["recipe"]["healthLabels"].include?("Gluten-Free"),
    sugar_conscious: hit["recipe"]["healthLabels"].include?("Sugar-Conscious")
  )
  @recipes << recipe
  hit["recipe"]["ingredients"].each do |ingredient|
    ingredient = Ingredient.create!(
      name: ingredient["text"],
      image_url: ingredient["image"],
      unit_price: 0,
      unit: ingredient["measure"]
    )
    RecipeIngredient.create!(
      recipe: recipe,
      ingredient: ingredient,
      quantity: ingredient["quantity"]
    )
  end
end
puts "Creating a menu"
@menu = Menu.create!(
  user_id: @user.id,
  budget: 150,
  number_of_people: 4,
  number_of_recipes: 4,
  pork_free: true,
  fish_free: true,
  dairy_free: false,
  vegetarian: true,
  gluten_free: false,
  sugar_conscious: false
)
@recipes.each do |recipe|
  MenuRecipe.create!(
    menu_id: @menu.id,
    recipe_id: recipe.id
  )
end
puts "Menu Created!"
puts "Finished!"
puts Recipe.all
