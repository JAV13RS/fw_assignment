require 'rails_helper'

RSpec.describe "Collections API", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:collection) { create(:collection, user: user, name: "Study Materials") }

  let!(:flashcard_set_1) { create(:flashcard_set, user: user, name: "Math Set 1", collection: collection) }
  let!(:flashcard_set_2) { create(:flashcard_set, user: user, name: "Math Set 2", collection: collection) }
  let!(:comment) { create(:comment, user: user, flashcard_set: flashcard_set_1, comment: "Great for beginners!") }

  before do
    collection.flashcard_sets << flashcard_set_1
    collection.flashcard_sets << flashcard_set_2
  end

  describe "GET /collections" do
    context "when format is JSON" do

      it "returns all collections with flashcard sets and comments" do
        get collections_path, as: :json

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)

        expect(json).to be_an(Array)
        expect(json.first).to be_an(Array)

        first_flashcard_set = json.first.first
        expect(first_flashcard_set["comment"]).to eq("Great for beginners!")
        expect(first_flashcard_set["set"]["name"]).to eq("Math Set 1")
        expect(first_flashcard_set["user"]["email"]).to eq(user.email)
      end
    end
  end

  describe "POST /collections" do
    let(:valid_params) do
      {
        collection: {
          name: "New Collection",
          flashcard_sets: [
            { setID: flashcard_set_1.id, comment: "Great for beginners!" },
            { setID: flashcard_set_2.id, comment: "Very useful!" }
          ]
        }
      }
    end
  
    let(:invalid_params) do
      {
        collection: {
          name: "Invalid Collection",
          flashcard_sets: [
            { setID: -1, comment: "This set does not exist" }
          ]
        }
      }
    end
  
    context "when the user is authenticated" do
      before { sign_in user }
  
      context "with valid parameters" do
        it "creates a new collection and returns the data" do
          expect do
            post collections_path, params: valid_params, as: :json
          end.to change(Collection, :count).by(1)
  
          expect(response).to have_http_status(:created)
          json = JSON.parse(response.body)
  
          expect(json).to be_an(Array)
          expect(json.size).to eq(2)
  
          expect(json.first["comment"]).to eq("Great for beginners!")
          expect(json.first["set"]["name"]).to eq("Math Set 1")
          expect(json.first["user"]["email"]).to eq(user.email)
        end
      end
  
      context "with invalid parameters" do
        it "returns a 404 error if a flashcard set is not found" do
          post collections_path, params: invalid_params, as: :json
  
          expect(response).to have_http_status(:unprocessable_entity)  
          json = JSON.parse(response.body)
          expect(json["error"]).to eq("Some flashcard sets not found")
        end
      end
    end
  
    context "when the user is not authenticated" do
      it "returns a 401 Unauthorized error" do
        post collections_path, params: valid_params, as: :json
  
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end  
end
