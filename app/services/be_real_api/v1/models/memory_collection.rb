module BeRealApi
  module V1
    module Models
      class MemoryCollection
        def initialize(data)
          @raw_data = data
        end

        def memories
          @raw_data['data'].map { |memory| Memory.new(memory) }
        end

        def next
          @raw_data['next']
        end

        def memories_syncronized?
          @raw_data['memoriesSyncronized']
        end

        def for_date(date=DateTime.current)
          memories.find { |memory| memory.memory_day.to_date == date }
        end
      end
    end
  end
end
