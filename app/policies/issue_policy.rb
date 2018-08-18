# frozen_string_literal: true

class IssuePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
      if user.manager?
        scope.all
      else
        scope.where(created_by: user.id)
      end
    end
  end

  def index?
    user
  end

  def show?
    user.manager? || (record.user == user)
  end

  def create?
    user && !user.manager?
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
    (record.user == user) && !user.manager?
  end

  def permitted_attributes_for_create
    [:title]
  end

  def permitted_attributes_for_update
    if assigned_manager?
      %i[assigned_to status]
    elsif unassigned_manager?
      [:assigned_to]
    else
      [:title]
    end
  end

  private

  def owner?
    user == record.user
  end

  def manager?
    user.manager?
  end

  def assigned_manager?
    manager? && user == record.manager
  end

  def unassigned_manager?
    manager && user != record.manager
  end
end
