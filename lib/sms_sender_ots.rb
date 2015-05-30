require 'message_parser'
require 'mobile_number_normalizer'
require 'error_codes'

module SmsSenderOts
  require "net/http"

  include MessageParser
  include MobileNumberNormalizer
  include ErrorCodes

  # According to documentation: http://docs.digitalplatform.apiary.io
  def self.send_sms(appsid, to, sender, message)
    to = MobileNumberNormalizer.normalize_number(to)
    http = Net::HTTP.new('api.otsdc.com', 80)
    path = '/rest/Messages/Send'
    body = "AppSid=#{appsid}&Recipient=#{to}&Body=#{message}"
    if !sender.blank?
      body += "&SenderID=#{sender}"
    end 
    headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }
    response = http.post(path, body, headers)
    if response.code.to_i >= 200 && response.code.to_i < 300 && JSON.parse(response.body)["success"] == "true"
      return { message_id: JSON.parse(response.body)["data"]["MessageID"], code: 0 }
    else
      result = ErrorCodes.get_error_code(JSON.parse(response.body)["errorCode"])
      raise result[:error]
      return result
    end
  end

  def self.get_balance(appsid)
    http = Net::HTTP.new('api.otsdc.com', 80)
    path = '/rest/Account/GetBalance'
    body = "AppSid=#{appsid}"
    headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }
    response = http.post(path, body, headers)
    if response.code.to_i >= 200 && response.code.to_i < 300 && JSON.parse(response.body)["success"] == "true"
      return { balance: JSON.parse(response.body)["data"]["Balance"].to_i, code: nil }
    else
      result = ErrorCodes.get_error_code(JSON.parse(response.body)["errorCode"])
      raise result[:error]
      return result
    end
  end

  def self.query_message(appsid, msgid)
    http = Net::HTTP.new('api.otsdc.com', 80)
    path = '/rest/Messages/GetMessageIDStatus'
    body = "AppSid=#{appsid}&MessageID=#{msgid}"
    headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }
    response = http.post(path, body, headers)
    if response.code.to_i >= 200 && response.code.to_i < 300 && JSON.parse(response.body)["success"] == "true"
      return { result: JSON.parse(response.body)["data"]["Status"], code: 0 }
    elsif response.code.to_i >= 200 && response.code.to_i <= 300 && JSON.parse(response.body)["Status"] == "Sent"
      return { result: "Sent", code: 1 }
    else
      result = ErrorCodes.get_error_code(JSON.parse(response.body)["errorCode"])
      raise result[:error]
      return result
    end
  end
end
