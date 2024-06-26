module BeRealApi
  module V1
    module Models
      class PersonRecord
        def initialize(data)
          @raw_data = data
        end

        def id
          @raw_data['id']
        end

        def username
          @raw_data['username']
        end

        def birthdate
          date = @raw_data['birthdate']
          date.nil? ? '' : DateTime.parse(date)
        end

        def fullname
          @raw_data['fullname']
        end

        def profile_picture
          Picture.new(@raw_data['profilePicture'])
        end

        def realmojis
          @raw_data['realmojis'].map { |realmoji| Realmoji.new(realmoji) }
        end

        def devices
          @raw_data['devices'].map { |device| Device.new(device) }
        end

        def can_delete_post?
          @raw_data['canDeletePost']
        end

        def can_post?
          @raw_data['canPost']
        end

        def can_update_region?
          @raw_data['canUpdateRegion']
        end

        def phone_number
          @raw_data['phone_number']
        end

        def location
          @raw_data['location']
        end

        def country_code
          @raw_data['countryCode']
        end

        def region
          @raw_data['region']
        end

        def created_at
          date = @raw_data['createdAt']
          date.nil? ? '' : DateTime.parse(date)
        end

        def is_real_people
          @raw_data['isRealPeople']
        end

        def user_freshness
          @raw_data['userFreshness']
        end

        def streak_length
          @raw_data['streakLength']
        end

        def last_bts_post_at
          date = @raw_data['lastBtsPostAt']
          date.nil? ? '' : DateTime.parse(date)
        end

        def type
          @raw_data['type']
        end

        def links
          # TODO: Not sure what this is but it may need a sub object if used in the future
          @raw_data['links']
        end

        def custom_realmoji
          # TODO: Not sure what this is but it may need a sub object if used in the future
          @raw_data['customRealmoji']
        end
      end
    end
  end
end
