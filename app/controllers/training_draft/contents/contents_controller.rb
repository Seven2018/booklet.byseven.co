# frozen_string_literal: true

class TrainingDraft::Contents::ContentsController < TrainingDraft::BaseController
  def index
    render partial: 'training_draft/contents/contents', locals: { contents: contents }
  end

  private

  def contents
    return Content.order(title: :asc) if params[:search].blank?

    Content.search(params[:search])
  end
end
