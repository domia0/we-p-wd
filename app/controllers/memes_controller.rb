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
      #Hier kommt eine Fehler undefinded user_id obwohl es in der Lnosle funktioniert
      #@tag = @meme.tags.create({name: params[:tag][:name]})
      redirect_to root_path
    elsif !current_user && current_user.blocked
      # TODO later: send back json with error
      redirect_to root_path
    elsif !current_user
      flash[:alert] = "You must be logged in to upload a meme."
      # TODO later: send back json with error
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
