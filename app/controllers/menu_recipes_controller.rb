class MenuRecipesController < ApplicationController
  def create
  end

  def destroy
  end

  def create_all
    @menu = Menu.new(params[:id])
    redirect_to root_path
  end

  def list_generator
    @recipe_ingredients = RecipeIngredient.all
    @recipe_ingredient = RecipeIngredient.new
    @recipe_ingredient.recipe = @recipe
    @recipe_ingredient.ingredient = @ingredient
    @recipe_ingredient.quantity = @quantity
  end

end
