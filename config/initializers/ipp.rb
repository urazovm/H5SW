require 'oauth'

QB_KEY = "qyprdutWkaEu4IVlgcjBVUmv8k38Tc"
QB_SECRET = "u5DWQIDBcmNDyN1MCkUxmPyD2MoynOvgKlyay9mI"

$qb_oauth_consumer = OAuth::Consumer.new(QB_KEY, QB_SECRET, {
    :site                 => "https://oauth.intuit.com",
    :request_token_path   => "/oauth/v1/get_request_token",
    :authorize_url        => "https://appcenter.intuit.com/Connect/Begin",
    :access_token_path    => "/oauth/v1/get_access_token"
  })