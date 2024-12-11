class FlashcardsController < ApplicationController
    before_action :set_flashcard_set, only: %i[create new index destroy show update edit]

    def index
        @flashcards = Flashcard.all
        respond_to do |format|
            format.json { render json: flashcards, status: :ok }
            format.html { render :index }
        end
    end

    def new
        @flashcard_set = FlashcardSet.find(params[:flashcard_set_id]) 
        @collection = @flashcard_set.collection                      
        @flashcard = Flashcard.new
    end

    def create 
        @flashcard = @flashcard_set.flashcards.new(flashcard_params)
        
        respond_to do |format|
            if @flashcard.save
                format.json { render json: @flashcard, status: :created }
                format.html { redirect_to flashcard_set_path(@flashcard_set), notice: 'Flashcard created successfully.' }
            else
                format.json { render json: @flashcard.errors, status: :unprocessable_entity }
                format.html { render :new }
            end
        end
    end

    def destroy
        @flashcard = Flashcard.find(params[:id])
        @flashcard.destroy
        respond_to do |format|
            format.json { head :no_content }
            format.html { redirect_to flashcard_set_path(@flashcard_set), notice: 'Flashcard deleted successfully.' }
        end
    end

    def update
        @flashcard = Flashcard.find(params[:id])
        respond_to do |format|
            if @flashcard.update(flashcard_params)
                format.json { render json: @flashcard }
                format.html { redirect_to flashcard_set_path(@flashcard_set), notice: 'Flashcard updated successfully.' }
            else
                format.json { render json: @flashcard.errors, status: :unprocessable_entity }
                format.html { render :edit }
            end
        end
    end

    def edit 
        @flashcard = Flashcard.find(params[:id])
    end

    def show
        @flashcard_set = FlashcardSet.find(params[:flashcard_set_id])
        @flashcard = @flashcard_set.flashcards.find(params[:id])
        respond_to do |format|
            format.json { render json: @flashcard }
            format.html { render :show }
        end
    end


    def hide
        flashcard = Flashcard.find(params[:id])
    
        current_user.hidden_flashcards.find_or_create_by(flashcard: flashcard, hidden: true)

        respond_to do |format|
          format.html { redirect_back fallback_location: flashcard_set_path(flashcard.flashcard_set), notice: 'Flashcard hidden.' }
          format.json { render json: { message: 'Flashcard hidden.' }, status: :ok }
        end
    
    end

    def unhide
        flashcard = Flashcard.find(params[:id])

        hidden_flashcard = current_user.hidden_flashcards.find_by(flashcard: flashcard)
        hidden_flashcard&.destroy

        respond_to do |format|
            format.html { redirect_back fallback_location: flashcard_set_path(flashcard.flashcard_set), notice: 'Flashcard unhidden.' }
            format.json { render json: { message: 'Flashcard unhidden.' }, status: :ok }
        end
    end
    private 

    def flashcard_params
        params.require(:flashcard).permit(:question, :answer)
    end

    def set_flashcard_set
        @flashcard_set = FlashcardSet.find(params[:flashcard_set_id])
    end
end
