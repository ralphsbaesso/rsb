Rails.application.routes.draw do

  resources :labels do
    post :set_resources, on: :collection
  end

  namespace :bam do
    resources :accounts do
      get :field_options, on: :collection
    end
    resources :categories, only: %i[index create update destroy show]
    resources :items
    resources :transactions
    resources :upload_to_transactions
  end

  namespace :admin do
    resources :events, only: [:index]
  end

  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'auth/registrations',
    sessions: 'auth/sessions'
  }

end
