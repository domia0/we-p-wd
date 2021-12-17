class HomesController < ApplicationController

  def index
    @user = User.find(current_user.id) if current_user
  end

end
