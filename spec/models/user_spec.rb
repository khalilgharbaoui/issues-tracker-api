require 'rails_helper'

# Test suite for User model
RSpec.describe User, type: :model do
  # Association test
  # ensure User model has a 1:m relationship with the Issues model
  it { is_expected.to have_many(:issues) }
  # Validation tests
  # ensure name, email and password_digest are present before save
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to validate_presence_of(:password_digest) }
  it "should have manager set to false" do
   expect(subject.manager).to be(false)
  end
end
