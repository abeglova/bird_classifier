Rails.application.routes.draw do
  root 'demo#new'
  resources :demo, only: [:new] do
    put 'results', on: :collection
  end
end
