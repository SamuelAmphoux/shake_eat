# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts "Clearing"
Recipe.destroy_all

puts "Seeding"
recipe = Recipe.create(price: 10, name: "Recette Test")
puts "Finished seeding"
puts recipe.name
