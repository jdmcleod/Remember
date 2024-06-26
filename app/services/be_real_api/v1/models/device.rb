module BeRealApi
  module V1
    module Models
      class Device
        def initialize(data)
          @raw_data = data
        end

        def device
          @raw_data['device']
        end

        def client_version
          @raw_data['clientVersion']
        end

        def device_id
          @raw_data['deviceId']
        end

        def platform
          @raw_data['platform']
        end

        def language
          @raw_data['language']
        end

        def timezone
          @raw_data['timezone']
        end
      end
    end
  end
end
