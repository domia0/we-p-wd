class MemesController < ApplicationController

  before_action :authenticate_user!, except: [:index]

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
      # Create tags if necessary or find tag by name
      #tags = []
      #params[:tags].each do |tag|
       # unless tag[1].empty?
        #  if Tag.where(name: tag[1]).count > 0
         #   tags.push(Tag.where(name: tag[1])[0])
         # else
          #  Tag.new(name: tag[1]).save
           # tags.push(Tag.where(name: tag[1])[0])
        #  end
       # end
      #end
      #@meme.tags = tags
      #if @meme.save
       # redirect_to root_path
      #elsif
       # render :new
      #end
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
			#redirect_to meme_path(@meme)
		end
  end

  private

  def meme_params
    params.require(:meme).permit(:lang, :image)
  end

end
