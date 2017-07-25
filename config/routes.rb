Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :products
    end
  end

  root to: 'application#index'
  get:'*unmatched_route', to: 'application#index'
end
