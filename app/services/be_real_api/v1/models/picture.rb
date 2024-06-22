module BeRealApi
  module V1
    module Models
      class Picture
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

      class NullPicture
        def url
          'https://picsum.photos/id/433/500'
        end
      end
    end
  end
end
