# frozen_string_literal: true

class TrainingDraft::Participants::UsersController < TrainingDraft::BaseController
  def index
    render partial: 'training_draft/participants/users', locals: { users: users }
  end

  def create
    @training.update participant_ids: participant_ids
  end

  private

  def users
    return current_user.company.users.order(lastname: :asc) if params[:search].blank?

    User.where(company: current_user.company).search_users(params[:search])
  end
end
