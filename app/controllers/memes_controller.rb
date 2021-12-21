class MemesController < ApplicationController
    def index
        @memes = Meme.all
    end
    
    def show
        @meme = Meme.find(params[:id])
    end
    
    def new
        @meme = Meme.new
    end
    
    def create
        #muss ich hier fehler abfangen?
        @meme = current_user.memes.create(meme_params)
        redirect_to @meme
    end
    
    def destroy
        @meme = Meme.find(params[:id])
        @meme.destroy
    
        redirect_to root_path
    end 
      

    private
        def meme_params
            params.require(:meme).permit(:lang, :image)
        end
end
