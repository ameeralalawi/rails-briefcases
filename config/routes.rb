Rails.application.routes.draw do

  root to: 'pages#home'

  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  get '/cases/:id', to: 'cases#show'
  get 'pages/components', to: 'pages#components'
  post 'cases/:id/leads', to: 'leads#create'
  patch 'leads/:id', to: 'leads#update'

  namespace :admin do
    get 'cases/:id/leads', to: 'leads#index'
    post 'cases/:id/variables', to: 'variables#create'
    post 'cases/:id/lines', to: 'lines#create', as: 'line_create'
    patch 'cases/:id/line/:id', to: 'lines#update', as: 'line_update'
    delete 'cases/:id/line/:id', to: 'lines#destroy', as: 'line_delete'
    patch 'lines/:id', to: 'lines#update'
    delete 'lines/:id', to: 'lines#destroy'
    get 'cases', to: 'cases#index'
    post 'cases', to: 'cases#create'
    delete 'cases/:id', to: 'cases#delete'
    get 'cases/:id', to: 'cases#show', as: :case
    post 'cases/:id/saveinputbuilder', to: 'cases#saveinputbuilder', as: "save_input"
    patch 'cases/:id/saveoutputbuilder', to: 'cases#saveoutputbuilder'
    patch 'cases/:id/outputpreferences', to: 'cases#outputpreferences'
    post 'cases/:id/testdata', to: 'cases#testdata'
    patch 'cases/:id/updatestatus', to: 'cases#updatestatus'
    get 'profile', to: 'users#profile'
  end
end
