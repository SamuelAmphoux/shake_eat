class DashboardsController < ApplicationController
  def show
    @recipe = Recipe.all.sample
  end

end
