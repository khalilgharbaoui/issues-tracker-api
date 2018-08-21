# frozen_string_literal: true

# This class ensures status and assignee business logic and has access to a per
# request tread safe current user object, this is only used early in the cycle
# before validation is done on update only.
class Issue < ApplicationRecord
  STATUSES = ['pending', 'in progress', 'resolved'].freeze

  validates :title, :user_id, :status, presence: true
  validates :status,
            inclusion: {
              in: STATUSES,
              message: "%{value} is not in [#{STATUSES.join(', ')}]"
            }, strict: ArgumentError

  belongs_to :user, inverse_of: :issues
  belongs_to :manager,
             class_name: 'User', foreign_key: 'assigned_to', optional: true
  before_validation :assignee_check, on: :update
  before_validation :status_check, on: :update
  scope :status, ->(status) { where status: status }

  private

  def assignee_check
    same_assignee? || current_assignee? || blank_assignee? ? return : arg_err
  end

  def status_check
    pending? || in_progress? || resolved? ? return : arg_err
  end

  def same_assignee?
    assignee == existing_assignee
  end

  def current_assignee?
    assignee_current_user? && existing_assignee.blank?
  end

  def blank_assignee?
    assignee.blank? && existing_assignee.blank? || assignee.blank?
  end

  def assignee_current_user?
    assignee.to_i == current_user!.id
  end

  def pending?
    status == 'pending' && blank_assignee? || assignee_current_user?
  end

  def in_progress?
    status == 'in progress' && !blank_assignee?
  end

  def resolved?
    status == 'resolved' && !blank_assignee?
  end

  def assignee
    assigned_to
  end

  def existing_assignee
    issue.assigned_to
  end

  def issue
    Issue.find(id)
  end

  def current_user!
    Current.user
  end

  def arg_err
    raise ArgumentError, "#{caller_locations(1..1).first.label} failed!"
  end
end
