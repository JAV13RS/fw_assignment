require 'rails_helper'

RSpec.describe "FlashcardSets API", type: :request do
  let!(:flashcard_set) { create(:flashcard_set) } 
  let!(:user) { create(:user) }
  let!(:comment) { create(:comment, flashcard_set: flashcard_set,user: user, comment: 'hi this is a comment') }
  let(:flashcard_set_id) { flashcard_set.id }
  let(:valid_attributes) { { name: 'Updated Name' }.to_json }



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

    it 'returns the comments associated to the flashcard set' do 

      json_response = JSON.parse(response.body)
      # Check that the comments array is not empty
      expect(json_response['comments'].size).to be > 0
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

  #Test update action 
  describe 'PUT /sets/:id' do
    context 'when the flashcard set exists' do
      before { put "/sets/#{flashcard_set_id}", params: valid_attributes, headers: { 'Content-Type' => 'application/json' } }

      it 'updates the flashcard set' do
        # Reload the flashcard set to get the updated values
        flashcard_set.reload
        expect(flashcard_set.name).to eq('Updated Name')
      end
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      it 'returns the updated flashcard set in the response' do
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eq('Updated Name')
      end
    end

    context 'when the flashcard set does not exist' do
      let(:invalid_id) { 9999 }
      before { put "/sets/#{invalid_id}", params: valid_attributes, headers: { 'Content-Type' => 'application/json' } }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end
