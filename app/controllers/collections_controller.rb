class CollectionsController < ApplicationController
    before_action :authenticate_user!, only: [:create, :update, :destroy]

    def index
      @collections = Collection.all
      respond_to do |format|
        format.html 
        format.json { render json: @collections, status: :ok }
        format.any { head :not_acceptable }
      end
    end
  
    def show
      @collection = Collection.find(params[:id])
      respond_to do |format|
        format.html # renders app/views/collections/show.html.erb
        format.json { render json: @collection, status: :ok }
      end
    end
  
    def new
      @collection = Collection.new
      # HTML form to create a new collection will be rendered
    end
  
    def create
      @collection = Collection.new(collection_params)
      if @collection.save
        respond_to do |format|
          format.html { redirect_to collection_path(@collection), notice: 'Collection created successfully.' }
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
      @collection = Collection.find(params[:id])
    end
  
    def update
      @collection = Collection.find(params[:id])
      if @collection.update(collection_params)
        respond_to do |format|
          format.html { redirect_to collection_path(@collection), notice: 'Collection updated successfully.' }
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
      @collection = Collection.find(params[:id])
      @collection.destroy
      respond_to do |format|
        format.html { redirect_to collections_path(), notice: 'Collection deleted successfully.' }
        format.json { head :no_content }
      end
    end
  
    private
  
    def collection_params
        params.require(:collection).permit(:name, flashcard_set_ids: [])
    end
end
  