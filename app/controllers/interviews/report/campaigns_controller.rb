class Interviews::Report::CampaignsController < ApplicationController
  skip_after_action :verify_policy_scoped, only: :index
  skip_after_action :verify_authorized, only: :update

  def index
    render partial: 'interviews/reports/campaigns', locals: { campaigns: campaigns }
  end

  def update
    current_user.interview_report.update campaign_ids: campaign_ids

    render json: {
      campaign_ids_str: campaign_ids.join(','),
      campaign_ids_count: campaign_ids.count
    }
  end

  private

  def campaigns
    return current_user.company.campaigns.order(created_at: :desc) if params[:search].blank?

    Campaign.where(company_id: current_user.company.id).search_campaigns(params[:search])
  end

  def campaign_ids
    return current_user.company.campaigns.ids if params[:campaign_ids] == 'all'

    params[:campaign_ids].split(',').uniq.select(&:present?)
  end
end
