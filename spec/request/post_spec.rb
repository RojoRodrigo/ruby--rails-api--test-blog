require "rails_helper"
require "byebug"

RSpec.describe "Posts", type: :request do
  
  describe "GET /posts" do
    before { get '/posts' }

    it "should return OK" do
      payload = JSON.parse(response.body)
      expect(payload).to be_empty
      expect(response).to have_http_status(200)
    end
  end

  describe "with data in the DB" do
    let!(:posts) { create_list(:post, 10, published: true) }

    it "should return all the published post" do
      get '/posts'
      payload = JSON.parse(response.body)
      expect(payload.size).to eq(posts.size)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /posts/{id}" do
    let!(:post) { create(:post) }

    it "should return a post" do
      get "/posts/#{post.id}"
      payload = JSON.parse(response.body)
      expect(payload).not_to be_empty
      expect(payload['id']).to eq(post.id)
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /posts" do
    let!(:user) { create(:user) }

    it "should create a post" do
      req_payload = {
        post: {
          title: "titulo",
          content: "content",
          published: false,
          user_id: user.id,
        }
      }

      post "/posts", params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).not_to be_empty
      expect(payload["id"]).not_to be_nil
      expect(response).to have_http_status(:created)
    end

    it "should return error message on invalid post" do
      req_payload = {
        post: {
          content: "content",
          published: false,
          user_id: 1,
        }
      }

      post "/posts", params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).not_to be_empty
      expect(payload["error"]).not_to be_empty
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PUT /posts/{id}" do
    let!(:post) { create(:post) }

    it "should create a post" do
      req_payload = {
        post: {
          title: "titulo",
          content: "content",
          published: true,
        }
      }

      put "/posts/#{post.id}", params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).not_to be_empty
      expect(payload["id"]).to eq(post.id)
      expect(response).to have_http_status(:ok)
    end

    it "should return error message on invalid post" do
      req_payload = {
        post: {
          title: nil,
          content: nil,
          published: false,
        }
      }

      put "/posts/#{post.id}", params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).not_to be_empty
      expect(payload["error"]).not_to be_empty
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end