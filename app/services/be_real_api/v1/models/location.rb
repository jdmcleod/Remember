module BeRealApi
  module V1
    module Models
      class Location
        def initialize(data)
          @raw_data = data
        end

        def latitude
          @raw_data['latitude']
        end

        def longitude
          @raw_data['longitude']
        end
      end
    end
  end
end
