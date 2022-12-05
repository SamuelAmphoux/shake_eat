class DashboardsController < ApplicationController
  def show
    @recipe = Recipe.all.sample
    @menu = Menu.last
  end
end
