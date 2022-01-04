class HomesController < ApplicationController

  def index
    @user = User.find(current_user.id) if current_user
    @meme = Meme.new
    if params[:filter]
      case params[:filter]
      when "best_today"
        # get all meme today and filter then for likes
        @memes = []
      when "best_week"
        # get all meme last week and filter then for likes
        @memes = []
      when "best_month"
        # get all meme last month and filter then for likes
        @memes = []
      when "best_all_time"
        # get all meme and filter then for likes
        @memes = []
      end
    else
      @memes = Meme.all
    end
  end

end