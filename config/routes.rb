Rails.application.routes.draw do
  namespace :manager_account do
    resources :items
    resources :accounts
    resources :transactions
    resources :upload_to_transactions
    resources :structures do
      get :options, on: :collection
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'auth/registrations',
    sessions: 'auth/sessions'
  }

end
