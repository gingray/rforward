module Rforward
  module DSL
    module Time
      class Time
        def initialize time_string
          @time_string = time_string
        end

        def call time

        end

        def compare time
          false
        end
      end
    end
  end
end
