# frozen_string_literal: true

class TrainingDraft::Contents::ContentsController < TrainingDraft::BaseController
  def index
    render partial: 'training_draft/contents/contents', locals: { contents: contents }
  end

  private

  def contents
    # return current_user.company.users.order(lastname: :asc) if params[:search].blank?
    return Content.order(title: :asc) if params[:search].blank?

    # User.where(company: current_user.company).search_users(params[:search])
    Content.search(params[:search])
  end
end
