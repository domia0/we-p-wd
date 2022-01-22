Rails.application.routes.draw do

  # i18n
  scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/ do
    root "homes#index"

    get '/all-comments-for-meme/:meme_id', to: 'comments#show_all_comments_for_meme'

    resources :memes do
      resources :comments do
        resources :likes
        resources :reports
      end
      resources :likes
      resources :reports
      resources :tags
    end

    resources :moderators do
      member do
        patch 'change_user_status'
      end
    end

    resources :admins do
      member do
        patch 'role_to_user'
        patch 'role_to_moderator'
        patch 'role_to_admin'
      end
    end

    resources :reports do
      member do
        patch 'change_status'
      end
    end
    
    get '/moderators', to: 'moderators#index'

    devise_for :users, controllers: {
      sessions:      "custom_sessions",
      registrations: "custom_registrations"
    }
  end

end
