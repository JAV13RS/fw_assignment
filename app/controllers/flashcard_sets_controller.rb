class FlashcardSetsController < ApplicationController
    before_action :set_flashcard_set, only: %i[show update destroy]
  
    def index
      @flashcard_sets = FlashcardSet.all
      render json: @flashcard_sets
    end
  

    def show
      render json: @flashcard_set
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
  
    private
  
    def set_flashcard_set
      @flashcard_set = FlashcardSet.find(params[:id])
    end
  
    def flashcard_set_params
      params.require(:flashcard_set).permit(:name)
    end
  end
  