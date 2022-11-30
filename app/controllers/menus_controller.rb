class MenusController < ApplicationController
  def show
    # @recipes = Recipe.where => return une liste en fonction des settings
    @menu = Menu.find(params[:id])
    @recipes = Recipe.where(["pork_free = ? AND fish_free = ? AND dairy_free = ? AND vegetarian = ? AND gluten_free = ? AND sugar_conscious = ?",
      @menu.pork_free, @menu.fish_free, @menu.dairy_free, @menu.vegetarian, @menu.gluten_free, @menu.sugar_conscious])
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

  private

  def menu_params
    params.require(:menu).permit(:bugdet, :number_of_people, :number_of_recipes)
  end
end
