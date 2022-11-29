class MenuRecipesController < ApplicationController
  def create
  end

  def destroy
  end

  def create_all
    @menu = Menu.new(params[:id])
    redirect_to root_path
  end
end
