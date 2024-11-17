class CollectionsController < ApplicationController
    before_action :set_user
    before_action :authenticate_user!, only: [:create, :update, :destroy]
    def index
      @collections = @user.collections
      respond_to do |format|
        format.html # renders app/views/collections/index.html.erb
        format.json { render json: @collections, status: :ok }
      end
    end
  
    def show
      @collection = @user.collections.find(params[:id])
      respond_to do |format|
        format.html # renders app/views/collections/show.html.erb
        format.json { render json: @collection, status: :ok }
      end
    end
  
    def new
      @collection = @user.collections.new
      # HTML form to create a new collection will be rendered
    end
  
    def create
      @collection = @user.collections.new(collection_params)
      if @collection.save
        respond_to do |format|
          format.html { redirect_to user_collection_path(@user, @collection), notice: 'Collection created successfully.' }
          format.json { render json: @collection, status: :created, include: [:flashcard_sets] }
        end
      else
        respond_to do |format|
          format.html { render :new }
          format.json { render json: @collection.errors, status: :unprocessable_entity }
        end
      end
    end
  
    def edit
      @collection = @user.collections.find(params[:id])
    end
  
    def update
      @collection = @user.collections.find(params[:id])
      if @collection.update(collection_params)
        respond_to do |format|
          format.html { redirect_to user_collection_path(@user, @collection), notice: 'Collection updated successfully.' }
          format.json { render json: @collection, status: :ok }
        end
      else
        respond_to do |format|
          format.html { render :edit }
          format.json { render json: @collection.errors, status: :unprocessable_entity }
        end
      end
    end
  
    def destroy
      @collection = @user.collections.find(params[:id])
      @collection.destroy
      respond_to do |format|
        format.html { redirect_to user_collections_path(@user), notice: 'Collection deleted successfully.' }
        format.json { head :no_content }
      end
    end
  
    private
  
    def set_user
      @user = User.find(params[:user_id])
    end
  
    def collection_params
        params.require(:collection).permit(:name, flashcard_set_ids: [])
    end
end
  