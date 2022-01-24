class MemesController < ApplicationController

  before_action :logged_in?, :blocked?
  before_action :is_moderator?, only: [:index, :show]

  def index
    @memes = Meme.all
  end

  def show
    @meme = Meme.find(params[:id])
  end

  def create
      @meme = current_user.memes.build(meme_params)
      if @meme.save
        @meme.tags_attr(params[:tag])
        redirect_to root_path
      else
        flash[:error] = t('error')
        redirect_to root_path
      end 
  end

  def destroy
    @meme = Meme.find(params[:id])
    if current_user.moderator? || current_user.admin?
      @meme.destroy 
      redirect_back(fallback_location: root_path)
		elsif current_user.id == @meme.user_id
      @meme.destroy
			redirect_to root_path
    end
  end

  private

  def meme_params
    params.require(:meme).permit(:lang, :image)
  end
end
