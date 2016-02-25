Rails.application.routes.draw do
  # get 'telegram/incoming'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  post 'incoming' => 'telegram#incoming', as: 'incoming'
  root to: 'visitors#index'
  devise_for :users
end
