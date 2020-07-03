Rails.application.routes.draw do
  root to: 'pages#home'
  get 'pages/home'
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
