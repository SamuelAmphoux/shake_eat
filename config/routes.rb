Rails.application.routes.draw do
  devise_for :users
  root to: "dashboards#show"

  # Routes temporaires pour accéder à l'ui kit
  get "uikit", to: "uikit#index"

  resources :menus, only: %i[new create show] do
    resources :menu_recipes, only: %i[create]
    get "menus/:menu_id/menu_recipes", to: "menu_recipes#create_all", as: :menu_recipes_create_all
  end
  resources :recipes, only: :show
  resources :menu_recipes, only: %i[destroy]
  get "menus/:menu_id/recipe_ingredients", to: "menus#grocery_list", as: :grocery_list
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
