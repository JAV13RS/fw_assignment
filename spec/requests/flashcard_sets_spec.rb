require 'rails_helper'

RSpec.describe "FlashcardSets API", type: :request do
  let(:user) { create(:user) }
  let!(:flashcard_set) { create(:flashcard_set, user: user) }
  let!(:comment) { create(:comment, flashcard_set: flashcard_set,user: user, comment: 'hi this is a comment') }
  let(:flashcard_set_id) { flashcard_set.id }
  let(:valid_attributes) { { name: 'Updated Name' }.to_json }
  
  

  # Test index action
  describe 'GET /sets' do
    before { get '/sets'}  

    it 'returns flashcard sets' do
      expect(response).to have_http_status(200) 
      expect(response.body).to include(flashcard_set.name)  
    end
  end

  

  # Test create action
  describe 'POST /sets' do
    before do
      sign_in user 
    end
    let(:valid_attributes) { { name: 'New Set'}.to_json }
  
    it 'creates a flashcard set' do
      expect {
        post '/sets', 
             params: valid_attributes, 
             headers: { 
               'Content-Type' => 'application/json', 
               'Accept' => 'application/json' 
             }
      }.to change(FlashcardSet, :count).by(1)
  
      expect(response).to have_http_status(201)
      expect(response.content_type).to eq('application/json; charset=utf-8')  
    end

    context "when less than 20 flashcard sets are created today" do
      it "creates a new flashcard set and returns 201" do
        expect {
          post "/sets", 
               params: { flashcard_set: { name: "New Set", cards_attributes: [{ question: "What is 2+2?", answer: "4" }] } }.to_json,
               headers: { 
                 "Content-Type" => "application/json",    
                 "Accept" => "application/json"           
               }
        }.to change(FlashcardSet, :count).by(1)
        
        expect(response).to have_http_status(:created)
      end
    end

    context "when 20 flashcard sets are already created today" do
      before do
        20.times do
          create(:flashcard_set)
        end
      end

      it "returns 429 status for rate limit" do
        post "/sets", 
             params: { flashcard_set: { name: "New Set", cards_attributes: [{ question: "What is 2+2?", answer: "4" }] } }.to_json,
             headers: { 
               "Content-Type" => "application/json",    
               "Accept" => "application/json"           
             }
      
        expect(response).to have_http_status(:too_many_requests)
      
        expect(JSON.parse(response.body)["message"]).to eq("You have reached the maximum number of flashcard sets allowed today")
      end
      
      
    end
  end
  
  # Test show action
  describe 'GET /sets/:id' do
    before { get "/sets/#{flashcard_set_id}", headers: { 'Accept' => 'application/json' }  }
    
    it 'returns the flashcard set' do
      expect(response).to have_http_status(200)  
      expect(response.body).to include(flashcard_set.name)

    end

    it 'returns the comments associated to the flashcard set' do 

      json_response = JSON.parse(response.body)
      expect(json_response['comments'].size).to be > 0
    end
  end

  # Test destroy action
  describe 'DELETE /sets/:id' do
    it 'deletes the flashcard set' do
      expect {
        delete "/sets/#{flashcard_set_id}", headers: { 'Accept' => 'application/json' }
      }.to change(FlashcardSet, :count).by(-1)  
      expect(response).to have_http_status(204)  
    end
  end

  #Test update action 
  describe 'PUT /sets/:id' do
    context 'when the flashcard set exists' do
      before { put "/sets/#{flashcard_set_id}", params: valid_attributes, headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' } }

      it 'updates the flashcard set' do
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
      before { put "/sets/#{invalid_id}", params: valid_attributes, headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' } }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  #Test Post #comment
  describe 'POST /sets/:id/comment' do
    context 'when flashcard set exists' do
      let(:valid_attributes) { { comment: 'This is a great set!' } }
  
      before do
        sign_in user
      end
  
      it 'creates a comment on the flashcard set' do
        post "/sets/#{flashcard_set.id}/comment", 
             params: { comment: { comment: 'This is a great set!' } }.to_json,
             headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }  
  
        expect(response).to have_http_status(:created)  
        json_response = JSON.parse(response.body)
        expect(json_response['comment']).to eq('This is a great set!')
      end
    end
    context 'when flashcard set does not exist' do
      let(:invalid_set_id) { 9999 }
  
      before do
        sign_in user
      end
  
      it 'returns a 404 error' do
        post "/sets/#{invalid_set_id}/comment", 
             params: { comment: {comment: 'This set does not exist!'} }.to_json, 
             headers: { 'Content-Type' => 'application/json' }
  
        expect(response).to have_http_status(:not_found)
      end
    end
  end

end

