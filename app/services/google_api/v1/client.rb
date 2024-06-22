module GoogleApi
  module V1
    class Client
      API_ENDPOINT = 'https://www.googleapis.com/identitytoolkit/v3/relyingparty'.freeze
      FIREBASE_ENDPOINT = 'https://securetoken.googleapis.com/v1/token'.freeze
      API_KEY = 'AIzaSyCgNTZt6gzPMh-2voYXOvrt_UR_gpGl83Q'.freeze # Google API Key

      def get_ios_receipt
        request_body = { "appToken": BeRealApi::V1::Client::APP_TOKEN }.to_json

        response_body = post("#{API_ENDPOINT}/verifyClient", request_body)

        response_body['receipt']
      end

      def request_otp(phone_number)
        ios_receipt = get_ios_receipt

        request_body = {
          "phoneNumber": phone_number,
          "iosReceipt": ios_receipt,
        }.to_json

        response_body = post("#{API_ENDPOINT}/sendVerificationCode", request_body)

        response_body['sessionInfo']
      end

      def submit_otp(session_info, otp)
        request_body = {
          "code": otp,
          "sessionInfo": session_info,
          "operation": "SIGN_UP_OR_IN"
        }.to_json

        response_body = post("#{API_ENDPOINT}/verifyPhoneNumber", request_body, :set_otp_headers)

        response_body
      end

      def refresh_firebase(refresh_token)
        request_body = {
          "grantType": "refresh_token",
          "refreshToken": refresh_token
        }.to_json

        response_body = post(FIREBASE_ENDPOINT, request_body, :set_firebase_headers)

        response_body
      end

      def authorize_with_bereal(firebase_token)
        request_body = {
          "grant_type": "firebase",
          "client_id": "ios",
          "client_secret": BeRealApi::V1::Client::CLIENT_SECRET,
          "token": firebase_token
        }.to_json

        response_body = post(BeRealApi::V1::Client::AUTH_ENDPOINT, request_body)

        response_body
      end

      private

      def post(url, request_body, set_headers_method = :set_headers)
        uri = URI("#{url}?key=#{API_KEY}")

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Post.new(uri)

        send(set_headers_method, request)

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

      def set_otp_headers(request)
        request['Content-Type'] = 'application/json'
        request['Accept'] = '*/*'
        request['X-Client-Version'] = 'iOS/FirebaseSDK/8.15.0/FirebaseCore-iOS'
        request['X-Firebase-Client'] = 'apple-platform/ios apple-sdk/19F64 appstore/true deploy/cocoapods device/iPhone9,1 fire-abt/8.15.0 fire-analytics/8.15.0 fire-auth/8.15.0 fire-db/8.15.0 fire-dl/8.15.0 fire-fcm/8.15.0 fire-fiam/8.15.0 fire-fst/8.15.0 fire-fun/8.15.0 fire-install/8.15.0 fire-ios/8.15.0 fire-perf/8.15.0 fire-rc/8.15.0 fire-str/8.15.0 firebase-crashlytics/8.15.0 os-version/14.7.1 xcode/13F100'
        request['X-Firebase-Client-Log-Type'] = '0'
        request['X-Ios-Bundle-Identifier'] = 'AlexisBarreyat.BeReal'
        request['Accept-Language'] = 'en'
        request['User-Agent'] = 'FirebaseAuth.iOS/8.15.0 AlexisBarreyat.BeReal/0.22.4 iPhone/14.7.1 hw/iPhone9_1'
        request['X-Firebase-Locale'] = 'en'
      end

      def set_firebase_headers(request)
        request['Content-Type'] = 'application/json'
        request['Accept'] = 'application/json'
        request['User-Agent'] = 'BeReal/8586 CFNetwork/1240.0.4 Darwin/20.6.0'
        request['X-Ios-Bundle-Identifier'] = 'AlexisBarreyat.BeReal'
      end
    end
  end
end

## receipt = get_ios_receipt
# session_info = request_otp('+19196215974') <- user submits Phone Number
# otp_response = submit_otp(session_info, <otp-sent-to-phone>) <- user submits OTP they got
# refresh_response = refresh_firebase(otp_response['refreshToken'])
# authorize_response = authorize_with_bereal(refresh_response['idToken'])

# final_data = {
#   bereal_access_token: authorize_response['access_token'],
#   firebase_refresh_token: otp_response['refreshToken'],
#   firebase_id_token: refresh_response['idToken'],
#   token_type: authorize_response['token_type'],
#   expiration: Date.now() + refresh_response['expires_in'] * 1000,
#   uid: otp_response['localId'],
#   is_new_user: otp_response['isNewUser'],
# }
