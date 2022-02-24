class CampaignDraft::TemplatesController < CampaignDraft::BaseController
  def update
    campaign_draft.update campaign_draft_params
    if all_params_persisted?
      campaign_draft.templates_set!
      redirect_to edit_campaign_draft_dates_path
    else
      flash[:alert] = "TODO problem !"
      redirect_to edit_campaign_draft_participants_path
    end
  end

  private

  def campaign_draft_params
    params.permit(:templates_selection_method, :default_template_id)
  end
end
