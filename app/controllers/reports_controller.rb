class ReportsController < ApplicationController
  def create
    if params[:comment_id] == nil
      @meme = Meme.find(params[:meme_id])
      reason = params[:report][:reason]
      @report = current_user.reports.create!(reason: reason, open: true, reportable: @meme)
    else
      @comment = Comment.find(params[:comment_id])
      reason = params[:report][:reason]
      @report = current_user.comments.create!(reason: reason, open: true, reportable: @comment)
      # redirect_to meme_path(@meme)
    end
  end
end
