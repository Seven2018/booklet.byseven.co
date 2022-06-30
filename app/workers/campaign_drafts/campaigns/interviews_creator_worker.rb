class CampaignDrafts::Campaigns::InterviewsCreatorWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'campaign_generator'

  def perform(opts={})
    creator = CampaignDrafts::Campaigns::InterviewsCreator.new(opts)
    creator.create if creator.valid?
  end
end
