Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  authenticated :user do
    root 'home#index', as: :authenticated_root
    resources :guides do
      member do
        get 'invite'
        post 'users'
      end
    end
  end
  unauthenticated :user do
    root 'home#welcome'
  end

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
end

Rails.application.routes.default_url_options[:host] = 'http://build.americanvoterguide.org'
