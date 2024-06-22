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
      end
    end
  end
end
