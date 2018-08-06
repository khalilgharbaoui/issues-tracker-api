class IssueSerializer < ActiveModel::Serializer
  attributes :id, :title, :created_by, :assigned_to, :status, :created_at, :updated_at

  # model association
    # belongs_to :user
end
