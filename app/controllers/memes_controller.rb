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
    # TODO muss ich hier fehler abfangen?
    if current_user &&
      !current_user.blocked &&
      I18n.available_locales.map(&:to_s).include?(meme_params[:lang])
      #Muss hier auch params gefiltert werden? --security
      @meme = current_user.memes.create(meme_params)

      # Create tag
      params[:tag].each do |t,n|
        @tag = Tag.find_by(name: n[:name])
        if @tag != nil
            if !@meme.tags.exists?(@tag[:id])
                @meme.tags << @tag
            end
        else
            @meme.tags.create({name: n[:name]})
        end   
    end
      redirect_to root_path
    elsif !current_user && current_user.blocked
      redirect_to root_path
    elsif !current_user
      flash[:alert] = "You must be logged in to upload a meme."
      redirect_to root_path
    else
      flash[:alert] = "Choose language. Either en or de."
      redirect_to root_path
    end
  end

  def destroy
    @meme = Meme.find(params[:id])
		if current_user && current_user.id == @meme.user_id
      @meme.destroy
			redirect_to root_path
		end
  end

  private

  def meme_params
    params.require(:meme).permit(:lang, :image)
  end

end
