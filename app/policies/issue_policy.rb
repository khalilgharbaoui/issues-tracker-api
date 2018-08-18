class IssuePolicy < ApplicationPolicy

  def index?
    user
  end

  def show?
    user.manager? or record.user == user
  end

  def create?
    user and not user.manager?
  end

  def new?
    create?
  end

  def update?
    user.manager? or record.user == user
  end

  def edit?
    update?
  end

  def destroy?
    record.user == user and not user.manager?
  end


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
end
