# frozen_string_literal: true

class Trainings::Report::ParticipantsController < ApplicationController
  skip_after_action :verify_policy_scoped, only: :index
  skip_after_action :verify_authorized, only: :update
  def index
    render partial: 'trainings/reports/participants', locals: { participants: participants }
  end

  def update
    current_user.training_report.update participant_ids: participant_ids
    render json: {
      participant_ids_str: participant_ids.join(','),
      participant_ids_count: participant_ids.count
    }
  end

  private

  def participant_ids
    return current_user.company.users.ids if params[:participant_ids] == 'all'

    params[:participant_ids].split(',').uniq.select(&:present?)
  end


  def participants
    return current_user.company.users.order(lastname: :asc) if params[:search].blank?

    User.where(company: current_user.company).search_users(params[:search])
  end
end
