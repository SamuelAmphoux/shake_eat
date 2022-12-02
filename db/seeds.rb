require "json"
require "open-uri"

# https://api.edamam.com/api/recipes/v2?type=public&random=true&app_id=50212685&app_key=c18db5713a9acae377c0803ae0f745c4&mealType=Dinner&imageSize=LARGE"

# reset db
puts "Resetting database..."
Recipe.destroy_all
Ingredient.destroy_all
User.destroy_all
puts "Creating 20 recipes..."

#Utils
@found = 0
@not_found = 0

@all_mesures = {}

def convert(quantity, measure)
  quantity = quantity.to_f
  p quantity
  p measure
  case measure
  when "bunch"
    quantity * 0.5
  when "leaf"
    nil
  when "chop"
    quantity * 0.4
  when "kilogram"
    quantity
  when "sprig"
    quantity * 0.002
  when "pinch"
    quantity * 0.001
  when "fluid ounce"
    quantity * 0.0295735
  when "fillet"
    quantity * 0.12
  when "cap"
    quantity
  when "strip"
    quantity
  when "splash"
    quantity * 0.01
  when "gram"
    quantity * 0.001
  when "milliliter"
    quantity * 0.001
  when "tablespoon"
    quantity * 0.0147868
  when nil
    nil
  when "pound"
    quantity * 0.453592
  when "clove"
    quantity
  when "teaspoon"
    quantity * 0.00492892
  when "ounce"
    nil
  when "<unit>"
    quantity
  when "pint"
    quantity
  when "cup"
    quantity * 0.236588
  when "slice"
    quantity * 0.4
  when "gram"
    quantity * 0.001
  when "handful"
    quantity * 0.2
  when "package"
    quantity
  when "stalk"
    quantity
  when "stick"
    quantity
  else
    nil
  end
end


def getPrice(ingredient)
  ingredient.gsub!(" ", "+")
  url = "https://groceries.asda.com/p13nservice/recommendations?storeId=4565&shipDate=currentDate&amendFlag=false&placement=search_page.search1_mab&searchTerm=#{ingredient}&searchQuery=#{ingredient}&includeSponsoredProducts=false&pageType=SEARCH&pageResults=910000329132%7C910000565181%7C910000455372%7C910000455358%7C1000371550394%7C1000302042986%7C1000083677352%7C1000371550332%7C910000328893%7C1000094333951%7C1000094334019%7C910001331807%7C910001183647%7C910001330995%7C1000242609281%7C1000094333993%7C910002139268%7C1000242609507%7C1000242609418%7C1000242609542%7C1000242609348%7C910001331193%7C910001256210%7C910001331711%7C1000242609329%7C1000186791458%7C910001524140%7C1000242609572%7C1000209848461%7C910001327503%7C910001256396%7C1000154717059%7C910002379839%7C1000242609455%7C1000242609280%7C1000202076059%7C465888%7C910001440140%7C910001257216%7C910001256410%7C910000542825%7C910001509649%7C13307594%7C77092331%7C1000345488031%7C910002379934%7C910001331818%7C1000383107872%7C38261%7C1000299625445%7C1000013419915%7C910001327501%7C1000299625409%7C910001439248%7C1227041%7C1000383133061%7C910003245128%7C399016%7C910000418944%7C910000419159%7C691647%7C20534%7C1000186791338%7C1000186791277%7C69885076%7C24771300&recipeProductcount="
  url.gsub!(/\\.{5}/, "")
  url.gsub!("%", "")
  begin
    doc = JSON.load(URI.open(url))
  rescue Exception
    if ingredient.include?("+")
      return getPrice(ingredient.split("+").sort_by {|x| x.length}.last)
    else
      return {price: 0, unit: "g"}
    end
  end

  if ((doc["results"].nil? || doc["results"][0].nil?) || doc["results"][0]["items"][0]["name"] == "ASDA Finely Sliced Honey Roast Dry Cured Ham") && ingredient.include?("+")
    return getPrice(ingredient.split("+").sort_by {|x| x.length}.last)
  elsif (doc["results"].nil? || doc["results"][0].nil?) || doc["results"][0]["items"][0]["name"] == "ASDA Finely Sliced Honey Roast Dry Cured Ham"
    return {price: 0, unit: "g"}
  end

  doc["results"][0]["items"].each do |item|
    if item["pricePerUOM"]
      result = item["pricePerUOM"]
      all_price = result.split("/")[0]
      all_qt = result.split("/")[1]
      price = all_price.match(/\d+\.?\d*/).to_s.to_f ? all_price.match(/\d+\.?\d*/).to_s.to_f : 0
      price_unit = all_price.match(/[a-zA-Z£]+/).to_s ? all_price.match(/[a-zA-Z£]+/).to_s : "g"
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
    return getPrice(ingredient.split("+").sort_by {|x| x.length}.last)
  else
    return {price: 0, unit: "g"}
  end
end

@nbr_ban = 0

def generate_recipe()
  url = "https://api.edamam.com/api/recipes/v2?type=public&"
  app_id = 50212685
  app_key = "c18db5713a9acae377c0803ae0f745c4"
  begin
    response = JSON.load(URI.open("#{url}random=true&app_id=#{app_id}&app_key=#{app_key}&mealType=Dinner&imageSize=LARGE"))
  rescue Exception
    sleep(60)
    puts "on a eu un ban chef !"
    @nbr_ban += 1
    puts @nbr_ban
    return generate_recipe
  end
  response["hits"].each do |hit|
    recipe = Recipe.new(
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
    total_price = 0
    @recip = {}
    @good = true
    hit["recipe"]["ingredients"].each do |ingredient|
      price = getPrice(ingredient["food"])
      p price
      @all_mesures[ingredient["measure"]] = ingredient

      price_f = convert(ingredient["quantity"], ingredient["measure"]) ? (price[:price] * convert(ingredient["quantity"], ingredient["measure"])) : 0
      return @good = false if price_f == 0

      p convert(ingredient["quantity"], ingredient["measure"])
      p price_f
      total_price += price_f
      unit = price[:unit]
      @recip[Ingredient.create!(
        name: ingredient["food"],
        image_url: ingredient["image"],
        unit_price: price_f,
        price: price[:price].to_f,
        quantity: ingredient["quantity"].to_f,
        unit: unit
      )] = ingredient["quantity"]

    end

    p @good

    recipe.price = total_price.round(2)

    if recipe.price < 15 && @good
      puts "Nouvelle recette trouvée: #{recipe.name} \n
      Prix: #{recipe.price} \n
      Total : #{Recipe.count} / 100"
      @recip.each do |key, value|
        RecipeIngredient.new(
          recipe: recipe,
          ingredient: key,
          quantity: value
        ).save!
      end
      recipe.save!
    end
  end
end

while Recipe.count < 500
  generate_recipe
end
puts "Finished!"
puts Recipe.all
p @all_mesures
