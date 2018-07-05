Rails.application.routes.draw do
  devise_for :users
  root 'movies#index'
  resources :movies do
    member do    # id까지 포함
      post '/comments' => 'movies#create_comment'
    end
    collection do
      delete '/comments/:comment_id' => 'movies#destroy_comment'
      patch '/comments/:comment_id' => 'movies#update_comment'
    end
    # collection do
    #   get '/test' => 'movies#test_collection'
    # end
  end
  
  get '/likes/:movie_id' => 'movies#like_movie'
 # post '/movies/:movie_id/comments' => 'movies#comments'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
