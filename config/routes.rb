Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # i18n
  scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/ do
    root "homes#index"

    resources :memes do
      resources :comments
    end

    devise_for :users, controllers: {
      sessions:      "custom_sessions",
      registrations: "custom_registrations"
    }
  end
end
