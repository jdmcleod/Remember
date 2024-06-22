module BeRealApi
  module V1
    class PersonRecord
      def initialize(data)
        @raw_data = data
      end

      def username
        @raw_data['username']
      end

      def fullname
        @raw_data['fullname']
      end

      def profile_picture
        @profile_picture ||= ProfilePicture.new(@raw_data['profilePicture'])
      end
    end
  end
end

# {"id"=>"PWMe2UfsoVaPm1Plhax2MWTEUQa2",
#    "username"=>"jeremywalton",
#    "birthdate"=>"1995-11-04T00:00:00.000Z",
#    "fullname"=>"Jeremy Walton",
#    "profilePicture"=>
#     {"url"=>
#       "https://cdn.bereal.network/Photos/PWMe2UfsoVaPm1Plhax2MWTEUQa2/profile/PWMe2UfsoVaPm1Plhax2MWTEUQa2-1658534719-pro  file-picture.jpg",
#      "width"=>500,
#      "height"=>500},
#    "realmojis"=>
#     [{"emoji"=>"😍",
#       "media"=>
#        {"url"=>
#          "https://cdn.bereal.network/Photos/PWMe2UfsoVaPm1Plhax2MWTEUQa2/realmoji/PWMe2UfsoVaPm1Plhax2MWTEUQa2-realmoji-h  eartEyes-1660512340.jpg",
#         "width"=>500,
#         "height"=>500}},
#      {"emoji"=>"😂",
#       "media"=>
#        {"url"=>
#          "https://cdn.bereal.network/Photos/PWMe2UfsoVaPm1Plhax2MWTEUQa2/realmoji/PWMe2UfsoVaPm1Plhax2MWTEUQa2-realmoji-l  aughing-1660512362.jpg",
#         "width"=>500,
#         "height"=>500}},
#      {"emoji"=>"😃",
#       "media"=>
#        {"url"=>
#          "https://cdn.bereal.network/Photos/PWMe2UfsoVaPm1Plhax2MWTEUQa2/realmoji/PWMe2UfsoVaPm1Plhax2MWTEUQa2-realmoji-h  appy-1660512303.jpg",
#         "width"=>500,
#         "height"=>500}},
#      {"emoji"=>"😖",
#       "media"=>
#        {"url"=>
#          "https://cdn.bereal.network/Photos/PWMe2UfsoVaPm1Plhax2MWTEUQa2/realmoji/PWMe2UfsoVaPm1Plhax2MWTEUQa2-realmoji-c  onfounded-1653441236.jpg",
#         "width"=>500,
#         "height"=>500}},
#      {"emoji"=>"😐",
#       "media"=>
#        {"url"=>
#          "https://cdn.bereal.network/Photos/PWMe2UfsoVaPm1Plhax2MWTEUQa2/realmoji/PWMe2UfsoVaPm1Plhax2MWTEUQa2-realmoji-n  eutral-1653440864.jpg",
#         "width"=>500,
#         "height"=>500}},
#  ESCOD
#    "username"=>"jeremywalton",
#    "birthdate"=>"1995-11-04T00:00:00.000Z",
#    "fullname"=>"Jeremy Walton",
#    "profilePicture"=>
#     {"url"=>
#       "https://cdn.bereal.network/Photos/PWMe2UfsoVaPm1Plhax2MWTEUQa2/profile/PWMe2UfsoVaPm1Plhax2MWTEUQa2-1658534719-pro  file-picture.jpg",
#      "width"=>500,
#      "height"=>500},
#    "realmojis"=>
#     [{"emoji"=>"😍",
#       "media"=>
#        {"url"=>
#          "https://cdn.bereal.network/Photos/PWMe2UfsoVaPm1Plhax2MWTEUQa2/realmoji/PWMe2UfsoVaPm1Plhax2MWTEUQa2-realmoji-h  eartEyes-1660512340.jpg",
#         "width"=>500,
#         "height"=>500}},
#      {"emoji"=>"😂",
#       "media"=>
#        {"url"=>
#          "https://cdn.bereal.network/Photos/PWMe2UfsoVaPm1Plhax2MWTEUQa2/realmoji/PWMe2UfsoVaPm1Plhax2MWTEUQa2-realmoji-l  aughing-1660512362.jpg",
#         "width"=>500,
#         "height"=>500}},
#      {"emoji"=>"😃",
#       "media"=>
#        {"url"=>
#          "https://cdn.bereal.network/Photos/PWMe2UfsoVaPm1Plhax2MWTEUQa2/realmoji/PWMe2UfsoVaPm1Plhax2MWTEUQa2-realmoji-h  appy-1660512303.jpg",
#         "width"=>500,
#         "height"=>500}},
#      {"emoji"=>"😖",
#       "media"=>
#        {"url"=>
#          "https://cdn.bereal.network/Photos/PWMe2UfsoVaPm1Plhax2MWTEUQa2/realmoji/PWMe2UfsoVaPm1Plhax2MWTEUQa2-realmoji-c  onfounded-1653441236.jpg",
#         "width"=>500,
#         "height"=>500}},
#      {"emoji"=>"😐",
#       "media"=>
#        {"url"=>
#          "https://cdn.bereal.network/Photos/PWMe2UfsoVaPm1Plhax2MWTEUQa2/realmoji/PWMe2UfsoVaPm1Plhax2MWTEUQa2-realmoji-n  eutral-1653440864.jpg",
#         "width"=>500,
#         "height"=>500}},
#      {"emoji"=>"👍",
#       "media"=>
#        {"url"=>
#          "https://cdn.bereal.network/Photos/PWMe2UfsoVaPm1Plhax2MWTEUQa2/realmoji/PWMe2UfsoVaPm1Plhax2MWTEUQa2-realmoji-u  p-1660512264.jpg",
#         "width"=>500,
#         "height"=>500}},
#      {"emoji"=>"😲",
#       "media"=>
#        {"url"=>
#          "https://cdn.bereal.network/Photos/PWMe2UfsoVaPm1Plhax2MWTEUQa2/realmoji/PWMe2UfsoVaPm1Plhax2MWTEUQa2-realmoji-s  urprised-1660512289.jpg",
#         "width"=>500,
#         "height"=>500}}],
#    "devices"=>
#     [{"clientVersion"=>"2.15.0",
#       "device"=>"iPhone13,3 17.5.1",
#       "deviceId"=>"85889B05-8CD8-4472-B767-8C2AF4944F4F",
#       "platform"=>"ios",
#       "language"=>"en",
#       "timezone"=>"America/New_York"}],
#    "canDeletePost"=>true,
#    "canPost"=>true,
#    "canUpdateRegion"=>true,
#    "phoneNumber"=>"+19196215974",
#    "location"=>"Fuquay-Varina",
#    "countryCode"=>"US",
#    "region"=>"us-central",
#    "createdAt"=>"2022-05-22T17:53:00.500Z",
#    "isRealPeople"=>false,
#    "userFreshness"=>"returning",
#    "streakLength"=>1,
#    "lastBtsPostAt"=>"2024-06-22T17:34:04.563Z",
#    "type"=>"USER",
#    "links"=>[],
#    "customRealmoji"=>""}
#  ESCOC





