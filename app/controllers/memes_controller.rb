class MemesController < ApplicationController

  before_action :logged_in?
  before_action :blocked?

  def index
    @memes = Meme.all
  end

  def show
    @meme = Meme.find(params[:id])
  end

  def create
      @meme = current_user.memes.build(meme_params)

      if @meme.save
        redirect_to root_path
      else
        flash[:error] = "Sth. went wrong"
        redirect_to root_path
      end
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
  end

  def destroy
    @meme = Meme.find(params[:id])
		if current_user.id == @meme.user_id
      @meme.destroy
			redirect_to root_path
		end
  end

  private

  def meme_params
    params.require(:meme).permit(:lang, :image)
  end

end
