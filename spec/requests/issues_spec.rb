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
end
