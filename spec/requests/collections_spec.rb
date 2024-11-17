require 'rails_helper'

RSpec.describe "Collections API", type: :request do
  let(:user) { create(:user) }
  let!(:collections) { create_list(:collection, 3, user: user) }
  let(:flashcard_set) { create(:flashcard_set) }

  def json
    JSON.parse(response.body)
  end

  # Set the default headers for all requests
  let(:headers) do
    {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json'
    }
  end
  # tests for /users/:user_id/collections
  describe "GET /users/:user_id/collections" do
    it "returns all collections for the user" do
      get "/users/#{user.id}/collections", headers: headers

      expect(response).to have_http_status(200)
      expect(json.size).to eq(3)
    end
  end

  describe "POST /users/:user_id/collections" do
    let(:valid_attributes) do
      {
        collection: {
          name: 'New Collection',
          flashcard_set_ids: [flashcard_set.id]
        }
      }
    end

    context "when user is authenticated" do
      before { sign_in user }

      it "creates a new collection" do
        post "/users/#{user.id}/collections", params: valid_attributes.to_json, headers: headers
      
        expect(response).to have_http_status(201)
        expect(json['name']).to eq('New Collection')
        expect(json['flashcard_sets']).to be_an(Array)
        expect(json['flashcard_sets']).to_not be_empty
      end      
    end

    context "when user is not authenticated" do
      it "fails and returns an Unauthorized error" do
        post "/users/#{user.id}/collections", params: valid_attributes.to_json, headers: headers

        expect(response).to have_http_status(401)
      end
    end
  end

  describe "GET /users/:user_id/collections/:id" do
    let(:collection) { create(:collection, user: user) }

    it "returns a single collection" do
      get "/users/#{user.id}/collections/#{collection.id}", headers: headers

      expect(response).to have_http_status(200)
      expect(json['id']).to eq(collection.id)
    end

    it "returns 404 if collection is not found" do
      get "/users/#{user.id}/collections/invalid_id", headers: headers

      expect(response).to have_http_status(404)
    end
  end

  describe "PUT /users/:user_id/collections/:id" do
    let(:collection) { create(:collection, user: user) }
    let(:valid_attributes) do
      {
        collection: {
          name: 'Updated Name',
          flashcard_set_ids: [flashcard_set.id]
        }
      }
    end

    context "when user is authenticated" do
      before { sign_in user }

      it "updates the collection" do
        put "/users/#{user.id}/collections/#{collection.id}", params: valid_attributes.to_json, headers: headers

        expect(response).to have_http_status(200)
        expect(json['name']).to eq('Updated Name')
      end

      it "returns 404 if collection is not found" do
        put "/users/#{user.id}/collections/invalid_id", params: valid_attributes.to_json, headers: headers

        expect(response).to have_http_status(404)
      end
    end

    context "when user is not authenticated" do
      it "returns 401 Unauthorized" do
        put "/users/#{user.id}/collections/#{collection.id}", params: valid_attributes.to_json, headers: headers

        expect(response).to have_http_status(401)
      end
    end
  end

  describe "DELETE /users/:user_id/collections/:id" do
    let(:collection) { create(:collection, user: user) }

    context "when user is authenticated" do
      before { sign_in user }

      it "deletes the collection" do
        delete "/users/#{user.id}/collections/#{collection.id}", headers: headers

        expect(response).to have_http_status(204)
        expect(Collection.exists?(collection.id)).to eq(false)
      end

      it "returns 404 if collection is not found" do
        delete "/users/#{user.id}/collections/invalid_id", headers: headers

        expect(response).to have_http_status(404)
      end
    end

    context "when user is not authenticated" do
      it "returns 401 Unauthorized" do
        delete "/users/#{user.id}/collections/#{collection.id}", headers: headers

        expect(response).to have_http_status(401)
      end
    end
  end
end
