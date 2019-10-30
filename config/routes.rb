Rails.application.routes.draw do
  # For details on the DSL available within this file, see
  # https://guides.rubyonrails.org/routing.html

  #clearance login routes (for modification if necessary)
  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "clearance/sessions", only: [:create]

  resources :users, controller: "clearance/users", only: [:create] do
    resource :password,
      controller: "clearance/passwords",
      only: [:create, :edit, :update]
  end

  get "/sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"
  get "/sign_up" => "clearance/users#new", as: "sign_up"
  get "/reset_password" => "clearance/passwords#new", as: "reset_password"
  
  root to: "welcome#show"
  resources :listings
end
