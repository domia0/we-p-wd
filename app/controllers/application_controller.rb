class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

  # --- --- i18n
  around_action :switch_locale
  def switch_locale(&action)
    locale = locale_from_url || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def locale_from_url
    locale = params[:locale]
    return locale if I18n.available_locales.map(&:to_s).include?(locale)
    nil
  end

  def default_url_options
    { locale: I18n.locale }
  end
  
  def is_moderator?
    if !current_user.moderator? && !current_user.admin?
      flash[:error] = "You must be logged in as a moderator to access this section"
      redirect_to root_path
    end
  end

  def is_admin?
    unless current_user.admin?
      flash[:error] = "You must be logged in as an admin to access this section"
      redirect_to root_path
    end
  end

  def logged_in?
    unless user_signed_in?
      flash[:error] = "You must be logged in to access this section"
      redirect_to root_path
    end
  end

  def blocked?
    if current_user.blocked
      flash[:error] = "You are blocked!"
      redirect_to root_path
    end
  end
end
