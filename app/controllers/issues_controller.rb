class IssuesController < ApplicationController
  def index
      @issues = Issue.all
      render json: @issues, status: :ok
  end
end
