class User < ApplicationRecord
  # Model associations
  has_many :issues, inverse_of: :user
  has_many :assigned_issues, :class_name => "Issue", :foreign_key => "assigned_to"

  # Validations
  validates_presence_of :name, :email, :password_digest
  validates :email, uniqueness: true
  # encrypt password
  has_secure_password
end
