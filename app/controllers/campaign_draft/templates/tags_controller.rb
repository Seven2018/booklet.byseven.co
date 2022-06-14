# frozen_string_literal: true

class CampaignDraft::Templates::TagsController < CampaignDraft::BaseController
  def index
    render partial: 'campaign_draft/templates/tags', locals: { tags: tags }
  end

  private

  def tags
    Tag.where(company: current_user.company, tag_category_id: params[:search])
       .order(tag_name: :asc)
       .select(:id, :tag_name)
  end
end
