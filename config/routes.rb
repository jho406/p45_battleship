P45Battleship::Application.routes.draw do
  root :to => 'home#index'
  resources :games, :only => [:create, :show] do
    resources :turns, :only => [:create, :index]
    resources :deployments, :only => [:index]
  end
  resources :ships
end
