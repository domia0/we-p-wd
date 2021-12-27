class LikesController < ApplicationController
    def new
        @like = Like.new
    end

    def create
        @meme = Meme.find(params[:meme_id])
        @like = current_user.likes.create!(likeable: @meme)
    end
end
