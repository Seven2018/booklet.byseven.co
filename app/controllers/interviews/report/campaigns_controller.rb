class Interviews::Report::CampaignsController < ApplicationController
  skip_after_action :verify_policy_scoped, only: :index
  skip_after_action :verify_authorized, only: :update

  def index
    if mode == :answers && current_user.interview_report.campaign_ids.count > 1
      last_campaign_id = current_user.interview_report.campaign_ids.last
      current_user.interview_report.update campaign_ids: [last_campaign_id]
    end
    partial = mode == :answers ? 'campaigns_radio_buttons' : 'campaigns_check_boxes'
    render partial: "interviews/reports/#{partial}", locals: { campaigns: campaigns, mode: mode }
  end

  def update
    current_user.interview_report.update campaign_ids: campaign_ids

    render json: {
      campaign_ids_str: campaign_ids.join(','),
      campaign_ids_count: campaign_ids.count
    }
  end

  private

  def mode
    params[:mode].to_sym
  end

  def campaigns
    campaign_model = current_user.company.campaigns
    campaign_model = campaign_model.start_at(Date.parse(params[:date_start].to_s)) if params[:date_start]
    campaign_model = campaign_model.end_at(Date.parse(params[:date_end].to_s)) if params[:date_end]
    return campaign_model.order(created_at: :desc) if params[:search].blank?

    Campaign.where(company_id: current_user.company.id).search_campaigns(params[:search])
  end

  def campaign_ids
    return current_user.company.campaigns.ids if params[:campaign_ids] == 'all'

    params[:campaign_ids].split(',').uniq.select(&:present?)
  end
end
