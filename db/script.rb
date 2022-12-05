require 'recipe'

def diets(ingredient_name, recipe)
  recipe.pork_free = false if ingredient_name.include? "pork"
  recipe.fish_free = false if ingredient_name.include? "fish"
  recipe.dairy_free = false if ingredient_name.include? "milk"
  recipe.sugar_conscious = false if ingredient_name.include? "sugar"
  recipe.save!
end

Recipe.all.each do |recipe|
  recipe.pork_free = true
  recipe.fish_free = true
  recipe.dairy_free = true
  recipe.sugar_conscious = true

  recipe.ingredients.each do |ingredient|
    diets(ingredient.name, recipe)
  end
end
