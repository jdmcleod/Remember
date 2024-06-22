module GoogleApi
  module V1
    class Client
      API_ENDPOINT = 'https://www.googleapis.com/identitytoolkit/v3/relyingparty'.freeze
      API_KEY = 'AIzaSyCgNTZt6gzPMh-2voYXOvrt_UR_gpGl83Q'.freeze # Google API Key

      def get_ios_receipt
        request_body = { "appToken": BeRealApi::V1::Client::APP_TOKEN }.to_json

        response_body = post("#{API_ENDPOINT}/verifyClient", request_body)

        response_body['receipt']
      end

      def send_otp(phone_number)
        ios_receipt = get_ios_receipt

        request_body = {
          "phoneNumber": phone_number,
          "iosReceipt": ios_receipt,
        }.to_json

        response_body = post("#{API_ENDPOINT}/sendVerificationCode", request_body)

        response_body['sessionInfo']
      end

      private

      def post(url, request_body)
        uri = URI("#{url}?key=#{API_KEY}")

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Post.new(uri)

        set_headers(request)

        request.body = request_body

        response = http.request(request)

        JSON.parse(response.body)
      end

      def set_headers(request)
        request['Content-Type'] = 'application/json'
        request['Accept'] = '*/*'
        request['X-Client-Version'] = 'iOS/FirebaseSDK/9.6.0/FirebaseCore-iOS'
        request['X-Ios-Bundle-Identifier'] = 'AlexisBarreyat.BeReal'
        request['Accept-Language'] = 'en'
        request['User-Agent'] = 'FirebaseAuth.iOS/9.6.0 AlexisBarreyat.BeReal/0.31.0 iPhone/14.7.1 hw/iPhone9_1'
        request['X-Firebase-Locale'] = 'en'
        request['X-Firebase-Gmpid'] = '1:405768487586:ios:28c4df089ca92b89'
      end
    end
  end
end
