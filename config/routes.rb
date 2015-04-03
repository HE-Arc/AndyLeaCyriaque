Rails.application.routes.draw do


  post '/rate' => 'rater#create', :as => 'rate'
	devise_for :users , :controllers => { :registrations => "users/registrations"}
	root 'player#home'
	resources:users
	resources:playlists
	get 'test' => 'test#playeraudio'
	get 'user/:login' => 'player#show_profile'
	get 'users/playlists/:id' => 'playlists#indexUser'
	get 'music/:id' => 'musics#show'
	get 'playlist/:id' => 'player#show_playlist'
	get 'playlist/:id/edit' => 'player#edit_playlist'
  get 'last' => 'musics#indexLast'
  get 'mymusics' => 'musics#indexUser'
  get 'myplaylists' => 'playlists#indexUser'

	resources :musics do
		resources:comments, only: [:create]   
	end
  resources:music_playlists
  

	# The priority is based upon order of creation: first created -> highest priority.
	# See how all your routes lay out with "rake routes".

	# You can have the root of your site routed with "root"
	# root 'welcome#index'

	# Example of regular route:
	#   get 'products/:id' => 'catalog#view'

	# Example of named route that can be invoked with purchase_url(id: product.id)
	#   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

	# Example resource route (maps HTTP verbs to controller actions automatically):
	#   resources :products

	# Example resource route with options:
	#   resources :products do
	#     member do
	#       get 'short'
	#       post 'toggle'
	#     end
	#
	#     collection do
	#       get 'sold'
	#     end
	#   end

	# Example resource route with sub-resources:
	#   resources :products do
	#     resources :comments, :sales
	#     resource :seller
	#   end

	# Example resource route with more complex sub-resources:
	#   resources :products do
	#     resources :comments
	#     resources :sales do
	#       get 'recent', on: :collection
	#     end
	#   end

	# Example resource route with concerns:
	#   concern :toggleable do
	#     post 'toggle'
	#   end
	#   resources :posts, concerns: :toggleable
	#   resources :photos, concerns: :toggleable

	# Example resource route within a namespace:
	#   namespace :admin do
	#     # Directs /admin/products/* to Admin::ProductsController
	#     # (app/controllers/admin/products_controller.rb)
	#     resources :products
	#   end
end
