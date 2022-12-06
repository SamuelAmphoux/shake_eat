class RecipesController < ApplicationController
  def show
    @recipe = Recipe.find(params[:id])
  end

  def more_recipes

  end

  private

  def recipe_params
    params.require(:recipe).permit(:price, :name, :description)
  end
end
