Rails.application.routes.draw do
  resources :cats
  resources :cat_rental_requests do
    member do
      patch 'approve' => 'cat_rental_requests#approve!'
      patch 'deny' => 'cat_rental_requests#deny!'
    end
  end
  resources :users, only: [:create, :new, :show]
  resource :session, only: [:create, :destroy, :new]
end
