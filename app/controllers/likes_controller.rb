class LikesController < ApplicationController

  def new
    @like = Like.new
  end

  def create
    @meme = Meme.find(params[:meme_id])
    @like = current_user.likes.create!(likeable: @meme)

    respond_to do |format|
      format.html { redirect_to @meme }
      format.js
      format.json { render json: @meme, location: @meme }
    end
  end
  
  def destroy
    @meme = Meme.find(params[:meme_id])
    @like = Like.where(user_id: current_user.id, likeable_id: @meme.id)
    @like[0].destroy if @like.count == 1
  end

end
