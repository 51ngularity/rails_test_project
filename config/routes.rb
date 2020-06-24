# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'products#redirect_to_index'
  resources :products
  
  get 'bulma_layouts', to: 'bulma#bulma_layouts'
  get 'bulma_elements', to: 'bulma#bulma_elements'
end
