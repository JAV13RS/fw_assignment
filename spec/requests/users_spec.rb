require 'rails_helper'
require 'faker'

RSpec.describe "Users API", type: :request do
  let(:valid_attributes) do
    {
      user: {
        email: Faker::Internet.email, 
        password: 'password', 
        password_confirmation: 'password'
      }
    }
  end
  let(:invalid_attributes) do
    {
      user: {
        email: Faker::Internet.email, 
        password: 'password', 
        password_confirmation: 'wrongpassword'
      }
    }
  end

  let!(:admin_user) { User.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password', admin: true) }
  let!(:user) { User.create!(email: 'testing3@example.com', password: 'password', password_confirmation: 'password', admin: false) }
  let(:headers) { { 'Accept' => 'application/json', 'Content-Type' => 'application/json' } }
  let!(:flashcard_set1) { FlashcardSet.create!(name: 'Set 1', user: user) }
  let!(:flashcard_set2) { FlashcardSet.create!(name: 'Set 2', user: user) }

  before { sign_in user }

  describe 'POST /users' do
    context 'when the request is valid' do
      let(:valid_params) { { user: { email: 'newuser@example.com', password: 'password', password_confirmation: 'password' } } }

      it 'creates a new user and returns status 201' do
        post '/users', params: valid_params.to_json, headers: headers
        expect(response).to have_http_status(:created)
      end
      
    end

    context 'when the request is invalid' do
      let(:invalid_params) { { user: { email: '', password: 'password' } } }

      it 'returns an error and status 422' do
        post '/users', params: invalid_params, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']).to include("Email can't be blank")
      end
    end
  end


  describe 'GET /users/:id' do
    context 'when the user exists' do
      it 'retrieves the user by id' do
        get "/users/#{user.id}", headers: headers

        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)

        expect(json_response['email']).to eq(user.email)
      end
    end

    context 'when the user does not exist' do
      it 'returns a 404 not found' do
        get "/users/99999", headers: headers

        expect(response).to have_http_status(:not_found)

        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('User not found')
      end
    end
  end

  describe 'PUT /users/:id' do
    context 'when the user is an admin' do

      let!(:user) { User.create!(email: 'test@example.com', password: 'password', password_confirmation: 'password', admin: false) }

      before { sign_in admin_user }

      it 'updates the admin field' do
        put "/users/#{user.id}",
            params: { user: { admin: true } }.to_json,
            headers: headers

        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
      end

      it 'updates the email field' do
        put "/users/#{user.id}",
            params: { user: { email: 'updated@example.com' } }.to_json,
            headers: headers

        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response['email']).to eq('updated@example.com')
      end
    end

    context 'when the user is not an admin' do
      before { sign_in user }

      it 'does not allow updating the admin field' do
        put "/users/#{user.id}",
            params: { user: { admin: true } }.to_json,
            headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
    
        expect(response).to have_http_status(:forbidden)
    
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Only admins can modify admin status')
      end

      it 'allows updating the email field' do
        put "/users/#{user.id}",
            params: { user: { email: 'non_admin_update@example.com' } }.to_json,
            headers: headers

        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response['email']).to eq('non_admin_update@example.com')
      end
    end

    context 'when the user does not exist' do
      before { sign_in admin_user }

      it 'returns a 404 not found' do
        put "/users/99999",
            params: { user: { email: 'nonexistent@example.com' } }.to_json,
            headers: headers

        expect(response).to have_http_status(:not_found)

        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('User not found')
      end
    end
  end

  describe 'GET /users/:user_id/sets' do
    context 'when the user exists' do
      it 'returns the flashcard sets for the user' do
        get "/users/#{user.id}/sets", headers: { 'Accept' => 'application/json' }

        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response.length).to eq(2)
        expect(json_response[0]['name']).to eq(flashcard_set1.name)
        expect(json_response[1]['name']).to eq(flashcard_set2.name)
      end
    end

    context 'when the user does not exist' do
      it 'returns a 404 not found' do
        get '/users/999999/sets', headers: { 'Accept' => 'application/json' }

        expect(response).to have_http_status(:not_found)

        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('User not found')
      end
    end
  end
end