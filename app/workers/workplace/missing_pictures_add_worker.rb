class Workplace::MissingPicturesAddWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'low'
  sidekiq_options retry: 0

  def perform(opts={})
    gatherer = Workplace::GatherMembers.new
    gatherer.add_missing_pictures if gatherer.valid?
  end
end