#   x2MWTEUQa2/realmoji/PWMe2UfsoVaPm1Plhax2MWTEUQa2-realmoji-neutral-1653440864.jpg",





#   x2MWTEUQa2/realmoji/PWMe2UfsoVaPm1Plhax2MWTEUQa2-realmoji-up-1660512264.jpg",





#   x2MWTEUQa2/realmoji/PWMe2UfsoVaPm1Plhax2MWTEUQa2-realmoji-surprised-1660512289.jpg",
























# ~
# ~
# ~
#  ESCOD
#         "width"=>500,
#         "height"=>500}},
#      {"emoji"=>"😐",
#       "media"=>
#        {"url"=>
#          "https://cdn.bereal.network/Photos/PWMe2UfsoVaPm1Plhax2MWTEUQa2/realmoji/PWMe2UfsoVaPm1Plhax2MWTEUQa2-realmoji-n  eutral-1653440864.jpg",
#         "width"=>500,
#         "height"=>500}},
#      {"emoji"=>"👍",
#       "media"=>
#        {"url"=>
#          "https://cdn.bereal.network/Photos/PWMe2UfsoVaPm1Plhax2MWTEUQa2/realmoji/PWMe2UfsoVaPm1Plhax2MWTEUQa2-realmoji-u  p-1660512264.jpg",
#         "width"=>500,
#         "height"=>500}},
#      {"emoji"=>"😲",
#       "media"=>
#        {"url"=>
#          "https://cdn.bereal.network/Photos/PWMe2UfsoVaPm1Plhax2MWTEUQa2/realmoji/PWMe2UfsoVaPm1Plhax2MWTEUQa2-realmoji-s  urprised-1660512289.jpg",
#         "width"=>500,
#         "height"=>500}}],
#    "devices"=>
#     [{"clientVersion"=>"2.15.0",
#       "device"=>"iPhone13,3 17.5.1",
#       "deviceId"=>"85889B05-8CD8-4472-B767-8C2AF4944F4F",
#       "platform"=>"ios",
#       "language"=>"en",
#       "timezone"=>"America/New_York"}],
#    "canDeletePost"=>true,
#    "canPost"=>true,
#    "canUpdateRegion"=>true,
#    "phoneNumber"=>"+19196215974",
#    "location"=>"Fuquay-Varina",
#    "countryCode"=>"US",
#    "region"=>"us-central",
#    "createdAt"=>"2022-05-22T17:53:00.500Z",
#    "isRealPeople"=>false,
#    "userFreshness"=>"returning",
#    "streakLength"=>1,
#    "lastBtsPostAt"=>"2024-06-22T17:34:04.563Z",
#    "type"=>"USER",
#    "links"=>[],
#    "customRealmoji"=>""}
