class Issue < ApplicationRecord

  validates_presence_of :title, :created_by, :status
  belongs_to :user, :class_name => "User", :foreign_key => 'created_by'
  belongs_to :manager, :class_name => "User", :foreign_key => 'assigned_to', optional: true
end
