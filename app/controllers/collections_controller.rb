class CollectionsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy, :new, :show, :index]
  before_action :validate_headers, only: [:create, :update, :destroy, :index, :show, :random], if: -> { request.format.json? }

  def index
    if user_signed_in?
      @collections = current_user.collections.includes(flashcard_sets: :comments)
    else
      @collections = Collection.includes(flashcard_sets: :comments).all
    end

    respond_to do |format|
      format.html
      format.json do
        collections_data = @collections.map do |collection|
          collection.flashcard_sets.map do |flashcard_set|
            {
              comment: flashcard_set.comments.first&.comment,
              set: flashcard_set,
              user: flashcard_set.user
            }
          end
        end
        render json: collections_data
      end
    end
  end

  def show
    @collection = Collection.find(params[:id])
    respond_to do |format|
      format.html 
      format.json { render json: @collection, status: :ok }
    end
  end

  def new
    @collection = Collection.new
  end

  def create
    flashcard_sets_params = collection_params[:flashcard_sets] || []
  
    flashcard_sets = FlashcardSet.where(id: flashcard_sets_params.map { |set| set[:setID] })
  
    if flashcard_sets.count != flashcard_sets_params.size
      respond_to do |format|
        format.json { render json: { error: "Some flashcard sets not found" }, status: :unprocessable_entity }
        format.html { render :new, status: :unprocessable_entity }
      end
      return
    end
  
    collection = current_user.collections.new(collection_params.except(:flashcard_sets))
  
    collection.flashcard_sets = flashcard_sets
  
    if collection.save
      flashcard_sets_data = flashcard_sets.map do |flashcard_set|
        {
          comment: flashcard_set.comments.first&.comment,
          set: flashcard_set,
          user: flashcard_set.user
        }
      end
  
      respond_to do |format|
        format.json { render json: flashcard_sets_data, status: :created }
        format.html { redirect_to collection_path(collection), notice: 'Collection was successfully created.' }
      end
    else
      respond_to do |format|
        format.json { render json: collection.errors, status: :unprocessable_entity }
        format.html { render :new, status: :unprocessable_entity }
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
        format.html { redirect_to collection_path, notice: 'Collection updated successfully.' }
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
      format.html { redirect_back(fallback_location: collections_path, notice: 'Collection deleted successfully.') }
      format.json { head :no_content }
    end
  end
  
  def random
    collection = Collection.order("RANDOM()").first 
    
    if collection
      respond_to do |format|
        format.html { redirect_to collection_path(collection) } 
        format.json { render json: { location: collection_path(collection) }, status: :ok } 
      end
    else
      respond_to do |format|
        format.html { render html: "<h1>No collections found</h1>".html_safe, status: :not_found } 
        format.json { render json: { message: "No collections found", code: 404 }, status: :not_found } 
      end
    end
  end

  def all_collections
    @collections = Collection.where.not(user: current_user).where(public: true) 
    @collections = Collection.all if current_user.admin == true
    respond_to do |format|
      format.html
      format.json { render json: @collections, status: :ok }
    end
  end

  private

  def validate_headers
    unless request.headers["Accept"]&.include?("application/json")
      render json: { error: "Invalid Accept header. Must be 'application/json'" }, status: :not_acceptable
    end

    unless request.headers["Content-Type"]&.include?("application/json")
      render json: { error: "Invalid Content-Type header. Must be 'application/json'" }, status: :unsupported_media_type
    end
  end

  def collection_params
    params.require(:collection).permit(:name, :public, flashcard_sets: [:setID, :comment])
  end
end
