Rails.application.routes.draw do
  resources :tags
  resources :colors
  get "palettes/random(/:count)" => "palettes#random"
  get "palettes/random-2(/:count)" => "palettes#random_2"
  resources :palettes

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
