# frozen_string_literal: true

require 'rails_helper'

describe TrainingReports::GenerateData do
  subject do
    TrainingReports::GenerateData.call(training_report: training_report)
  end

  let(:company) { create(:company) }
  let(:title) { 'Beatrix' }
  let(:content) { create(:content, title: title, company: company) }
  let(:workshop) { create(:workshop, title: title, content: content) }
  let(:creator) { create(:user, email: Faker::Internet.email, company: company) }
  let!(:training1) { create(:training, title: title, company: company, creator: creator) }

  let(:starts_at) { '09:00' }
  let(:ends_at) { '17:00' }
  let(:session_cost) { 100 }

  let(:user1) { create(:user, email: Faker::Internet.email, company: company) }
  let(:user2) { create(:user, email: Faker::Internet.email, company: company) }
  let(:user3) { create(:user, email: Faker::Internet.email, company: company) }
  let(:unselected_user) { create(:user, email: Faker::Internet.email, company: company) }


  let(:training1_session_params) {{ available_date: nil, starts_at: starts_at, ends_at: ends_at,
    cost: session_cost, training: training1, workshop: workshop }}

  let(:session1_1) { create(:session, training1_session_params.merge(date: session1_1_date)) }
  let(:session1_2) { create(:session, training1_session_params.merge(date: session1_2_date)) }
  let(:session1_3) { create(:session, training1_session_params.merge(date: session1_3_date)) }
  let(:session1_4) { create(:session, training1_session_params.merge(date: session1_4_date)) }

  let(:training_report) {
    create(:training_report,
      company: company,
      state: :enqueued,
      mode: mode,
      start_time: DateTime.new(2022,03,1),
      end_time: DateTime.new(2022,12,31),
      creator: creator,
      participant_ids: participant_ids,
      training_ids: training_ids
    )
  }

  context 'with 1 training not completed' do
    before do
      [session1_1, session1_2, session1_3, session1_4].each do |session|
        [user1, user2, user3, unselected_user].each do |user|
          create(:attendee, creator: creator, user: user, session: session)
        end
      end
    end


    context 'outside the period' do
      let(:session1_1_date) { Date.new(2022,01,1) }
      let(:session1_2_date) { Date.new(2022,01,2) }
      let(:session1_3_date) { Date.new(2022,01,3) }
      let(:session1_4_date) { Date.new(2022,01,4)  }
      context 'by_training' do
        let(:mode) { :by_training }
        let(:participant_ids) {[]}
        let(:training_ids) {[training1.id]}

        it 'should generate empty data' do
          subject

          expect(training_report.done?).to eq true
          expect(training_report.computed_participant_ids).to eq []
          expect(training_report.computed_participant_ids.count).to eq 0

          expect(training_report.computed_training_ids).to eq []
          expect(training_report.computed_training_ids.count).to eq 0
          expect(training_report.computed_done_training_ids).to eq []
          expect(training_report.computed_done_training_ids.count).to eq 0

          expect(training_report.computed_total_duration_in_secs).to eq '0'
          expect(training_report.computed_total_cost_cents).to eq '0'

          expect(training_report.computed_training_lines_by_employee).to eq []
          expect(training_report.computed_training_lines_by_training).to eq []

          expect(training_report.valid?).to eq false # locked!
        end
      end

      context 'by_employee' do
        let(:mode) { :by_employee }
        let(:participant_ids) {[user1.id, user2.id, user3.id]}
        let(:training_ids) {[]}

        it 'should generate empty data' do
          subject

          expect(training_report.done?).to eq true
          expect(training_report.computed_participant_ids).to eq []
          expect(training_report.computed_participant_ids.count).to eq 0

          expect(training_report.computed_training_ids).to eq []
          expect(training_report.computed_training_ids.count).to eq 0
          expect(training_report.computed_done_training_ids).to eq []
          expect(training_report.computed_done_training_ids.count).to eq 0

          expect(training_report.computed_total_duration_in_secs).to eq '0'
          expect(training_report.computed_total_cost_cents).to eq '0'

          expect(training_report.computed_training_lines_by_employee).to eq []
          expect(training_report.computed_training_lines_by_training).to eq []

          expect(training_report.valid?).to eq false # locked!
        end
      end
    end

    context 'within the period' do
      let(:session1_1_date) { Date.new(2022,02,28) }
      let(:session1_2_date) { Date.new(2022,03,01) }
      let(:session1_3_date) { Date.new(2022,03,15) }
      let(:session1_4_date) { Date.new(2022,04,1)  }

      context 'by_training' do
        let(:mode) { :by_training }
        let(:participant_ids) {[]}
        let(:training_ids) {[training1.id]}
        it 'should generate data' do
          subject

          expect(training_report.done?).to eq true
          expect(training_report.computed_participant_ids.sort).to eq(
            [user1, user2, user3, unselected_user].map(&:id).map(&:to_s).sort
          )
          expect(training_report.computed_participant_ids.count).to eq 4

          expect(training_report.computed_training_ids).to eq [training1.id].map(&:to_s)
          expect(training_report.computed_training_ids.count).to eq 1
          expect(training_report.computed_done_training_ids).to eq []
          expect(training_report.computed_done_training_ids.count).to eq 0
          expect(training_report.computed_done_training_users_count).to eq "0"
          expect(training_report.computed_all_training_users_count).to eq "4"

          expect(training_report.computed_total_duration_in_secs).to eq '345600'
          expect(training_report.computed_total_cost_cents).to eq '120000'

          expect(training_report.computed_training_lines_by_employee).to eq []
          expect(training_report.computed_training_lines_by_training).to eq [
            [
              ['training_name', 'Beatrix'],
              ['employees', '4'],
              ['trained_employees', '0/4'],
              ['duration_in_secs', '345600'],
              ['cost_per_employee_in_cents', '30000']
            ]
          ]

          expect(training_report.valid?).to eq false # locked!
        end
      end

      context 'by_employee' do
        let(:mode) { :by_employee }
        let(:participant_ids) {[user1.id, user2.id, user3.id]}
        let(:training_ids) {[]}
        it 'should generate data' do
          subject

          expect(training_report.done?).to eq true
          expect(training_report.computed_participant_ids).to eq participant_ids.map(&:to_s)
          expect(training_report.computed_participant_ids.count).to eq 3

          expect(training_report.computed_training_ids).to eq [training1.id].map(&:to_s)
          expect(training_report.computed_training_ids.count).to eq 1
          expect(training_report.computed_done_training_ids).to eq []
          expect(training_report.computed_done_training_ids.count).to eq 0
          expect(training_report.computed_done_training_users_count).to eq nil
          expect(training_report.computed_all_training_users_count).to eq nil

          expect(training_report.computed_total_duration_in_secs).to eq '259200'
          expect(training_report.computed_total_cost_cents).to eq '90000'

          expect(training_report.computed_training_lines_by_employee).to eq [
            [
              ['training_name', 'Beatrix'],
              ['employees', '3'],
              ['trainings_done', '0/3'],
              ['duration_in_secs', '259200'],
              ['cost_per_employee_in_cents', '30000']
            ]
          ]
          expect(training_report.computed_training_lines_by_training).to eq []

          expect(training_report.valid?).to eq false # locked!
        end
      end
    end

  end

  context 'with 2 trainings 1 completed / 2' do
    let!(:training2) { create(:training, title: 'Pégase', company: company, creator: creator) }
    let(:session1_1_date) { Date.new(2022,02,28) }
    let(:session1_2_date) { Date.new(2022,03,01) }
    let(:session1_3_date) { Date.new(2022,03,15) }
    let(:session1_4_date) { Date.new(2022,04,1)  }

    let(:training2_session_params) {{ available_date: nil, starts_at: starts_at, ends_at: ends_at,
      cost: session_cost, training: training2, workshop: workshop }}
    let(:session2_1_date) { Date.new(2022,03,1) }
    let(:session2_2_date) { Date.new(2022,03,2) }
    let(:session2_3_date) { Date.new(2022,03,3) }
    let(:session2_4_date) { Date.new(2022,04,6)  }
    let(:session2_1) { create(:session, training2_session_params.merge(date: session2_1_date)) }
    let(:session2_2) { create(:session, training2_session_params.merge(date: session2_2_date)) }
    let(:session2_3) { create(:session, training2_session_params.merge(date: session2_3_date)) }
    let(:session2_4) { create(:session, training2_session_params.merge(date: session2_4_date)) }


    before do
      [session1_1, session1_2, session1_3, session1_4].each do |session|
        [user1, user2, unselected_user].each do |user|
          create(:attendee, creator: creator, user: user, session: session)
        end
        create(:attendee, creator: creator, user: user3, session: session, status: 'Completed')
      end

      [session2_1, session2_2, session2_3, session2_4].each do |session|
        [user1, user2].each do |user|
          create(:attendee, creator: creator, user: user, session: session, status: 'Completed')
        end
      end
    end



    context 'by_training' do
      context 'with training1 and training2' do
        let(:mode) { :by_training }
        let(:participant_ids) {[]}
        let(:training_ids) {[training1.id, training2.id]}

        it 'should generate data' do
          subject

          expect(training_report.done?).to eq true
          expect(training_report.computed_participant_ids.sort).to eq(
            [user1, user2, user3, unselected_user].map(&:id).map(&:to_s).sort
          )
          expect(training_report.computed_participant_ids.count).to eq 4

          expect(training_report.computed_training_ids).to eq [training1.id, training2.id].map(&:to_s)
          expect(training_report.computed_training_ids.count).to eq 2
          expect(training_report.computed_done_training_ids).to eq [training2.id].map(&:to_s)
          expect(training_report.computed_done_training_ids.count).to eq 1
          expect(training_report.computed_done_training_users_count).to eq "3"
          expect(training_report.computed_all_training_users_count).to eq "6"

          expect(training_report.computed_total_duration_in_secs).to eq '576000'
          expect(training_report.computed_total_cost_cents).to eq '200000'

          expect(training_report.computed_training_lines_by_employee).to eq []
          expect(training_report.computed_training_lines_by_training).to eq [
            [
              ['training_name', 'Beatrix'],
              ['employees', '4'],
              ['trained_employees', '1/4'],
              ['duration_in_secs', '345600'],
              ['cost_per_employee_in_cents', '30000']
            ],
            [
              ['training_name', 'Pégase'],
              ['employees', '2'],
              ['trained_employees', '2/2'],
              ['duration_in_secs', '230400'],
              ['cost_per_employee_in_cents', '40000']
            ]
          ]

          expect(training_report.valid?).to eq false # locked!
        end
      end

      context 'with training2' do
        let(:mode) { :by_training }
        let(:participant_ids) {[]}
        let(:training_ids) {[training2.id]}

        it 'should generate data' do
          subject

          expect(training_report.done?).to eq true
          expect(training_report.computed_participant_ids.sort).to eq(
            [user1, user2].map(&:id).map(&:to_s).sort
          )
          expect(training_report.computed_participant_ids.count).to eq 2

          expect(training_report.computed_training_ids).to eq [training2.id].map(&:to_s)
          expect(training_report.computed_training_ids.count).to eq 1
          expect(training_report.computed_done_training_ids).to eq [training2.id].map(&:to_s)
          expect(training_report.computed_done_training_ids.count).to eq 1
          expect(training_report.computed_done_training_users_count).to eq "2"
          expect(training_report.computed_all_training_users_count).to eq "2"

          expect(training_report.computed_total_duration_in_secs).to eq '230400'
          expect(training_report.computed_total_cost_cents).to eq '80000'

          expect(training_report.computed_training_lines_by_employee).to eq []
          expect(training_report.computed_training_lines_by_training).to eq [
            [
              ['training_name', 'Pégase'],
              ['employees', '2'],
              ['trained_employees', '2/2'],
              ['duration_in_secs', '230400'],
              ['cost_per_employee_in_cents', '40000']
            ]
          ]
          expect(training_report.valid?).to eq false # locked!
        end
      end

    end

    context 'by_employee' do

      context 'with users 1, 2 and 3' do
        let(:mode) { :by_employee }
        let(:participant_ids) {[user1.id, user2.id, user3.id]}
        let(:training_ids) {[]}

        it 'should generate data' do
          subject

          expect(training_report.done?).to eq true
          expect(training_report.computed_participant_ids.sort).to eq participant_ids.sort.map(&:to_s)
          expect(training_report.computed_participant_ids.count).to eq 3

          expect(training_report.computed_training_ids).to eq [training1.id, training2.id].map(&:to_s)
          expect(training_report.computed_training_ids.count).to eq 2
          expect(training_report.computed_done_training_ids).to eq [training2.id].map(&:to_s)
          expect(training_report.computed_done_training_ids.count).to eq 1
          expect(training_report.computed_done_training_users_count).to eq nil
          expect(training_report.computed_all_training_users_count).to eq nil

          expect(training_report.computed_total_duration_in_secs).to eq '489600'
          expect(training_report.computed_total_cost_cents).to eq '170000'

          expect(training_report.computed_training_lines_by_employee).to eq [
            [
              ['training_name', 'Beatrix'],
              ['employees', '3'],
              ['trainings_done', '1/3'],
              ['duration_in_secs', '259200'],
              ['cost_per_employee_in_cents', '30000']
            ],
            [
              ['training_name', 'Pégase'],
              ['employees', '2'],
              ['trainings_done', '2/2'],
              ['duration_in_secs', '230400'],
              ['cost_per_employee_in_cents', '40000']
            ]
          ]
          expect(training_report.computed_training_lines_by_training).to eq []
          expect(training_report.valid?).to eq false # locked!
        end
      end

      context 'without users 1 and 2' do
        let(:mode) { :by_employee }
        let(:participant_ids) {[user1.id, user2.id]}
        let(:training_ids) {[]}

        it 'should generate data' do
          subject

          expect(training_report.done?).to eq true
          expect(training_report.computed_participant_ids.sort).to eq participant_ids.sort.map(&:to_s)
          expect(training_report.computed_participant_ids.count).to eq 2

          expect(training_report.computed_training_ids).to eq [training1.id, training2.id].map(&:to_s)
          expect(training_report.computed_training_ids.count).to eq 2
          expect(training_report.computed_done_training_ids).to eq [training2.id].map(&:to_s)
          expect(training_report.computed_done_training_ids.count).to eq 1
          expect(training_report.computed_done_training_users_count).to eq nil
          expect(training_report.computed_all_training_users_count).to eq nil

          expect(training_report.computed_total_duration_in_secs).to eq '403200'
          expect(training_report.computed_total_cost_cents).to eq '140000'

          expect(training_report.computed_training_lines_by_employee).to eq [
            [
              ['training_name', 'Beatrix'],
              ['employees', '2'],
              ['trainings_done', '0/2'],
              ['duration_in_secs', '172800'],
              ['cost_per_employee_in_cents', '30000']
            ],
            [
              ['training_name', 'Pégase'],
              ['employees', '2'],
              ['trainings_done', '2/2'],
              ['duration_in_secs', '230400'],
              ['cost_per_employee_in_cents', '40000']
            ]
          ]
          expect(training_report.computed_training_lines_by_training).to eq []
          expect(training_report.valid?).to eq false # locked!
        end
      end

      context 'without users 1 and 3' do
        let(:mode) { :by_employee }
        let(:participant_ids) {[user1.id, user3.id]}
        let(:training_ids) {[]}

        it 'should generate data' do
          subject

          expect(training_report.done?).to eq true
          expect(training_report.computed_participant_ids.sort).to eq participant_ids.sort.map(&:to_s)
          expect(training_report.computed_participant_ids.count).to eq 2

          expect(training_report.computed_training_ids).to eq [training1.id, training2.id].map(&:to_s)
          expect(training_report.computed_training_ids.count).to eq 2
          expect(training_report.computed_done_training_ids).to eq [training2.id].map(&:to_s)
          expect(training_report.computed_done_training_ids.count).to eq 1
          expect(training_report.computed_done_training_users_count).to eq nil
          expect(training_report.computed_all_training_users_count).to eq nil

          expect(training_report.computed_total_duration_in_secs).to eq '288000'
          expect(training_report.computed_total_cost_cents).to eq '100000'

          expect(training_report.computed_training_lines_by_employee).to eq [
            [
              ['training_name', 'Beatrix'],
              ['employees', '2'],
              ['trainings_done', '1/2'],
              ['duration_in_secs', '172800'],
              ['cost_per_employee_in_cents', '30000']
            ],
            [
              ['training_name', 'Pégase'],
              ['employees', '1'],
              ['trainings_done', '1/1'],
              ['duration_in_secs', '115200'],
              ['cost_per_employee_in_cents', '40000']
            ]
          ]
          expect(training_report.computed_training_lines_by_training).to eq []
          expect(training_report.valid?).to eq false # locked!
        end
      end
    end


  end
end
