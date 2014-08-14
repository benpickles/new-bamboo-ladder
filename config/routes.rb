LadderApp::Application.routes.draw do
  root 'ladder#show'

  match '/auth/:provider/callback', to: 'sessions#create', via: %w{get post}

  resources :players, only: :create
  resources :settings, only: [:index]
  resources :results, only: [:index, :create, :destroy] do
    collection do
      get :undo
    end
  end

  resource :ping, only: [:show]

  resource :test, only: [:show]
end
