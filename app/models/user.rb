class User < ApplicationRecord
  # Model associations
  has_many :issues, foreign_key: :created_by
  # Validations
  validates_presence_of :name, :email, :password_digest
  validates :email, uniqueness: true
  # encrypt password
  has_secure_password
end
