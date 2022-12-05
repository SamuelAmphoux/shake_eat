class MenusController < ApplicationController
  def show
    @menu = Menu.find(params[:id])

    @recipes = Recipe.all

    @recipes = @recipes.where(["pork_free = ? ", @menu.pork_free?]) if @menu.pork_free? == true

    @recipes = @recipes.where(["fish_free = ?", @menu.fish_free?]) if @menu.fish_free? == true

    @recipes = @recipes.where(["vegetarian = ?", @menu.vegetarian?]) if @menu.vegetarian? == true

    @recipes = @recipes.where(["gluten_free = ?", @menu.gluten_free?]) if @menu.gluten_free? == true

    @recipes = @recipes.where(["sugar_conscious = ?", @menu.sugar_conscious?]) if @menu.sugar_conscious? == true

    @recipes = @recipes.where(["dairy_free = ?", @menu.dairy_free?]) if @menu.dairy_free? == true

    @recipes = @recipes.where(["price <= ?", @menu.budget / (@menu.number_of_people * @menu.number_of_recipes)]) if @menu.budget

    @recipes = @recipes.sample(@menu.number_of_recipes)
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
    @recipe_ingredients = @menu.recipe_ingredients.all
  end

  private

  def menu_params
    params.require(:menu).permit(
      :budget,
      :number_of_people,
      :number_of_recipes,
      :pork_free,
      :fish_free,
      :dairy_free,
      :vegetarian,
      :gluten_free,
      :sugar_conscious
    )
  end
end
