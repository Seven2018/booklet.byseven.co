# frozen_string_literal: true

module TrainingReports
  class GenerateData
    def self.call(**params)
      new(params).call
    end

    def initialize(training_report:)
      @training_report = training_report
    end

    def call
      @training_report.started!
      @training_report.update data: data
      # return @training_report.failed! if condition (if applicable)
      @training_report.done!
    end

    def data
      return by_training_data if @training_report.by_training_mode?

      return by_employee_data if @training_report.by_employee_mode?

      raise StandardError, 'Unknown trainingReport mode'
    end

    def by_training_data
      sessions = Session.where(training_id: @training_report.training_ids).where(
       'date BETWEEN ? AND ?',
       @training_report.start_time.beginning_of_day,
       @training_report.end_time.end_of_day,
      )
      trainings = Training.where(id: sessions.distinct.pluck(:training_id))
      done_trainings = trainings.select(&:done?)
      attendees = Attendee.where(session_id: sessions.ids)
      users = User.where(id: attendees.distinct.pluck(:user_id))
      total_duration_secs = attendees.sum{|attendee| attendee.session.duration}.to_i
      total_cost_cents = (attendees.sum{|attendee| attendee.session.cost} * 100).to_i

      all_training_users = []
      all_done_training_users = []
      computed_training_lines_by_training = trainings.map do |training|
        training_sessions = Session.where(training: training).where(
         'date BETWEEN ? AND ?',
         @training_report.start_time.beginning_of_day,
         @training_report.end_time.end_of_day,
        )

        training_users_grouped_by_user_id = Attendee.where(
          session_id: training_sessions.ids
        ).group_by(&:user_id)
        training_users = []
        done_training_users = []
        user_attendees_durations_secs = []
        user_attendees_cost_cents = []
        training_users_grouped_by_user_id.each do |user_id, user_attendees|
          user = User.find user_id
          training_users << user
          all_training_users << user
          done_training_users << user if training.done_for?(user.id)
          all_done_training_users << user if training.done_for?(user.id)
          user_attendees_durations_secs << user_attendees.sum{|attendee| attendee.session.duration}.to_i
          user_attendees_cost_cents << user_attendees.sum{|attendee| attendee.session.cost} * 100
        end
        {
         training_name: training.title,
         employees: training_users.count,
         trained_employees: "#{done_training_users.count}/#{training_users.count}", #
         duration_in_secs: user_attendees_durations_secs.sum,
         cost_per_employee_in_cents: average(user_attendees_cost_cents).to_i,
        }.to_a
      end

      @training_report.data.merge({
        computed_participant_ids: users.ids,
        computed_training_ids: trainings.ids,
        computed_done_training_ids: done_trainings.map(&:id),
        computed_total_duration_in_secs: total_duration_secs,
        computed_total_cost_cents: total_cost_cents,
        computed_training_lines_by_training: computed_training_lines_by_training,
        computed_done_training_users_count: all_done_training_users.flatten.count,
        computed_all_training_users_count: all_training_users.flatten.count
      })
    end

    def by_employee_data
      sessions = Session.where(
        'date BETWEEN ? AND ?',
        @training_report.start_time.beginning_of_day,
        @training_report.end_time.end_of_day
      )
      users = User.where(id: @training_report.participant_ids)
      attendees = Attendee.where(session_id: sessions.ids, user_id: users.ids)
      trainings = Training.where(id: sessions.distinct.pluck(:training_id))
      done_trainings = trainings.select(&:done?)
      total_duration_secs = attendees.sum{|attendee| attendee.session.duration}.to_i
      total_cost_cents = (attendees.sum{|attendee| attendee.session.cost} * 100).to_i

      all_training_users = []
      computed_training_lines_by_employee = trainings.map do |training|
        training_sessions = Session.where(training: training).where(
          'date BETWEEN ? AND ?',
          @training_report.start_time.beginning_of_day,
          @training_report.end_time.end_of_day,
        )
        training_users_grouped_by_user_id = Attendee.where(
          session_id: training_sessions.ids,
          user_id: @training_report.participant_ids.map(&:to_i)
        ).group_by(&:user_id)
        training_users = []
        done_training_users = []
        user_attendees_durations_secs = []
        user_attendees_cost_cents = []
        training_users_grouped_by_user_id.each do |user_id, user_attendees|
          user = User.find user_id
          training_users << user
          all_training_users << user
          done_training_users << user if training.done_for?(user.id)
          user_attendees_durations_secs << user_attendees.sum{|attendee| attendee.session.duration}.to_i
          user_attendees_cost_cents << user_attendees.sum{|attendee| attendee.session.cost} * 100
        end
        {
          training_name: training.title,
          employees: training_users.count,
          trainings_done: "#{done_training_users.count}/#{training_users.count}",
          duration_in_secs: user_attendees_durations_secs.sum,
          cost_per_employee_in_cents: average(user_attendees_cost_cents).to_i,
        }.to_a
      end

      @training_report.data.merge({
        computed_participant_ids: all_training_users.flatten.map(&:id).uniq,
        computed_training_ids: trainings.ids,
        computed_done_training_ids: done_trainings.map(&:id),
        computed_total_duration_in_secs: total_duration_secs,
        computed_total_cost_cents: total_cost_cents,
        computed_training_lines_by_employee: computed_training_lines_by_employee
      })
    end

    def average(array)
      return 0 if array.blank?

      array.sum(0.0) / array.size
    end

    def company
      @company ||= @training_report.creator.company
    end
  end
end
