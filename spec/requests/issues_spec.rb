require 'rails_helper'

RSpec.describe 'Issues API', type: :request do
  let!(:issues) { create_list(:issue, 10) }

  describe 'GET /issues' do
    before { get '/issues' }

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
      { title: "Valid issue #1", created_by: "1", assigned_to:"nobody", status:"pending" }
    end

    context "when post request is valid" do
      before { post '/issues', params: valid_attributes }

      it 'creates an issue' do
        expect(json['title']).to eq("Valid issue #1")
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    let(:invalid_attributes) do
      { title: "Invalid issue #1", created_by: nil, assigned_to: nil, status: nil }
    end

    context 'when the request is invalid' do
      before { post '/issues', params: invalid_attributes}

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Created by can't be blank, Assigned to can't be blank, Status can't be blank/)
      end
    end
  end
end
