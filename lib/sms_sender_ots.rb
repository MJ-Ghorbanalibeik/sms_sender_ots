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

  def self.get_balance(userid, password)
    
  end

  def self.query_message(userid, password, msgid)
    
  end
end
