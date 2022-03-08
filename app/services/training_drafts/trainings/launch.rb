# frozen_string_literal: true

module TrainingDrafts
  module Trainings
    class Launch
      def self.call(**params)
        new(params).call
      end

      def initialize(training_draft:)
        @training_draft = training_draft
        @attendees = []
      end

      def call
        create_attendees

        if sessions.count == time_slots.count &&
          @attendees.count == time_slots.count * participants.count &&
          training.sessions.sum(&:cost).to_i == @training_draft.cost_per_employee
          training
        else
          [
            @attendees + sessions + [workshop, training]
          ].flatten.each(&:destroy)
          nil
        end
      end

      private

      def create_attendees
        sessions.each do |session|
          participants.each do |participant|
            @attendees <<
             Attendee.create(creator: creator, user: participant, session: session)
          end
        end
      end
      def participants
        @training_draft.participants
      end

      def creator
        @training_draft.user
      end

      def workshop
        params = @training_draft.content.slice \
          :title, :duration, :description, :content_type, :image, :cost

        Workshop.create params.merge(content_id: @training_draft.content_id)
      end

      def training
        @training ||=
          Training.create(
            @training_draft.content.slice(:title, :company_id).merge(creator: creator)
          )
      end

      def time_slots
        @training_draft.time_slots.map(&:to_h)
      end

      def cost_per_session
        @training_draft.cost_per_employee.to_f / time_slots.count
      end

      def sessions
        @sessions ||= begin
          time_slots.map do |time_slot|
            session = Session.create(
              date: time_slot['date'],
              starts_at: time_slot['starts_at'],
              ends_at: time_slot['ends_at'],
              cost: cost_per_session,
              training: training,
              workshop: workshop
              # available_date: nil
            )
          end
        end
      end

    end
  end
end
