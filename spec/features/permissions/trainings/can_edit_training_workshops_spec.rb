# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Permission :can_edit_training_workshops', type: :feature, js: true do
  let(:company) { create(:company) }
  let(:training) do
    create(
      :training,
      creator: creator,
      title: 'a workshop',
      company: company
    )
  end
  let(:creator) { create(:user, email: 'creator@gmail.com') }


  let(:content) { create(:content, title: 'le petit chaperon rouge', company: company) }
  let(:workshop) { create(:workshop, title: 'il était une fois', content: content) }
  let!(:session) do
    create(
      :session,
      training: training,
      workshop: workshop,
      date: Date.today,
      starts_at: Date.today
    )
  end

  context 'the training show' do
    context 'a not signed in user' do
      scenario 'should not have access' do
        visit training_path(training)
        expect(page).to have_current_path new_user_session_path
      end
    end

    context 'a signed in user without permission' do
      let(:user) { create(:user, company: company) }
      before { login_as user }
      scenario 'should have access' do
        visit training_path(training)
        expect(page).to have_current_path training_path(training)
      end
    end

    context 'a signed in user with permission' do
      let(:user) { create(:user, company: company, can_edit_training_workshops: true) }
      before { login_as user }
      scenario 'should have access' do
        visit training_path(training)
        expect(page).to have_current_path training_path(training)
      end
    end
  end

  context 'the Training Workshop Edit CTA' do
    context 'a not signed in user' do
      scenario 'should not have access' do
        visit training_path(training)
        expect(page).to have_current_path new_user_session_path
      end
    end

    context 'a signed in user without permission' do
      let(:user) { create(:user, company: company) }
      before { login_as user }
      scenario 'should not have access' do
        visit training_path(training)
        expect(page).not_to have_selector("[data-handle='training-workshop-edit-cta']")
      end
    end

    context 'a signed in user with permission' do
      let(:user) do
        model = FactoryBot.build(:user,
                                 can_edit_training_workshops: true
        )
        model.skip_before_create = true
        model.save
        model
      end
      before { login_as user }

      scenario 'should not have access' do
        visit training_path(training)
        expect(page).to have_selector("[data-handle='training-workshop-edit-cta']")
      end
    end

    context 'a signed in user being the training creator' do
      let(:creator) { user }
      let(:user) { create(:user, company: company) }
      before { login_as user }
      scenario 'should have access' do
        visit training_path(training)
        expect(page).to have_selector("[data-handle='training-workshop-edit-cta']")
      end
    end
  end
end
