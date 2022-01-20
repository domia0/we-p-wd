class LikesController < ApplicationController

  before_action :logged_in?
  before_action :blocked?

  def new
    @like = Like.new
  end

  def create
    if params[:comment_id] == nil
      @meme = Meme.find(params[:meme_id])
      @like = current_user.likes.create!(likeable: @meme)
    else
      @comment = Comment.find(params[:comment_id])
      @like = current_user.likes.build(likeable: @comment)
    end
    if @like.save
      respond_to do |format|
        format.json { render json: @like, location: @meme }
      end
    else
      flash[:error] = "Sth. went wrong"
      redirect_to root_path
    end
  end
  
  def destroy
    if params[:comment_id] == nil
      @meme = Meme.find(params[:meme_id])
      @like = @meme.likes.find_by(user_id: current_user.id, likeable: @meme)
      @like.destroy
    else
      @comment = Comment.find(params[:comment_id])
      @like = @comment.likes.find_by(user_id: current_user.id, likeable: @comment)
      @like.destroy
    end
  end

end
