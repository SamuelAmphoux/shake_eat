class MenusController < ApplicationController
  def show
    @menu = Menu.find(params[:id])

    if @menu.pork_free? == true
      @recipes = Recipe.where(["pork_free = ? ", @menu.pork_free?])
    elsif @menu.fish_free? == true
      @recipes = Recipe.where(["fish_free = ?", @menu.fish_free?])
    elsif @menu.vegetarian? == true
      @recipes = Recipe.where(["vegetarian = ?", @menu.vegetarian?])
    elsif @menu.gluten_free? == true
      @recipes = Recipe.where(["gluten_free = ?", @menu.gluten_free?])
    elsif @menu.sugar_conscious? == true
      @recipes = Recipe.where(["sugar_conscious = ?", @menu.sugar_conscious?])
    elsif @menu.dairy_free? == true
      @recipes = Recipe.where(["dairy_free = ?", @menu.dairy_free?])
    else
      @recipes = Recipe.all
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
