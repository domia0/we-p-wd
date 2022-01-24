class ReportsController < ApplicationController

  before_action :logged_in?, :blocked?

  def create
    if params[:comment_id] == nil
      @meme = Meme.find(params[:meme_id])
      reason = params[:report][:reason]
      @report = current_user.reports.build(reason: reason, open: true, reportable: @meme)
      unless @report.save
        flash[:error] = t('error')
        redirect_to root_path
      end
    else
      @comment = Comment.find(params[:comment_id])
      reason = params[:report][:reason]
      @report = current_user.reports.build(reason: reason, open: true, reportable: @comment)
      unless @report.save
        flash[:error] = t('error')
        redirect_to root_path
      end
    end
  end

  def destroy
    @report = Report.find(params[:id])
    @report.destroy

    redirect_back(fallback_location: root_path)
  end 

  def change_status
    @report = Report.find(params[:id])
    if @report.open == true
      @report.update_attribute(:open, false)
    else 
      @report.update_attribute(:open, true)
    end
    redirect_back(fallback_location: root_path)
  end
end
