
module Taggable
  extend ActiveSupport::Concern

  class_methods do
    def filter_by_tag_ids(tag_ids)
      tag_ids = tag_ids.map(&:to_i)
      campaigns = joins(:categories).where(categories: {id: tag_ids})
      campaigns = campaigns.select { |campaign| ((campaign.categories.pluck(:id) & tag_ids) == tag_ids) }
      self.get_activerecord_relation(campaigns)
    end
  end
end