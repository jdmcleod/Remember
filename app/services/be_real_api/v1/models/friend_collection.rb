module BeRealApi
  module V1
    module Models
      class FriendCollection
        def initialize(data)
          @raw_data = data
        end

        def friends
          @raw_data['data'].map { |friend| Friend.new(friend) }
        end

        def next
          @raw_data['next']
        end

        def total
          @raw_data['total']
        end
      end
    end
  end
end
