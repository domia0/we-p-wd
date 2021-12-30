class TagsController < ApplicationController

    def create
        @meme = Meme.find(params[:meme_id])
        @tag = @meme.tags.create(name: params[:tag][:name])
    end
    
   # private 
  #  def tag_params
    #    params.require(:tag).permit(meme_ids[])
    #end

    
end
