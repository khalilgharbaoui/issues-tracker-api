# frozen_string_literal: true

class IssuePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
      if user.manager?
        scope.all
      else
        scope.where(user_id: user.id)
      end
    end
  end

  def index?
    user
  end

  def show?
    manager? || owner?
  end

  def create?
    user && !manager?
  end

  def new?
    create?
  end

  def update?
    manager? || owner?
  end

  def edit?
    update?
  end

  def destroy?
    owner? && !manager?
  end

  def permitted_attributes_for_create
    [:title]
  end

  def permitted_attributes_for_update
    params = if assigned_manager?
               %i[assigned_to status]
             elsif unassigned_manager?
               %i[assigned_to status] if issue_unassigned? || pending?
    end
    params || [:title]
  end

  private

  def owner?
    user == record.user
  end

  def manager?
    user.manager? # || user.access_level >= 3
  end

  def assigned?
    user == record.manager
  end

  def issue_unassigned?
    record.assigned_to.blank?
  end

  def pending?
    record.status == 'pending'
  end

  def assigned_manager?
    manager? && assigned?
  end

  def unassigned_manager?
    manager? && !assigned?
  end
end
