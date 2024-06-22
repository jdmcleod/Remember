module BeRealApi
  module V1
    module Models
      class ProfilePicture
        def initialize(data)
          @raw_data = data
        end

        def url
          @raw_data['url']
        end

        def width
          @raw_data['width']
        end

        def height
          @raw_data['height']
        end
      end
    end
  end
end
