Rails.application.routes.draw do

  root to: 'pages#home'

  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  get '/cases/:id', to: 'cases#show', as: "case"
  get 'pages/components', to: 'pages#components'
  post 'cases/:id/leads', to: 'leads#create'
  patch 'leads/:id', to: 'leads#update'

  namespace :admin do
    resources :cases, only: [:index, :create, :destroy, :show] do
      resources :leads, only: [:index]
      resources :variables, only: [:create]
      resources :lines, only: [:create, :update, :destroy]
      member do
        patch 'saveinputbuilder', as: "save_input"
        patch 'saveoutputbuilder', as: "save_output"
        patch 'outputpreferences', as: "save_outputpreferences"
        post 'testdata', as: "save_testdata"
        patch 'updatestatus', as: "update_case_status"
      end
    end
    get 'profile', to: 'users#profile'
    # get 'cases/:id/leads', to: 'leads#index'
    # post 'cases/:id/variables', to: 'variables#create'
    # post 'cases/:id/lines', to: 'lines#create', as: 'line_create'
    # patch 'cases/:id/line/:id', to: 'lines#update', as: 'line_update'
    # delete 'cases/:id/line/:id', to: 'lines#destroy', as: 'line_delete'
    # get 'cases', to: 'cases#index'
    # post 'cases', to: 'cases#create'
    # delete 'cases/:id', to: 'cases#delete'
    # get 'cases/:id', to: 'cases#show', as: :case
    # post 'cases/:id/saveinputbuilder', to: 'cases#saveinputbuilder', as: "save_input"
    # patch 'cases/:id/saveoutputbuilder', to: 'cases#saveoutputbuilder'
    # patch 'cases/:id/outputpreferences', to: 'cases#outputpreferences'
    # post 'cases/:id/testdata', to: 'cases#testdata'
    # patch 'cases/:id/updatestatus', to: 'cases#updatestatus'

  end
end
