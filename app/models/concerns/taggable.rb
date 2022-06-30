
module Taggable
  extend ActiveSupport::Concern

  class_methods do
    def filter_by_tag_ids(tag_ids)
      tag_ids = tag_ids.map(&:to_i)
      instances = self

      tag_ids.each do |tag_id|
        instances = instances.where_exists(:categories, id: tag_id)
      end

      instances
    end
  end
end
