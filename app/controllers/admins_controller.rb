class AdminsController < ApplicationController

  before_action :logged_in?, :is_admin?

  def index
    @users = User.all
  end

  def role_to_user
    user = User.find(params[:id])
    user.update_attribute(:role, 0)
    redirect_back(fallback_location: root_path)
  end 
  
  def role_to_moderator
    user = User.find(params[:id])
    user.update_attribute(:role, 1)
    redirect_back(fallback_location: root_path)
  end 

  def role_to_admin
    user = User.find(params[:id])
    user.update_attribute(:role, 2)
    redirect_back(fallback_location: root_path)
  end 
end