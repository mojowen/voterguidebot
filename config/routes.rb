Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  authenticated :user do
    root 'home#index', as: :authenticated_root

    get '/settings' => 'admin#settings', as: 'admin_settings'
    post '/promote' => 'admin#promote', as: 'admin_promote'

    resources :guides do
      member do
        get 'invite'
        get 'fields'
        patch 'users'
        get 'preview'
      end
      resources :languages, only: [:index, :create, :destroy, :show]
      resources :contests, :measures, except: :show do
        collection { put :position }
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
