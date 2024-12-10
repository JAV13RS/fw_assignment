class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @collection = Collection.find(params[:collection_id])
    @favorite = current_user.favorites.build(collection: @collection)

    if @favorite.save
      redirect_back fallback_location: all_collections_path, notice: 'Collection favorited successfully!'
    else
      redirect_back fallback_location: all_collections_path, alert: 'You have already favorited this collection.'
    end
  end

  def destroy
    @collection = Collection.find(params[:collection_id])
    @favorite = current_user.favorites.find(params[:id]) 
  
    if @favorite
      @favorite.destroy
      redirect_back fallback_location: all_collections_path, notice: 'Favorite removed.'
    else
      redirect_back fallback_location: all_collections_path, alert: 'You have not favorited this collection.'
    end
  end
end
