module Rforward
  module Uploaders
    class Elastic < Base
      attr_accessor :client

      def initialize
        @client = Config.resolve Config::ELASTIC_CLIENT
        @buffer = []
        @batch_size = Config.instance['elastic']['batch_size'].to_i
        @default_index_name = Config.instance['elastic']['index_name']
      end

      def call line
        Stat.instance.total += 1
        json = JSON.parse line
        index_name = index_name json
        @buffer << { index: { _index: index_name, _type: 'doc' } }
        @buffer << json
        if @buffer.size >= @batch_size
          @client.bulk body: @buffer
          @buffer = []
        end
        Stat.instance.success += 1
        Stat.instance.flush_counter += 1
        true
      rescue Exception => e
        Stat.instance.failed += 1
        RLogger.instance.error "(#{e.message}) (line: #{line})"
        false
      end

      def after_finish
        if @buffer.size > 0
          @client.bulk body: @buffer
          @buffer = []
        end
      end

      def index_name record
        return "#{@deafault_index_name}#{Time.now.strftime('%Y-%m')}" unless record[Config.instance['time_key']]
        time = Time.strptime record[Config.instance['time_key']], Config.instance['time_format']
        "#{@deafault_index_name}#{time.strftime('%Y-%m')}"
      end
    end
  end
end


