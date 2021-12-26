class LikesController < ApplicationController
    def new
        @like = Like.new
      end

    def do_like
        @meme = Meme.find(1)
        @like = current_user.likes.create!(likeable_id: @meme.id, likeable_type: "Meme")
        #redirect_to root_path
    end
end
