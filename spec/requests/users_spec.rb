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
  let!(:user) { User.create!(email: 'test@example.com', password: 'password', password_confirmation: 'password', admin: false) }
  let(:headers) { { 'Accept' => 'application/json', 'Content-Type' => 'application/json' } }

  before { sign_in user }

  # Test creating a user with valid attributes
  describe "POST /users" do
    context "when the request is valid" do
      it "creates a new user" do
        post "/users", 
             params: valid_attributes.to_json, 
             headers: headers

        expect(response).to have_http_status(:created)

        json_response = JSON.parse(response.body)
        expect(json_response['email']).to eq(valid_attributes[:user][:email])
      end
    end

    context "when the request is invalid" do
      it "returns an unprocessable entity status" do
        post "/users", 
             params: invalid_attributes.to_json, 
             headers: headers

        expect(response).to have_http_status(:unprocessable_entity)

        json_response = JSON.parse(response.body)
        expect(json_response['error']).to include("Password confirmation doesn't match Password")
      end
    end
  end

  # Test getting specific user information
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

  # Test updating a user
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
end