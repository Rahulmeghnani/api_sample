Rails.application.routes.draw do
  resources :users, param: :_username
  resources :products do
    resources :categories do
      resources :subcategories
    end
  end

  # resources :categories, only: [:index, :show, :create, :update, :destroy]
  post '/auth/login', to: 'authentication#login'
  get '/*a', to: 'application#not_found'
  
end
