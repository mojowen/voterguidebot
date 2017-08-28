Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  authenticated :user do
    root 'home#index', as: :authenticated_root

    get '/settings' => 'admin#settings', as: 'admin_settings'
    post '/promote' => 'admin#promote', as: 'admin_promote'
    post '/impersonate' => 'admin#impersonate', as: 'admin_impersonate'

    resources :exports, only: [:index, :new, :create, :update]

    resources :guides do
      collection do
        get 'validate'
        get 'archived'
      end
      member do
        get 'invite'
        get 'fields'
        patch 'users'
        get 'preview'
        post 'publish'
        delete 'restore'
      end
      resources :languages, only: [:index, :create, :destroy, :show]
      resources :contests, :measures, except: :show do
        collection do
          put :position
          post :expropriate
        end
      end
    end

    resources :uploads, only: [:create]
  end

  unauthenticated :user do
    root 'home#welcome'
  end

  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
end

Rails.application.routes.default_url_options[:host] = 'https://build.americanvoterguide.org'
