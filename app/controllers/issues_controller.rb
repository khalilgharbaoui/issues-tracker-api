class IssuesController < ApplicationController

  # GET /issues
  def index
      @issues = Issue.all
      render json: @issues, status: :ok
  end

  # POST /issues
  def create
      begin
        @issue = Issue.create!(issue_params)
        render json: @issue, status: :created
      rescue Exception => e
        # raise e
        render json: { message: e.message }, status: :unprocessable_entity
      end
  end

  private

  def issue_params
    params.permit(:title, :created_by, :assigned_to, :status)
  end
end
