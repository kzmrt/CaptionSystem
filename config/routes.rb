# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
  mount Sidekiq::Web, at: '/sidekiq'
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  resources :captions, only: [:new, :create, :edit, :update, :destroy]
end
