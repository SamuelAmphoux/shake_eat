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

#Utils

def getPrice(ingredient)
  url = "https://groceries.asda.com/p13nservice/recommendations?storeId=4565&shipDate=currentDate&amendFlag=false&placement=search_page.search1_mab&searchTerm=#{ingredient}&searchQuery=#{ingredient}&includeSponsoredProducts=false&pageType=SEARCH&pageResults=910000329132%7C910000565181%7C910000455372%7C910000455358%7C1000371550394%7C1000302042986%7C1000083677352%7C1000371550332%7C910000328893%7C1000094333951%7C1000094334019%7C910001331807%7C910001183647%7C910001330995%7C1000242609281%7C1000094333993%7C910002139268%7C1000242609507%7C1000242609418%7C1000242609542%7C1000242609348%7C910001331193%7C910001256210%7C910001331711%7C1000242609329%7C1000186791458%7C910001524140%7C1000242609572%7C1000209848461%7C910001327503%7C910001256396%7C1000154717059%7C910002379839%7C1000242609455%7C1000242609280%7C1000202076059%7C465888%7C910001440140%7C910001257216%7C910001256410%7C910000542825%7C910001509649%7C13307594%7C77092331%7C1000345488031%7C910002379934%7C910001331818%7C1000383107872%7C38261%7C1000299625445%7C1000013419915%7C910001327501%7C1000299625409%7C910001439248%7C1227041%7C1000383133061%7C910003245128%7C399016%7C910000418944%7C910000419159%7C691647%7C20534%7C1000186791338%7C1000186791277%7C69885076%7C24771300&recipeProductcount="
  doc = JSON.load(URI.open(url))
  ingredient.gsub!(" ", "+")
  p url
  if (doc["results"].nil? || doc["results"][0]["items"][0]["name"] == "ASDA Finely Sliced Honey Roast Dry Cured Ham") && ingredient.include?("+")
    getPrice(ingredient.split("+").sort_by {|x| x.length}.last)
  elsif doc["results"].nil? || doc["results"][0]["items"][0]["name"] == "ASDA Finely Sliced Honey Roast Dry Cured Ham"
    return 0
  end

  doc["results"][0]["items"].each do |item|
    if item["pricePerUOM"]
      result = item["pricePerUOM"]
      all_price = result.split("/")[0]
      all_qt = result.split("/")[1]
      price = all_price.match(/\d+\.?\d*/).to_s.to_f
      price_unit = all_price.match(/[a-zA-Z£]+/).to_s
      qt = all_qt.match(/\d+\.?\d*/).to_s.to_f
      qt_unit = all_qt.match(/[a-zA-Z]+/).to_s

      # Si le prix est au ml ou au g nous multiplions par 1000 pour l'avoir au kg/L
      qt = 1 if qt == 0
      price = ((price / qt) * 1000).to_f if qt_unit.include?("ml") || (!qt_unit.include?("kg") && !qt_unit.include?("each"))

      (price /= 100).to_f if price_unit == "p"

      case qt_unit
      when "g"
        qt_unit = "kg"
      when "ml"
        qt_unit = "L"
      when "each"
        qt_unit = "p"
      end
      return { price: price.round(2), unit: qt_unit }
    end
  end
  if ingredient.include?("+")
    getPrice(ingredient.split("+").sort_by {|x| x.length}.last)
  else
    return 0
  end
end

@found = 0
@not_found = 0

# reset db
puts "Resetting database..."
Recipe.destroy_all
Ingredient.destroy_all
User.destroy_all
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
    price = getPrice(ingredient["food"])

    if price == 0
      puts "Ingredient not found: #{ingredient["food"]}"
      price_f = 0
      unit = 0
      @not_found += 1
    else
      price_f = price[:price]
      unit = price[:unit]
      @found += 1
    end
    puts "Found #{@found} ingredients, #{@not_found} not found"
    ingredient = Ingredient.create!(
      name: ingredient["text"],
      image_url: ingredient["image"],
      unit_price: price_f,
      unit: unit
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
p "Ingredient #{@t} echec : #{@pf}"
