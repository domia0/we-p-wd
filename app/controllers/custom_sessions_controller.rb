class CustomSessionsController < Devise::SessionsController

  # Post, Sign-In
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_with resource, :location => after_sign_in_path_for(resource) do |format|
      format.json {render :json => resource }
    end
  end

end
