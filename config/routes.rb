Rails.application.routes.draw do
  namespace :manage_account do
    resources :items
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'users'
  }

end
