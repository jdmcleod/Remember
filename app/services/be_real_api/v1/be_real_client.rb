# Based on https://github.com/s-alad/toofake

module BeRealApi
  module V1
    class BeRealClient
      API_ENDPOINT = 'https://mobile-l7.bereal.com/api'.freeze
      AUTH_ENDPOINT = 'https://auth.bereal.team/token?grant_type=firebase'.freeze
      APP_TOKEN = '54F80A258C35A916B38A3AD83CA5DDD48A44BFE2461F90831E0F97EBA4BB2EC7'.freeze
      CLIENT_SECRET = '962D357B-B134-4AB6-8F53-BEA2B7255420'.freeze
      DEVICE_ID = '820B5AA5-0FDE-4199-93C8-64B12D08D5EE'.freeze

      def initialize(be_real_connection)
        @be_real_connection = be_real_connection
      end

      def person_record
        get("#{API_ENDPOINT}/person/me")
      end

      def friends
        get("#{API_ENDPOINT}/relationships/friends")
      end

      def memories
        get("#{API_ENDPOINT}/feeds/memories")
      end

      private

      def get(url, set_headers_method = :set_headers)
        if (@be_real_connection.firebase_expired?)
          connection_refreshed = @be_real_connection.refresh_connection
          return unless connection_refreshed
        end

        uri = URI(url)

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(uri)

        send(set_headers_method, request)

        response = http.request(request)

        JSON.parse(response.body)
      end

      def set_headers(request)
        request['Authorization'] = "Bearer #{@be_real_connection.bereal_access_token}"

        Headers.get.each do |header|
          request[header.first] = header.last
        end
      end
    end
  end
end
