class DashboardsController < ApplicationController
  def show
    @user = current_user.email.split("@").first
    @recipes = Recipe.all.shuffle.first(10)
    @recipe_ingredients = @recipes.first.recipe_ingredients.all
    @menu = Menu.last
  end
end
