class IssuesController < ApplicationController
  before_action :set_issue, only: [:show, :update, :destroy]

  # GET /issues
  def index
    if current_user.manager?
      @issues = Issue.all.order("created_at DESC")
      render json: @issues, status: :ok
    else
      @issues = current_user.issues.order("created_at DESC")
      render json: @issues, status: :ok
    end
  end

  # POST /issues
  def create
    begin
      @issue = current_user.issues.create!(issue_params)
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
    # TODO:
    # begin
    #   @issue = current_user.issues.find(params[:id])
    # rescue ActiveRecord::RecordNotFound => e
    #   json_response({ message: "You can only Show, Update or Delete what is yours! no cheating!" }, :unauthorized)
    # end
  end

  def issue_params
    if current_user.manager?
      params.require(:issue).permit(:assigned_to, :status)
    else
      params.require(:issue).permit(:title)
    end
  end
end
