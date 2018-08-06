# frozen_string_literal: true

module V1
  class IssuesController < ApplicationController
    before_action :set_issue, only: %i[show update destroy]

    # GET /issues
    def index
      @issues = if current_user.manager?
                  Issue.all.paginate(page: params[:page], per_page: 25).order('created_at DESC')
                else
                  current_user.issues.paginate(page: params[:page], per_page: 25).order('created_at DESC')
                end
      render json: @issues, status: :ok
    end

    # POST /issues
    def create
      @issue = current_user.issues.create!(issue_params)
      render json: @issue, status: :created
    rescue Exception => e
      # raise e
      render json: { message: e.message }, status: :unprocessable_entity
    end

    # GET /issues/:id
    def show
      json_response(@issue)
    end

    # PUT /issues/:id
    def update
      if current_user.manager?
        begin
          conditional_update
        rescue ArgumentError => e
          json_response({
                          message: e.message,
                          assigned_to: "User ID, '1' for example",
                          status: "'pending', 'in progress' or 'resolved'"
                        }, :not_acceptable)
        end
      else
        @issue.update(issue_params)
        head :no_content
      end
    end

    # DELETE /issues/:id
    def destroy
      @issue.destroy
      head :no_content
    end

    private

    def set_issue
      @issue = if current_user.manager?
                 Issue.find(params[:id])
               else
                 current_user.issues.find(params[:id])
               end
    rescue ActiveRecord::RecordNotFound => e
      json_response({
                      message: e.message,
                      explanation: 'View, Update or Delete what is yours! no cheating!'
                    }, :unauthorized)
    end

    def issue_params
      params_array = []
      if current_user.manager? && current_user.assigned_issues.include?(@issue)
        params_array << %i[assigned_to status]
      end
      if current_user.manager? && @issue.manager != current_user && @issue.assigned_to.blank?
        params_array << [:assigned_to]
      end
      params_array << [:title] unless current_user.manager?
      params.permit(params_array)
    end

    def conditional_update
      if assigning_allowed? && status_allowed?
        @issue.update(issue_params)
        head :no_content
      else
        raise ArgumentError
      end
    end

    def assigning_allowed?
      assigning_rules = []
      assigning_rules << params[:assigned_to].to_i == current_user.id
      if @issue.status == 'pending'
        assigning_rules << params[:assigned_to].blank?
      elsif @issue.status == 'in progress' || @issue.status == 'resolved'
        params[:assigned_to] = current_user.id # silently keeps current user as assignee
        assigning_rules << params[:assigned_to].blank? if params[:status] == 'pending'
      end
      assigning_rules.any?
    end

    def status_allowed?
      allowed_statuses = ['pending', 'in progress', 'resolved']
      status_only_allowed_when_in_allowed_statuses = allowed_statuses.any? { |word| word == params[:status].downcase unless params[:status].blank? }
      status_only_allowed_when_in_allowed_statuses || params[:status].blank?
    end
  end
end
