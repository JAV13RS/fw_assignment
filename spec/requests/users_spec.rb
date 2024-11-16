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

  # Test creating a user with valid attributes
  describe "POST /users" do
    context "when the request is valid" do
      it "creates a new user" do
        post "/users", 
             params: valid_attributes.to_json, 
             headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }

        expect(response).to have_http_status(:created)

        json_response = JSON.parse(response.body)
        expect(json_response['email']).to eq(valid_attributes[:user][:email])
      end
    end

    context "when the request is invalid" do
      it "returns an unprocessable entity status" do
        post "/users", 
             params: invalid_attributes.to_json, 
             headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }

        expect(response).to have_http_status(:unprocessable_entity)

        json_response = JSON.parse(response.body)
        expect(json_response['error']).to include("Password confirmation doesn't match Password")
      end
    end
  end
end