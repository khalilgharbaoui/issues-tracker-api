require 'rails_helper'

RSpec.describe Issue, type: :model do

  # Validation tests
  # ensure columns title and created_by are present before saving
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:created_by) }
  # it { is_expected.to validate_presence_of(:assigned_to) }
  it { is_expected.to validate_presence_of(:status) }
end
