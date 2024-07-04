module BeRealApi
  module V1
    module Models
      class Friend
        def initialize(data)
          @raw_data = data
        end

        def id
          @raw_data['id']
        end

        def status
          @raw_data['status']
        end

        def fullname
          @raw_data['fullname']
        end

        def username
          @raw_data['username']
        end

        def profile_picture
          data = @raw_data['profilePicture']

          return NullPicture.new if data.nil?

          Picture.new(data)
        end
      end
    end
  end
end
