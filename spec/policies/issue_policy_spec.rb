# frozen_string_literal: true

require 'rails_helper'

describe IssuePolicy do
  subject { described_class.new(user, issue) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Issue.all).resolve
  end

  context 'being a user' do
    let(:user) { create(:user, id: 1, manager: false) }

    context 'accessing owened issues' do
      let(:issue) { create(:issue, id: 1, created_by: user.id) }

      it 'includes issue in resolved scope' do
        expect(resolved_scope).to include(issue)
      end

      it { is_expected.to permit_action(:index) }
      it { is_expected.to permit_action(:show) }
      it { is_expected.to permit_action(:create) }
      it { is_expected.to permit_action(:update) }
      it { is_expected.to permit_action(:destroy) }
    end

    context 'accessing an not owned issue' do
      let(:issue) { Issue.create(created_by: 8998) }

      it 'excludes issue from resolved scope' do
        expect(resolved_scope).not_to include(issue)
      end

      it { is_expected.to_not forbid_action(:index) }
      it { is_expected.to forbid_action(:show) }
      it { is_expected.to forbid_action(:update) }
      it { is_expected.to forbid_action(:destroy) }
    end
  end
  context 'being a manager' do
    let(:user) { create(:user, id: 1, manager: true) }
    let(:user0) { create(:user, id: 2, manager: false, email: 'anotheremail@h.com') }
    context 'accessing all issues' do
      let(:issue) { create(:issue, id: 1, created_by: user.id) }
      let(:issue2) { create(:issue, id: 2, created_by: user0.id) }
      let(:issue3) { create(:issue, id: 3, created_by: user0.id) }

      it 'includes issue in resolved scope' do
        expect(resolved_scope).to include(issue, issue2, issue3)
      end

      it { is_expected.to permit_action(:index) }
      it { is_expected.to permit_action(:show) }
      it { is_expected.to_not permit_action(:create) }
      it { is_expected.to permit_action(:update) }
      it { is_expected.to_not permit_action(:destroy) }
    end

    context 'accessing an not owned issue' do
      let(:issue) { create(:issue, id: 3, created_by: user0.id) }

      it 'includes issue from resolved scope' do
        expect(resolved_scope).to include(issue)
      end

      it { is_expected.to_not forbid_action(:index) }
      it { is_expected.to_not forbid_action(:show) }
      it { is_expected.to forbid_action(:create) }
      it { is_expected.to_not forbid_action(:update) }
      it { is_expected.to forbid_action(:destroy) }
    end
  end
end
