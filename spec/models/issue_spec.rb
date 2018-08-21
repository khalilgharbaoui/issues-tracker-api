require 'rails_helper'

RSpec.describe Issue, type: :model do
  before{ Issue.set_callback(:validation, :before, :assignee_check, on: :update)}
  before{ Issue.set_callback(:validation, :before, :status_check, on: :update)}

  before{ Issue.skip_callback(:validation, :before, :assignee_check, on: :update)}
  before{ Issue.skip_callback(:validation, :before, :status_check, on: :update)}


  # Validation tests
  # ensure columns title and user_id are present before saving
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:user_id) }
  # it { is_expected.to validate_presence_of(:assigned_to) }
  xit { should validate_presence_of(:status).strict }
end
