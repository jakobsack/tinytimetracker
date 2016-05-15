Rails.application.routes.draw do
  resources :sessions
  resources :projects do
    collection do
      get :dashboard
      post :kick_start
    end
    resources :records do
      collection do
        post 'open'
      end
      member do
        post 'close'
      end
    end
  end
  get 'records' => 'records#list'
  get 'evaluation' => 'records#evaluate'
  resources :users, only: [:edit, :update]

  root 'projects#dashboard'
end
