Rails.application.routes.draw do
  resource :home, path: '/', controller: 'home',  only: [:show, :add, :create, :link]  do 
    post '/add', to: 'home#add'
    get '/:id', to: 'home#link'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
