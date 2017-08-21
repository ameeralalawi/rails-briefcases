Rails.application.routes.draw do

  namespace :admin do
    get 'cases/:id/leads', to: 'leads#index'
    post 'cases/:id/variables', to: 'variable#create'
    post 'cases/:id/lines', to: 'line#create'
    patch 'lines/:id', to: 'line#update'
    delete 'lines/:id', to: 'line#destroy'
    get 'cases', to: 'cases#index'
    post 'cases', to: 'cases#create'
    delete 'cases/:id', to: 'cases#delete'
    get 'cases/:id', to: 'cases#show'
    patch 'cases/:id/saveinputbuilder', to: 'cases#saveinputbuilder'
    patch 'cases/:id/saveoutputbuilder', to: 'cases#saveoutputbuilder'
    patch 'cases/:id/outputpreferences', to: 'cases#outputpreferences'
    post 'cases/:id/testdata', to: 'cases#testdata'
    patch 'cases/:id/updatestatus', to: 'cases#updatestatus'
    get 'profile', to: 'users#profile'
  end

  post 'cases/:id/leads', to: 'leads#create'
  patch 'leads/:id', to: 'leads#update'
  get '/cases/:id', to: 'cases#show'
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
