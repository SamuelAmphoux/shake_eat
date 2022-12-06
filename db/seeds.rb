require 'json'
require 'open-uri'

# All variables

@recipe_api_url = "https://api.spoonacular.com/recipes/random?apiKey=42383472d8894e679cdd0bb518016c24&number=1&type=main_course"

## Utils

def clean_db
  puts '[Clean-DB] Cleaning database...'
  RecipeIngredient.destroy_all
  MenuRecipe.destroy_all
  Ingredient.destroy_all
  Recipe.destroy_all
  Menu.destroy_all
  User.destroy_all
  puts '[Clean-DB] Database cleaned!'
end

def diets(ingredient_name, recipe)
  recipe.pork_free = false if ingredient_name.include? "pork"
  recipe.fish_free = false if ingredient_name.include? "fish"
  recipe.dairy_free = false if ingredient_name.include? "milk"
  recipe.sugar_conscious = false if ingredient_name.include? "sugar"
  recipe.save!
end

def creating_recipe
  # Call recipe api
  begin
    response_recipe = JSON.load(URI.open(@recipe_api_url))
  rescue => e
    puts "[Recipe-API] Error: #{e}"
    puts "[Recipe-API] Waiting 60 seconds..."
    sleep(60)
    puts "[Recipe-API] Retrying..."
    return creating_recipe
  end

  # Try to create recipe
  response_recipe["recipes"].each do |recipe|
    new_recipe = Recipe.create!(
      name: recipe["title"],
      image_url: recipe["image"],
      pork_free: true,
      fish_free: true,
      dairy_free: true,
      vegetarian: recipe["vegetarian"],
      gluten_free: recipe["glutenFree"],
      sugar_conscious: true,
      price: (recipe["pricePerServing"] / 100).round(2)
    )

    # Try to create ingredients
    begin
      response_ingredient = JSON.load(URI.open("https://api.spoonacular.com/recipes/#{recipe["id"]}/priceBreakdownWidget.json?apiKey=38112ec2a1c04ddda48fae9a3e04263d"))
    rescue => exception
      puts "[Recipe-API] Error: #{e}"
      puts "[Recipe-API] Waiting 60 seconds..."
      sleep(60)
      puts "[Recipe-API] Retrying..."
      return creating_recipe
    end

    response_ingredient["ingredients"].each do |ingredient|
      diets(ingredient["name"], new_recipe)

      ingredient = Ingredient.create!(
        name: ingredient["name"],
        image_url: "https://spoonacular.com/cdn/ingredients_500x500/#{ingredient["image"]}",
        quantity: ingredient["amount"]["metric"]["value"],
        unit_price: 0,
        price: (ingredient["price"] / 100).round(2),
        unit: ingredient["amount"]["metric"]["unit"]
      )
      # Try to create recipe_ingredients
      RecipeIngredient.create!(
        recipe: new_recipe,
        ingredient: ingredient
      )
    end
  end
end

## Main
# cleanDB
puts 'You want clean the database? (y/n)'
clean_db if gets.chomp == 'y'

# creating recipes
puts 'How many recipes do you want to create?'
@number_recipes = gets.chomp.to_i
puts "Creating #{@number_recipes} recipes..."

@number_recipes.times do
  creating_recipe
end
