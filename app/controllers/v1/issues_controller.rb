# frozen_string_literal: true

module V1
  class IssuesController < ApplicationController
    before_action :set_issue, only: %i[show update destroy]

    # GET /issues
    def index
      authorize @issues = policy_scope(Issue)
                          .paginate(page: params[:page], per_page: 25)
                          .order('created_at DESC')
      @issues = @issues.status(params[:status]) if params[:status].present?
      render json: @issues, status: :ok
    end

    # POST /issues
    def create
      authorize Issue
      @issue = current_user.issues.create!(permitted_attributes(@issue))
      render json: @issue, status: :created
    rescue Exception => e
      render json: { message: e.message }, status: :unprocessable_entity
    end

    # GET /issues/:id
    def show
      json_response(@issue)
    end

    # PUT /issues/:id
    def update
      if current_user.manager?
        conditional_update
      else
        @issue.update(permitted_attributes(@issue))
        head :no_content
      end
    rescue ArgumentError => e
      json_response({
                      message: e.message,
                      assigned_to: "'#{current_user.id}', ''",
                      status: 'pending, in progress, resolved'
                    }, :bad_request)
    end

    # DELETE /issues/:id
    def destroy
        if @issue.present?
         authorize @issue
         @issue.destroy
         head :no_content
       else
         skip_authorization
       end
    end

    private

    def set_issue
      authorize @issue = policy_scope(Issue).find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      json_response({
                      message: e.message,
                      explanation: 'Does not exist or you are not allowed!'
                    }, :not_found)
    end



    def conditional_update
      if assigning_allowed? && status_allowed?
        @issue.update(permitted_attributes(@issue))
        head :no_content
      else
        raise ArgumentError
      end
    end

    def assigning_allowed?
      @assigning_rules = []
      if @issue.status == 'pending'
        status_pending_logic
      elsif @issue.status == 'in progress' || @issue.status == 'resolved'
        status_in_progress_or_resolved_logic
      end
      @assigning_rules.any?
    end

    def status_allowed?
      allowed_statuses = ['pending', 'in progress', 'resolved']
      status_only_allowed_when_in_allowed_statuses = allowed_statuses.any? { |word| word == params[:status].downcase unless params[:status].blank? }
      status_only_allowed_when_in_allowed_statuses || params[:status].blank?
    end

    def status_pending_logic
      false unless @issue.status == 'pending'
      if @issue.assigned_to.blank?
        issue_assigned_to_is_blank_exceptions!
        assigning_rules!
      elsif @issue.assigned_to.to_i == current_user.id.to_i
        issue_manager_equals_current_user_exceptions!
        assigning_rules!
      elsif @issue.assigned_to.to_i != current_user.id.to_i # someone else
        issue_manager_not_equal_to_current_user_exceptions!
        assigning_rules!
      end
    end

    def status_in_progress_or_resolved_logic
      false unless @issue.status == 'in progress' || @issue.status == 'resolved'
      issue_status_in_progress_or_resolved_exceptions!
      status_assigning_rules!
    end

    def issue_assigned_to_is_blank_exceptions!
      if params[:assigned_to].blank? && params[:status].blank?
        raise ArgumentError, "Issue #{@issue.status} and assigned to: #{@issue.manager ? @issue.manager.id : ' ⚠️ nobody ⚠️ '}" if params[:status].blank?
      end
      if !!(params[:assigned_to].to_i != current_user.id.to_i) # you
        raise ArgumentError, "Issue can only be assigned to: #{current_user.id}" unless params[:assigned_to].blank?
        raise ArgumentError, "Issue is #{@issue.status} and unassigned! must be assigned to change status!" if params[:assigned_to].blank?
      end
    end

    def issue_manager_equals_current_user_exceptions!
      if params[:status] == 'in progress' || params[:status] == 'resolved'
        if params[:assigned_to].blank?
          params[:assigned_to] = current_user.id.to_i
          raise ArgumentError, 'Issue can only change status when assigned!' unless @issue.assigned_to.to_i == params[:assigned_to].to_i
        end
      end
      if !!(params[:assigned_to].to_i == @issue.assigned_to.to_i) # you
        raise ArgumentError, "Issue already assigned to: #{@issue.manager.id}" if params[:status].blank? && !params[:assigned_to].blank?
      end
      if !params[:assigned_to].blank? && !!(params[:assigned_to].to_i != current_user.id.to_i) # you
        raise ArgumentError, "Issue can only be assigned to: #{@issue.manager.id || current_user.id}"
      end
    end

    def issue_manager_not_equal_to_current_user_exceptions!
      if !!(params[:assigned_to].to_i != @issue.assigned_to.to_i)
        raise ArgumentError, "Issue already assigned to: #{@issue.manager.id}" unless params[:assigned_to].blank?
        raise ArgumentError, "Issue can't be modified. #{@issue.status} and assigned to: #{@issue.manager.id}" if params[:assigned_to].blank?
      end
      if !!(params[:assigned_to].to_i == @issue.assigned_to.to_i)
        raise ArgumentError, "Issue already assigned to: #{@issue.manager.id}"
      end
    end

    def issue_status_in_progress_or_resolved_exceptions!
      unless !!(current_user.id.to_i == @issue.assigned_to.to_i)
        raise ArgumentError, "Issue is #{@issue.status} and assigned to: #{@issue.manager ? @issue.manager.id : ' ⚠️ nobody ⚠️ '}"
      end
      if params[:assigned_to].blank? && params[:status].blank?
        raise ArgumentError, "Issue can't be unassigned when #{@issue.status} and assigned to: #{@issue.manager.id}"
      end
      if !!(params[:assigned_to].to_i == @issue.assigned_to.to_i) && params[:status].blank?
        raise ArgumentError, "Issue already assigned to: #{@issue.manager.id}"
      end
      if !params[:assigned_to].blank? && !!(params[:assigned_to].to_i != @issue.assigned_to.to_i || params[:assigned_to].to_i != current_user.id.to_i)
        raise ArgumentError, "Issue can only be assigned to: #{@issue.manager.id} (you!)"
      end
    end

    def assigning_rules!
      @assigning_rules << !!(params[:assigned_to].to_i == current_user.id.to_i)
      @assigning_rules << params[:assigned_to].blank?
    end

    def status_assigning_rules!
      # silently keeps current user as assignee
      params[:assigned_to] = current_user.id
      @assigning_rules << !!(params[:assigned_to].to_i == current_user.id.to_i)
      @assigning_rules << params[:assigned_to].blank? if params[:status] == 'pending'
      params[:assigned_to] = current_user.id if @issue.assigned_to.blank?
    end
  end
end
