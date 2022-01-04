class CommentsController < ApplicationController

	def create
	  @meme = Meme.find(params[:meme_id])
		body = params[:comment][:body]
	  @comment = current_user.comments.create!(body: body, meme_id: @meme.id)
	  # redirect_to meme_path(@meme)
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

	def show_all_comments_for_meme
		@comments = Comment.where(meme: params[:meme_id])
		@result = []
		@comments.each do |comment|
			entry = {}
			entry.store('id', 			comment.id)
			entry.store('meme_id', 	comment.meme_id)
			entry.store('userName', comment.user.username)
			entry.store('comment',  comment.body)
			entry.store('date', 	  comment.created_at.strftime("%d.%m.%Y"))
			entry.store('likes', 	  comment.likes.count)
			likes = Comment.find(comment.id).likes.where(user_id: current_user&.id)
			if likes.length > 0
				entry.store('liked',   'yes')
				entry.store('like_id', likes[0].id)
				entry.store('user_id', likes[0].user_id)
			end
			@result.push(entry)
		end
		render json: @result.reverse
	end

	private
	def comment_params
		params.require(:comment).permit(:body)
	end

end
