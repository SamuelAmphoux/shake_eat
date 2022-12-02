class MenusController < ApplicationController
  def show
    # @recipes = Recipe.where => return une liste en fonction des settings
    @menu = Menu.find(params[:id])
    # @recipes = Recipe.all.first(5)
    if
      ["pork_free = ?
      AND fish_free = ?
      AND dairy_free = ?
      AND vegetarian = ?
      AND gluten_free = ?
      AND sugar_conscious = ?",
      @menu.pork_free == false,
      @menu.fish_free == false,
      @menu.dairy_free == false,
      @menu.vegetarian == false,
      @menu.gluten_free == false,
      @menu.sugar_conscious == false]
      @recipes = Recipe.all
    else
      @recipes = Recipe.where(["pork_free = ? AND fish_free = ? AND dairy_free = ? AND vegetarian = ? AND gluten_free = ? AND sugar_conscious = ?",
      @menu.pork_free, @menu.fish_free, @menu.dairy_free, @menu.vegetarian, @menu.gluten_free, @menu.sugar_conscious])
    end
  end

  def new
    @menu = Menu.new
  end

  def create
    @menu = Menu.new(menu_params)
    @menu.user = current_user

    if @menu.save!
      redirect_to menu_path(@menu)
    else
      render :new, status: :unprocessable_entity
    end

  end

  def grocery_list
    @menu = Menu.find(params[:menu_id])
    @ingredients = @menu.recipe_ingredients.all
  end

  private

  def menu_params
    params.require(:menu).permit(:budget, :number_of_people, :number_of_recipes,
      :pork_free, :fish_free, :dairy_free, :vegetarian, :gluten_free, :sugar_conscious)
  end
end
