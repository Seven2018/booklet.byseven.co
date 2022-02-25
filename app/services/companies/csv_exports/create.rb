module Companies
  module CsvExports
    class Create
      def self.call(**params)
        new(params).call
      end

      def initialize(csv_export:)
        @csv_export = csv_export
      end

      def call
        @csv_export.started!
        @csv_export.update data: data
        # return @csv_export.failed! if condition (if applicable)
        @csv_export.done!
      end

      def data
        return campaigns.to_csv_analytics(company.id, @csv_export.tag_category.id) if @csv_export.classic_mode?

        return campaigns.to_csv_data(company.id) if @csv_export.data_mode?

        raise StandardError, 'Unknown CsvExport mode'
      end

      def company
        @company ||= @csv_export.creator.company
      end

      def campaigns
        @campaigns ||=
          company.campaigns.where_exists(
            :interviews,
            'date >= ? AND date <= ?',
            @csv_export.start_time,
            @csv_export.end_time
          )
      end
    end
  end
end
