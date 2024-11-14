require 'rails_helper'

RSpec.describe "FlashcardSets API", type: :request do
  let!(:flashcard_set) { create(:flashcard_set) } 
  let(:flashcard_set_id) { flashcard_set.id }

    # Test index action
  describe 'GET /sets' do
    before { get '/sets' }  # Perform the GET request

    it 'returns flashcard sets' do
      expect(response).to have_http_status(200) 
      expect(response.body).to include(flashcard_set.name)  
    end
  end

  # Test create action
  describe 'POST /sets' do
    let(:valid_attributes) { { name: 'New Set' }.to_json } 

    it 'creates a flashcard set' do
      expect {
        post '/sets', params: valid_attributes, headers: { 'Content-Type' => 'application/json' }
      }.to change(FlashcardSet, :count).by(1)  
      expect(response).to have_http_status(201)  
    end
  end

  # Test show action
  describe 'GET /sets/:id' do
    before { get "/sets/#{flashcard_set_id}" }

    it 'returns the flashcard set' do
      expect(response).to have_http_status(200)  
      expect(response.body).to include(flashcard_set.name)
    end
  end

  # Test destroy action
  describe 'DELETE /sets/:id' do
    it 'deletes the flashcard set' do
      expect {
        delete "/sets/#{flashcard_set_id}"
      }.to change(FlashcardSet, :count).by(-1)  
      expect(response).to have_http_status(204)  
    end
  end
end
