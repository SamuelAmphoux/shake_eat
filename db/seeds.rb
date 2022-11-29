# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts "Clearing"
Recipe.destroy_all
Ingredient.destroy_all

puts "Seeding"

@recipe_all = []
@ingredients = []

10.times do
  puts "Creating Recipe n°#{@recipe_all.size}"
  recipe = Recipe.create(
    price: rand(50),
    name: Faker::Food.dish,
    description: Faker::Food.description
  )
  5.times do
    puts "Creating Ingredient n°#{Ingredient.all.size}"
    ingredient = Ingredient.create(
      name: Faker::Food.ingredient,
      unit: Faker::Food.metric_measurement,
      unit_price: rand(2)
    )

    RecipeIngredient.create!(
      recipe: recipe,
      ingredient: ingredient,
      quantity: rand(10)
    )
  end
  @recipe_all << recipe
end

puts "Finished Creating Recipes and Ingredients"
puts "Finished seeding"
