Rails.application.routes.draw do
  root 'demo#index'
  resources :demo, only: [:index] do
    put 'results', on: :collection
  end
end
