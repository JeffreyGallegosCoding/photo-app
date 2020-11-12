Rails.application.routes.draw do
  resources :images
  # for registrations looks at my own registrations controller first and
  # then look at devise's registration controller
  devise_for :users, :controllers => { :registrations => 'registrations' }
  root 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
