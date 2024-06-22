module BeRealApi
  module V1
    module Models
      class Memory
        attr_reader :raw_data

        def initialize(data)
          @raw_data = data
        end

       def id
          @raw_data['id']
        end

        def is_late?
          @raw_data['isLate']
        end

        def primary
          Picture.new(@raw_data['primary'])
        end

        def secondary
          Picture.new(@raw_data['secondary'])
        end

        def thumnail
          Picture.new(@raw_data['thumnail'])
        end

        def location
          Location.new(@raw_data['location'])
        end

        def memory_day
          date = @raw_data['memoryDay']
          date.nil? ? '' : DateTime.parse(date)
        end
      end
    end
  end
end
