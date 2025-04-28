Rails.application.routes.draw do
  get "api/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  get "fetch_data", to: "fetch_data#index"
  get "api", to: "api#index"
  get "api/fetch", to: "api#fetch"
  get "api/fetch_project_name_with_id", to: "api#fetch_project_name_with_id"
  get "api/fetch_project_id_with_name", to: "api#fetch_project_id_with_name"
end
