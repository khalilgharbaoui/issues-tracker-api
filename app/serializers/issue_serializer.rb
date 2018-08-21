class IssueSerializer < ActiveModel::Serializer
  attributes :id, :title, :user_id, :assigned_to, :status, :created_at, :updated_at

  # model association
    # belongs_to :user
end
