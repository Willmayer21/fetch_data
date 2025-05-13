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
  get "api/fetch_project", to: "api#fetch_project"
  get "api/fetch_project_pull_request", to: "api#fetch_project_pull_request"
  get "api/fetch_pull_request_event", to: "api#fetch_pull_request_event"
  get "my_api/merge_requests", to: "my_api#merge_requests"
  get "my_api/sync_merge_request", to: "my_api#sync_merge_request"
  get "array/index", to: "array#index"
  get "array_updated/index", to: "array_updated#index"
   get "array_free/index", to: "array_free#index"
end
