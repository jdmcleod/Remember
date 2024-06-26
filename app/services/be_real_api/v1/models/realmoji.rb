module BeRealApi
  module V1
    module Models
      class Realmoji
        def initialize(data)
          @raw_data = data
        end

        def emoji
          @raw_data['emoji']
        end

        def media
          Media.new(@raw_data['media'])
        end
      end
    end
  end
end
