class FlashcardsController < ApplicationController
    before_action :set_flashcard_set, only: %i[create new index]

    def index
        flashcards = Flashcard.all
        respond_to do |format|
            format.json { render json: flashcards, status: :ok }
            format.html { render :index }
        end
    end

    def new
        @flashcard = @flashcard_set.flashcards.new
      end

    def create 
        flashcard = @flashcard_set.flashcards.new(flashcard_params)
        
        respond_to do |format|
            if flashcard.save
                format.json { render json: flashcard, status: :created }
                format.html { redirect_to flashcard_set_flashcards_path(@flashcard_set), notice: 'Flashcard created successfully.' }
            else
                format.json { render json: flashcard.errors, status: :unprocessable_entity }
                format.html { render :new }
            end
        end
    end

    def destroy
        flashcard = Flashcard.find(params[:id])
        flashcard.destroy
        respond_to do |format|
            format.json { head :no_content }
        end
    end

    def update
        flashcard = Flashcard.find(params[:id])
        respond_to do |format|
            if flashcard.update(flashcard_params)
                format.json { render json: flashcard }
                format.html { redirect_to flashcards_path, notice: 'Flashcard updated successfully.' }
            else
                format.json { render json: flashcard.errors, status: :unprocessable_entity }
                format.html { render :edit }
            end
        end
    end

    def edit 
        @flashcard = Flashcard.find(params[:id])
    end

    private 

    def flashcard_params
        params.require(:flashcard).permit(:question, :answer)
    end

    def set_flashcard_set
        @flashcard_set = FlashcardSet.find(params[:flashcard_set_id])
    end
end