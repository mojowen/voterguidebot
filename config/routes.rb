Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  authenticated :user do
    root 'home#index', as: :authenticated_root
    get 'invite' => 'home#invite'
    post 'invite' => 'home#add'
    resources :guides do
      member do
        get 'invite'
      end
    end
  end
  unauthenticated :user do
    root 'home#welcome'
  end

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
end
