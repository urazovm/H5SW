require 'oauth'

if Rails.env == "development"
  QB_KEY = "qyprdOhQDFbwUwTtYzvlBoYNN83HiZ"
  QB_SECRET = "p6nfDdWlkEXmI2ck4SEMaPkAmJ1XqIoxeICbyD3i"
else
  
end

$qb_oauth_consumer = OAuth::Consumer.new(QB_KEY, QB_SECRET, {
    :site                 => "https://oauth.intuit.com",
    :request_token_path   => "/oauth/v1/get_request_token",
    :authorize_url        => "https://appcenter.intuit.com/Connect/Begin",
    :access_token_path    => "/oauth/v1/get_access_token"
  })