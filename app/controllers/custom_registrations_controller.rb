class CustomRegistrationsController < Devise::RegistrationsController

  # POST, new user
  def create
    build_resource(sign_up_params)
    unless User.where(:username => resource.username).empty?
      render :json => { :status => "error", :message => "name" } and return
    end
    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource) do |format|
          format.json {render :json => resource }
        end
      else
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      render :json => { :status => "error", :message => "email" }
    end
  end

end
