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
      @meme = current_user.memes.create(meme_params)

      # Create tags if necessary or find tag by name
      tags = []
      params[:tags].each do |tag|
        unless tag[1].empty?
          if Tag.where(name: tag[1]).count > 0
            tags.push(Tag.where(name: tag[1])[0])
          else
            Tag.new(name: tag[1]).save
            tags.push(Tag.where(name: tag[1])[0])
          end
        end
      end
      @meme.tags = tags
      @meme.save

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
    # TODO check ob ein User einen Meme loeschen darf
    @meme = Meme.find(params[:id])
    @meme.destroy
    redirect_to root_path
  end

  private

  def meme_params
    params.require(:meme).permit(:lang, :image)
  end

end
