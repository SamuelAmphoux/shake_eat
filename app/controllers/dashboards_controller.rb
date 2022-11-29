class DashboardsController < ApplicationController
  def show
    @recipe = Recipe.new
  end

end
