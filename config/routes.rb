Rails.application.routes.draw do
  devise_for :users
  root to: "dashboards#show"
  resources :menus, only: %i[new create show] do
    resources :menu_recipes, only: %i[create destroy]
  end
  resources :recipes, only: :show

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
