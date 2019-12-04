Rails.application.routes.draw do
  # For details on the DSL available within this file, see
  # https://guides.rubyonrails.org/routing.html

  #clearance login routes (for modification if necessary)
  resources :passwords,
    controller: 'clearance/passwords',
    only: [:create, :new]

  resource :session,
    controller: 'clearance/sessions',
    only: [:create]
  resources :users,
    controller: 'users',
    only: Clearance.configuration.user_actions do
      resource :password,
        controller: 'clearance/passwords',
        only: [:create, :edit, :update]
    end

  get '/sign_in' => 'clearance/sessions#new', as: 'sign_in'
  delete '/sign_out' => 'clearance/sessions#destroy', as: 'sign_out'
  get '/reset_password' => 'clearance/passwords#new', as: 'reset_password'
  get '/settings' => 'users#settings', as: 'settings'
  post '/users/edit' => 'users#edit', as: "edit_user"
  
  if Clearance.configuration.allow_sign_up?
    get '/sign_up' => 'users#new', as: 'sign_up'
  end
  
  root to: "welcome#show"
  
  resources :listings do
    member do
      post 'reserve'
      post 'complete'
    end
  end
  resources :profile

end
