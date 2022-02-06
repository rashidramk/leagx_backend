Rails.application.routes.draw do
  # mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, :controllers => { :passwords => 'passwords', confirmations: 'confirmations', sessions: "sessions"  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
    root to: "devise/sessions#new"
  end

  namespace :api do
    namespace :v1 do
      resources :users do
        member do
          put :update_password
          get :get_workout_history
        end
        collection do
          put :forgot_password
          post :social_auth
        end
      end
      resources :sessions
    end
  end
  resources :home do
    collection do
      get  :confirmation
    end
  end
  resources :users
  resources :push_messages

  # root_path '/home'

  get '*path' => 'home#handle_no_rout'

end

