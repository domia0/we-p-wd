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
        lang = params[:meme][:lang]
        if (current_user) && (lang == "de" || lang == "en")
            @meme = current_user.memes.create(meme_params)
            redirect_to @meme
        elsif !current_user
            flash[:alert] = "You must be logged in to upload a meme."
            redirect_to memes_path
        elsif lang != "de" || lang != "en"
            flash[:alert] = "Choose language. Either en or de."
            redirect_to memes_path
        end
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
