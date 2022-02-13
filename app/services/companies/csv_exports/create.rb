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
        5.times do
          puts "sleeping"
          sleep 1
        end
        @csv_export.update data: data
        # return @csv_export.failed! if condition (if applicable)
        @csv_export.done!
      end

      def data
        # TODO generate csv
        [
          ['Header1', 'Header2', 'Header3'],
          ['Row1-1', 'Row1-2', 'Row1-3'],
          ['Row2-1', 'Row2-2', 'Row2-3']
        ]
      end
    end
  end
end
