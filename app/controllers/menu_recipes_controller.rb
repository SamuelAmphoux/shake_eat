class MenuRecipesController < ApplicationController
  def create
    @menu = Menu.find(params[:menu_id])
    @recipe = Recipe.find(menu_recipe_params[:recipe_id])
    @menu_recipe = MenuRecipe.new(menu: @menu, recipe: @recipe)
    if @menu_recipe.save!
      render json: {
        success: true,
        menuRecipeId: @menu_recipe.id
      }
    else
      render json: {
        success: false
      }
    end
  end

  def destroy
    @menu = Menu.find(params[:id])
    if @menu.recipes.delete_all
      render json: {
        success: true
      }
    else
      render json: {
        success: false
      }
    end
  end

  def create_all
    @menu = Menu.find(params[:menu_id])
    # raise
    redirect_to grocery_list_path
  end

  def list_generator
    @recipe_ingredients = RecipeIngredient.all
    @recipe_ingredient = RecipeIngredient.new
    @recipe_ingredient.recipe = @recipe
    @recipe_ingredient.ingredient = @ingredient
    @recipe_ingredient.quantity = @quantity
  end

  private

  def menu_recipe_params
    params.require(:menu_recipe).permit(:recipe_id)
  end
end
