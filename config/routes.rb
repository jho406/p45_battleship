P45Battleship::Application.routes.draw do
  root :to => 'home#index'

  resources :games, :only => :show

  namespace :api, :defaults => {:format => 'json'} do
    scope :module => :v0 do
      resources :games, :only => [:create, :show] do
        resources :turns, :only => [:create, :index]
        resources :deployments, :only => [:index]
      end
    end
    #todo for scope v1: add constraints via headers
  end
end
