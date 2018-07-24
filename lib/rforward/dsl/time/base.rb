module Rforward
  module DSL
    module Time
      class Base
        def self.check str
          parts = str.split(' ').map { |part| part.strip }
          return parts if parts[0] == self::ACTION
          false
        end
      end
    end
  end
end
