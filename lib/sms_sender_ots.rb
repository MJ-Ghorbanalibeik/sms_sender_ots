require 'message_parser'
require 'mobile_number_normalizer'

module SmsSenderOts
  require "net/http"
  require "uri"

  include MessageParser
  include MobileNumberNormalizer

  # According to documentation: http://docs.digitalplatform.apiary.io
  def self.send_sms(userid, password, to, sender, message)
    
  end

  def self.get_balance(appsid)
    http = Net::HTTP.new('api.otsdc.com', 80)
    path = '/rest/Account/GetBalance'
    body = "AppSid=#{appsid}"
    headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }
    response = http.post(path, body, headers)
    # Parse response
    if response.code == 200 && JSON.parse(response.body)["success"] == "true"
      return { balance: JSON.parse(response.body)["data"]["Balance"].to_i, code: nil }
    else
  end

  def self.query_message(userid, password, msgid)
    
  end
end
