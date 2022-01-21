class ReportsController < ApplicationController

  before_action :logged_in?, :blocked?

  def create
    if params[:comment_id] == nil
      @meme = Meme.find(params[:meme_id])
      reason = params[:report][:reason]
      @report = current_user.reports.build(reason: reason, open: true, reportable: @meme)
      if !@report.save
        flash[:error] = "Sth. went wrong"
        redirect_to root_path
      end
    else
      @comment = Comment.find(params[:comment_id])
      reason = params[:report][:reason]
      @report = current_user.reports.build(reason: reason, open: true, reportable: @comment)
      if !@report.save
        flash[:error] = "Sth. went wrong"
        redirect_to root_path
      end
    end
  end
end
