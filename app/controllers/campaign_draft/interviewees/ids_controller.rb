# frozen_string_literal: true

class CampaignDraft::Interviewees::IdsController < CampaignDraft::BaseController
  def update
    @campaign.update interviewee_ids: interviewee_ids
    render json: {
      interviewee_ids_str: interviewee_ids.join(','),
      interviewee_ids_count: interviewee_ids.count
    }
  end
end
