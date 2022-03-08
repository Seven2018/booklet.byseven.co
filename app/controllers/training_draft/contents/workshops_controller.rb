# frozen_string_literal: true

class TrainingDraft::Contents::WorkshopsController < TrainingDraft::BaseController
  def index
    render partial: 'training_draft/contents/workshops', locals: { workshops: workshops }
  end

  def create
    @training.update participant_ids: participant_ids
  end

  private

  def workshops
    # return current_user.company.users.order(lastname: :asc) if params[:search].blank?
    return Workshop.order(title: :asc) if params[:search].blank?

    # User.where(company: current_user.company).search_users(params[:search])
    Workshop.search(params[:search])
  end
end
