Rails.application.routes.draw do
  devise_for :users
  root to: "dashboards#show"
  resources :menus, only: %i[new create show] do
    resources :menu_recipes, only: %i[create destroy]
    get "menus/:menu_id/menu_recipes", to: "menu_recipes#create_all", as: :menu_recipes_create_all
  end
  resources :recipes, only: :show

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
