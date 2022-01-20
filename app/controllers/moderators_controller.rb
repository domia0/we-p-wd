class ModeratorsController < ApplicationController

  before_action :logged_in?
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



end