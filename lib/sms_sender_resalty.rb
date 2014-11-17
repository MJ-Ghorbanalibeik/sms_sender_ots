module SmsSenderResalty
  require "net/http"
  require "uri"

  # According to documentation: http://www.resalty.net/files/RESALTY.NET_HTTP_API.pdf
  def self.send_sms(userid, password, to, sender, message)
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
    return response
  end

  def self.get_balance(userid, password)
    uri = URI.parse("http://resalty.net/api/getBalance.php")
    url_params = {
      "userid" => userid,
      "password" => password
    }
    response = Net::HTTP.post_form(uri, url_params)
    return response
  end

  def self.query_message(userid, password, msgid)
    uri = URI.parse("http://resalty.net/api/msgQuery.php")
    url_params = {
      "userid" => userid,
      "password" => password,
      "msgid" => msgid
    }
    response = Net::HTTP.post_form(uri, url_params)
    return response
  end
end
