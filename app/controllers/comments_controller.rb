class CommentsController < ApplicationController
    def create
	    @meme = Meme.find(params[:meme_id])
		body = params[:comment][:body]
	    @comment = current_user.comments.create!(body: body, meme_id: @meme.id)

	    redirect_to meme_path(@meme)
	end

	def update
		@meme = Meme.find(params[:meme_id])
	    @comment = @meme.comments.find(params[:id])
	
		if @comment.update(comment_params)
		  redirect_to meme_path(@meme)
		else
		  #render
		end
	end

	def destroy
	    @meme = Meme.find(params[:meme_id])
	    @comment = @meme.comments.find(params[:id])
	    @comment.destroy
	    redirect_to meme_path(@meme)
	end

	private
		def comment_params
		params.require(:comment).permit(:body)
	end
end
