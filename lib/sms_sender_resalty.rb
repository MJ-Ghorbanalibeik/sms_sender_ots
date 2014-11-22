require 'message_parser'

module SmsSenderResalty
  require "net/http"
  require "uri"

  include MessageParser

  # According to documentation: http://www.resalty.net/files/RESALTY.NET_HTTP_API.pdf
  def self.send_sms(userid, password, to, sender, message)
    to = MobileNumberNormalizer.normalize_number(to)
    uri = URI.parse("http://resalty.net/api/sendSMS.php")
    message=message.encode(Encoding::UTF_8)
    url_params = {
      "userid" => userid,
      "password" => password,
      "to" => to,
      "sender" => sender,
      "msg" => message,
      "encoding" => "utf-8"
    }
    response = Net::HTTP.post_form(uri, url_params)
    # Parse response
    error_number = MessageParser.extract_number(response.body, "Error")
    if !error_number.nil?
      if error_number == 0
        return {message_id: MessageParser.extract_number(response.body, "MessageID"), code: 0}
      end
      result = case error_number 
        when 1
          {error: "General Wrong API calling", code: 1}
        when 2
          {error: "Wrong API parameter(s) for [send]", code: 2}
        when 3
          {error: "Username or password is incorrect or you don't have the permission to use this service", code: 3}
        when 4
          {error: "Sender name must not exceed 11 characters or 16 numbers", code: 4}
        when 5
          {error: "The receiver number must consist of numbers only without + or leading zeros", code: 5}
        when 6
          {error: "Sender name must be in English letters only", code: 6}
        when 7
          {error: "You cannot send to this amount at the same time, please divide this messaging to many groups", code: 7}
        when 8
          {error: "It is not allowed to use sender name you have entered, please choose another one", code: 8}
        when 9
          {error: "The message content you want to send is not allowed... If you think this is error, please contact technical support", code: 9}
        when 10
          {error: "You have not enough balance to send this message", code: 10}
      end
      raise result[:error]
      return result
    else
      result = {error: "Unexpected response: " + response.body.to_s}
      raise result[:error]
      return result
    end
  end

  def self.get_balance(userid, password)
    uri = URI.parse("http://resalty.net/api/getBalance.php")
    url_params = {
      "userid" => userid,
      "password" => password
    }
    response = Net::HTTP.post_form(uri, url_params)
    # Parse response
    if response.body.starts_with?("ERROR")
      result = case response.body[5..6]
        when "10"
          {error: "Wrong API parameter(s) for [balance], Wrong parameter", code: 10}
        when "11"
          {error: "Wrong API parameter(s) for [balance], Wrong password or username", code: 11}
      end
      raise result[:error]
      return result
    else
      return {balance: response.body.to_i, code: nil}
    end
  end

  def self.query_message(userid, password, msgid)
    uri = URI.parse("http://resalty.net/api/msgQuery.php")
    url_params = {
      "userid" => userid,
      "password" => password,
      "msgid" => msgid
    }
    response = Net::HTTP.post_form(uri, url_params)
    if response.body.starts_with?("STATUS")
      result = case response.body[6..7]
        when "01"
          {result: "The message is on the send queue", code: 1}
        when "02"
          {result: "The message has been failed", code: 2}
        when "03"
          {result: "The message has been rejected", code: 3}
        when "04"
          {result: "The message has been stopped", code: 4}
        when "05"
          {result: "The message has been sent successfully", code: 5}
      end
      return result
    elsif response.body.starts_with?("ERROR")
      result = case response.body[5..6]
        when "12"
          {error: "Wrong API parameter(s) for [balance], Wrong parameter", code: 12}
        when "13"
          {error: "Wrong API parameter(s) for [balance], Wrong Message ID", code: 13}
      end
      raise result[:error]
      return result
    else
      result = {error: "Unexpected response: " + response.body.to_s}
      raise result[:error]
      return result
    end
  end
end
