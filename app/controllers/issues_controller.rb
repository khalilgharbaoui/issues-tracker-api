class IssuesController < ApplicationController
  before_action :set_issue, only: [:show, :update, :destroy]

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

  # GET /issues/:id
  def show
    json_response(@issue)
  end

  # PUT /issues/:id
  def update
    @issue.update(issue_params)
    head :no_content
  end

  # DELETE /issues/:id
  def destroy
    @issue.destroy
    head :no_content
  end

  private

  def set_issue
    @issue = Issue.find(params[:id])
  end

  def issue_params
    params.permit(:title, :created_by, :assigned_to, :status)
  end
end
