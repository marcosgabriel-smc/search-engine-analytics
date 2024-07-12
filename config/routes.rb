Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check


  resources :articles do
    collection do
      get :latest
    end
  end

  root "articles#index"

  post '/logs', to: 'logs#create', as: :logs
  post '/logs/filter_logs', to: 'logs#filter_logs', as: 'filter_logs'
end
