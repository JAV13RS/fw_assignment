class FlashcardSetsController < ApplicationController
  before_action :set_collection, only: %i[create new index edit update]
  before_action :set_flashcard_set, only: %i[show update destroy comment cards]
  
  def index
    @collection = Collection.find(params[:collection_id]) if params[:collection_id]
    if @collection
      @flashcard_sets = @collection.flashcard_sets
    else
      @flashcard_sets = FlashcardSet.all
    end
    respond_to do |format|
      format.json { render json: @flashcard_sets, status: :ok }
      format.html { render :index }
    end
  end

  def show
    @collection = @flashcard_set.collection
    @comment = Comment.new

    respond_to do |format|
      format.json { render json: @flashcard_set, include: ['comments'], status: :ok }
      format.html { render :show }
    end
  end

  def new
    @flashcard_set = FlashcardSet.new
  end

  def create
    @flashcard_set = FlashcardSet.new(flashcard_set_params)
    @flashcard_set.user_id = current_user.id
    @flashcard_set.collection_id = @collection.id if @collection

    respond_to do |format|
      if flashcard_sets_today >= 20
        format.json { render json: { message: "You have reached the maximum number of flashcard sets allowed today" }, status: :too_many_requests }
        format.html { redirect_to flashcard_sets_path, alert: "You have reached the maximum number of flashcard sets allowed today." }
      elsif @flashcard_set.save
        format.json { render json: @flashcard_set, status: :created }
        format.html { redirect_to @flashcard_set, notice: 'Flashcard set created successfully.' }
      else
        format.json { render json: @flashcard_set.errors, status: :unprocessable_entity }
        format.html { render :new }
      end
    end
  end

  def edit
    @flashcard_set = FlashcardSet.find(params[:id])
  end

  def update
    respond_to do |format|
      if @flashcard_set.update(flashcard_set_params)
        format.json { render json: @flashcard_set }
        format.html { redirect_to @flashcard_set, notice: 'Flashcard set updated successfully.' }
      else
        format.json { render json: @flashcard_set.errors, status: :unprocessable_entity }
        format.html { render :edit }
      end
    end
  end

  def destroy
    @flashcard_set.destroy
    respond_to do |format|
      format.json { head :no_content }
      format.html { redirect_to flashcard_sets_url, notice: 'Flashcard set deleted successfully.' }
    end
  end

  def comment
    @comment = @flashcard_set.comments.new(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.json { render json: @comment, status: :created }
        format.html { redirect_to @flashcard_set, notice: 'Comment added successfully.' }
      else
        format.json { render json: { error: 'Unable to create comment' }, status: :unprocessable_entity }
        format.html { redirect_to @flashcard_set, alert: 'Unable to create comment.' }
      end
    end
  end
  
  def cards
    @flashcards = @flashcard_set.flashcards

    if params[:shuffle].present? && ActiveModel::Type::Boolean.new.cast(params[:shuffle])
      @flashcards = @flashcards.shuffle
    end

    respond_to do |format|
      format.json { render json: flashcards, status: :ok }
      format.html { render :cards }
    end
  end

  private

  def set_collection
    @collection = Collection.find(params[:collection_id]) if params[:collection_id]
  end

  def set_flashcard_set
    @flashcard_set = FlashcardSet.find(params[:id])
    render json: { error: 'Flashcard set not found' }, status: :not_found unless @flashcard_set
  end

  def flashcard_set_params
    params.require(:flashcard_set).permit(:name)
  end

  def comment_params
    params.require(:comment).permit(:comment)
  end

  def flashcard_sets_today
    FlashcardSet.where("user_id = ? AND created_at >= ?", current_user.id, Time.zone.today.beginning_of_day).count
  end
end
