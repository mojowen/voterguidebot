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
        post 'users'
      end
      resources :contests, except: :show
    end
  end

  unauthenticated :user do
    root 'home#welcome'
  end

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
end

Rails.application.routes.default_url_options[:host] = 'http://build.americanvoterguide.org'
