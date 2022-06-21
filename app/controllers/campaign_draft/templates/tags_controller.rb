# frozen_string_literal: true

class CampaignDraft::Templates::TagsController < CampaignDraft::BaseController
  def index
    render partial: 'campaign_draft/templates/tags', locals: { tags: tags }
  end

  private

  def tags
    users_ids = CampaignDraft.find(params[:campaign_draft_id]).interviewee_ids

    Tag.where(company: current_user.company, tag_category_id: params[:search])
       .where_exists(:user_tags, user_id: users_ids)
       .order(tag_name: :asc)
       .select(:id, :tag_name)
  end
end
