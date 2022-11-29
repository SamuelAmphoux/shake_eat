class RecipesController < ApplicationController
  def show
    @recipe = Recipe.find(params[:id])
  end

  private

  def recipe_params
    params.require(:recipe).permit(:price, :name, :description)
  end
end
