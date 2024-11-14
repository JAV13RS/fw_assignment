class FlashcardSetsController < ApplicationController
  before_action :authenticate_user!, only: [:comment]  
  before_action :set_flashcard_set, only: %i[show update destroy comment]
    

  
  
    def index
      @flashcard_sets = FlashcardSet.all
      render json: @flashcard_sets, status: :ok
    end
  

    def show
      render json: @flashcard_set, include: ['comments'], status: :ok
    end
  

    def create
      @flashcard_set = FlashcardSet.new(flashcard_set_params)
  
      if @flashcard_set.save
        render json: @flashcard_set, status: :created
      else
        render json: @flashcard_set.errors, status: :unprocessable_entity
      end
    end
  

    def update
      if @flashcard_set.update(flashcard_set_params)
        render json: @flashcard_set
      else
        render json: @flashcard_set.errors, status: :unprocessable_entity
      end
    end
  

    def destroy
      @flashcard_set.destroy
      head :no_content
    end



    def comment
      comment = @flashcard_set.comments.create(comment_params.merge(user_id: current_user.id))
    
      if comment.save
        render json: comment, status: :created
      else
        render json: { error: 'Unable to create comment' }, status: :unprocessable_entity
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
  