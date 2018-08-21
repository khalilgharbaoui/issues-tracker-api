# frozen_string_literal: true

module V1
  # This handles the RESTful actions and leaves the heavy lifting to the Issue
  # Model "Slim Controllers, Fat Models right?". Authorization done by policies!
  class IssuesController < ApplicationController
    before_action :set_issue, only: %i[show update destroy]

    def index
      authorize @issues = policy_scope(Issue)
                          .paginate(page: params[:page], per_page: 25)
                          .order('created_at DESC')
      @issues = @issues.status(params[:status]) if params[:status].present?
      json_response(@issues)
    end

    def create
      authorize Issue
      @issue = current_user.issues.create!(permitted_attributes(Issue))
      json_response(@issue, :created)
    rescue StandardError => e
      json_response({ message: e.message }, :unprocessable_entity)
    end

    def show
      json_response(@issue)
    end

    def update
      @issue.update(permitted_attributes(@issue))
    end

    def destroy
      if @issue.present?
        @issue.destroy
        head :no_content
      else
        skip_authorization
      end
    end

    private

    def set_issue
      authorize @issue = policy_scope(Issue).find(params[:id])
    end
  end
end
