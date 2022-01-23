class MemesController < ApplicationController

  before_action :logged_in?, :blocked?
  before_action :is_moderator?, only: [:index, :show]

  def index
    @memes = Meme.all
  end

  def show
    @meme = Meme.find(params[:id])
  end

  def create
      @meme = current_user.memes.build(meme_params)
      if @meme.save
=begin
        params[:tag].each do |key, value|
          @meme.make_tag(value[:name])
        end
=end

        params[:tag].each do |t,n|
        #If tag already exists in db, get the existing tag and make association with created meme

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
      else
        flash[:error] = "Sth. went wrong"
        redirect_to root_path
      end
      # Create tag
      
  end

  def destroy
    @meme = Meme.find(params[:id])
    if current_user.moderator? || current_user.admin?
      @meme.destroy 
      redirect_to "/moderators"
		elsif current_user.id == @meme.user_id
      @meme.destroy
			redirect_to root_path
    end
  end

  private

  def meme_params
    params.require(:meme).permit(:lang, :image)
  end

end
