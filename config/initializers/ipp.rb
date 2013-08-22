require 'oauth'

if Rails.env == "development"
  QB_KEY =  "qyprdC06VQm8watUYMKISPYZwVC4tH"
  QB_SECRET = "4a1uCsm6nBoPHcH7EEsoGepTLZmmE8kloJqmp4Xa"
else
  QB_KEY = "qyprdOhQDFbwUwTtYzvlBoYNN83HiZ"
  QB_SECRET = "p6nfDdWlkEXmI2ck4SEMaPkAmJ1XqIoxeICbyD3i"
end

$qb_oauth_consumer = OAuth::Consumer.new(QB_KEY, QB_SECRET, {
    :site                 => "https://oauth.intuit.com",
    :request_token_path   => "/oauth/v1/get_request_token",
    :authorize_url        => "https://appcenter.intuit.com/Connect/Begin",
    :access_token_path    => "/oauth/v1/get_access_token"
  })