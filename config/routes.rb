Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  authenticated :user do
    root 'home#index', as: :authenticated_root

    get '/settings' => 'admin#settings', as: 'admin_settings'
    post '/promote' => 'admin#promote', as: 'admin_promote'
    post '/impersonate' => 'admin#impersonate', as: 'admin_impersonate'

    resources :exports, only: [:index, :new, :create, :update]

    resources :guides do
      member do
        get 'invite'
        get 'fields'
        patch 'users'
        get 'preview'
        post 'publish'
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

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
end

Rails.application.routes.default_url_options[:host] = 'http://build.americanvoterguide.org'
