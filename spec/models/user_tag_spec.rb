# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserTag, type: :model do
  subject { UserTag.create user: user, tag: tag, tag_category: tag_category }

  let(:company) { create(:company) }
  let(:other_company) { create(:company, name: 'other Cie', siret: '1234567890POIU') }
  let(:user) { create(:user, company: company) }
  let(:tag) { create(:tag, company: tag_company, tag_name: 'Établissement', tag_category: tag_category) }
  let(:tag_category) { create(:tag_category, company: company, position: 1) }

  describe "#same_company" do
    context 'when user and tag belong to the same company' do
      let(:tag_company) { company }
      it 'validates the new instance' do
        expect(subject.persisted?).to be true
      end
    end

    context 'when user and tag do not belong to the same company' do
      let(:tag_company) { other_company }
      it 'does NOT validate the new instance' do
        expect(subject.persisted?).to be false
      end
    end
  end
end
