Rails.application.routes.draw do
  namespace :admin do
    get 'leads/index'
  end

  namespace :admin do
    get 'variable/create'
  end

  namespace :admin do
    get 'line/create'
  end

  namespace :admin do
    get 'line/update'
  end

  namespace :admin do
    get 'line/destroy'
  end

  namespace :admin do
    get 'cases/index'
  end

  namespace :admin do
    get 'cases/create'
  end

  namespace :admin do
    get 'cases/delete'
  end

  namespace :admin do
    get 'cases/show'
  end

  namespace :admin do
    get 'cases/saveinputbuilder'
  end

  namespace :admin do
    get 'cases/saveoutputbuilder'
  end

  namespace :admin do
    get 'cases/outputpreferences'
  end

  namespace :admin do
    get 'cases/testdata'
  end

  namespace :admin do
    get 'cases/updatestatus'
  end

  get 'leads/create'

  get 'leads/update'

  get 'cases/show'

  get 'users/profile'

  get 'users/cases'

  get 'users/sho'

  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
