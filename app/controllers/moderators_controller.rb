class ModeratorsController < ApplicationController
  before_action :authenticate_user!
  #before_actions :logged_in?
  before_action :is_moderator?

  def index
    @reports = Report.all
  end

  def change_user_status
    user = User.find(params[:id])
    if user.blocked == false
      user.update_attribute(:blocked, true)
    else
      user.update_attribute(:blocked, false)
    end
    redirect_to "/moderators"
  end 

  private

  def is_moderator?
    if !current_user.moderator?
      flash[:error] = "You must be logged in as a moderator to access this section"
      redirect_to root_path
    end
  end

end