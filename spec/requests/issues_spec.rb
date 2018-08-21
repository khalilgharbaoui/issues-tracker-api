require 'rails_helper'

RSpec.describe 'Issues API', type: :request do

  let(:user) { create(:user) }
  let!(:issues) { create_list(:issue, 10, user_id: user.id)  }
  let(:issue_id) { issues.first.id }

  # authorize request
  let(:headers) { valid_headers }

  describe 'GET /issues' do
    before { get '/issues', params: {}, headers: headers }

    it 'returns issues' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /issues' do
    let(:valid_attributes) do
      { title: "Valid issue #1", user_id: user.id.to_s, assigned_to:"nobody", status:"pending" }.to_json
    end

    context "when post request is valid" do
      before { post '/issues', params: valid_attributes, headers: headers }

      it 'creates an issue' do
        expect(json['title']).to eq("Valid issue #1")
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    let(:invalid_attributes) do
      { title: nil }.to_json
    end

    context 'when the request is invalid' do
      before { post '/issues', params: invalid_attributes, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(json['message'])
          .to match(/Validation failed: Title can't be blank/)
      end
    end
  end

  describe 'GET /issues/:id' do
    before { get "/issues/#{issue_id}", params: {}, headers: headers }

    context 'when the record exists' do
      it 'returns the issue' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(issue_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:issue_id) { 997992 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Issue/)
      end
    end
  end

  describe 'PUT /issues/:id' do
    let(:valid_attributes) { { title: 'Updated issue #1.1' }.to_json }

    context 'when the record exists' do
      before { put "/issues/#{issue_id}", params: valid_attributes, headers: headers }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /issues/:id' do
    before { delete "/issues/#{issue_id}", params: {}, headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
