class LikesController < ApplicationController
  def create
    @like = LikesUser.create()
    @like.user = current_user
    @like.recipe = Recipe.find(params[:id])
    if @like.save!
      render json: {
        success: true,
      }
    else
      render json: {
        success: false
      }
    end
  end

  def destroy
    @like = LikesUser.where(user: current_user, recipe: Recipe.find(params[:id])).first
    if @like.destroy!
      render json: {
        success: true,
      }
    else
      render json: {
        success: false
      }
    end
  end
end
