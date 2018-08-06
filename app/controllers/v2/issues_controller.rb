# frozen_string_literal: true

class V2::IssuesController < ApplicationController
  def index
    json_response(message: 'Comming Soon...',
                  your_id: current_user.id)
  end
end
