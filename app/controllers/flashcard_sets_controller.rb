class FlashcardSetsController < ApplicationController
  before_action :set_flashcard_set, only: %i[show update destroy comment cards]
  
  def index
    @flashcard_sets = FlashcardSet.all
    respond_to do |format|
      format.json { render json: @flashcard_sets, status: :ok }
      format.html { render :index }  # Adjust the view as needed
    end
  end

  def show
    respond_to do |format|
      format.json { render json: @flashcard_set, include: ['comments'], status: :ok }
      format.html { render :show }  # Adjust the view as needed
    end
  end

  def create
    @flashcard_set = FlashcardSet.new(flashcard_set_params)
    Rails.logger.info "Request format: #{request.format}"

    respond_to do |format|
      if @flashcard_set.save
        format.json { render json: @flashcard_set, status: :created }

        format.html { redirect_to @flashcard_set, notice: 'Flashcard set created successfully.' }
      else
        format.json { render json: @flashcard_set.errors, status: :unprocessable_entity }
        format.html { render :new }
      end
    end
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
    comment = @flashcard_set.comments.create(comment_params.merge(user_id: current_user.id))

    respond_to do |format|
      if comment.save
        format.json { render json: comment, status: :created }
        format.html { redirect_to @flashcard_set, notice: 'Comment added successfully.' }
      else
        format.json { render json: { error: 'Unable to create comment' }, status: :unprocessable_entity }
        format.html { redirect_to @flashcard_set, alert: 'Unable to create comment.' }
      end
    end
  end

  def cards
    flashcards = @flashcard_set.flashcards
    flashcards = flashcards.shuffle if params[:shuffle].present? && ActiveModel::Type::Boolean.new.cast(params[:shuffle])

    respond_to do |format|
      format.json { render json: flashcards, status: :ok }
      format.html { render :cards }  # Adjust the view as needed
    end
  end

  private

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
end
