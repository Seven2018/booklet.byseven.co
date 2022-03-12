# frozen_string_literal: true

class Trainings::Report::TrainingsController < ApplicationController
  skip_after_action :verify_policy_scoped, only: :index
  skip_after_action :verify_authorized, only: :update
  def index
    render partial: 'trainings/reports/trainings', locals: { trainings: trainings }
  end

  def update
    current_user.training_report.update training_ids: training_ids
    render json: {
      participant_ids_str: training_ids.join(','),
      participant_ids_count: training_ids.count
    }
  end

  private

  def training_ids
    return current_user.company.trainings.ids if params[:participant_ids] == 'all'

    params[:participant_ids].split(',').uniq.select(&:present?)
  end


  def trainings
    return current_user.company.trainings.order(created_at: :desc) if params[:search].blank?

    Training.where(company: current_user.company).search_trainings(params[:search])
  end
end
