# frozen_string_literal: true

class CampaignDraft::Interviewees::IdsController < CampaignDraft::BaseController
  def update
    @campaign.update interviewee_ids: interviewee_ids
    render json: {
      participant_ids_str: interviewee_ids.join(','),
      participant_ids_count: interviewee_ids.count
    }
  end
end
