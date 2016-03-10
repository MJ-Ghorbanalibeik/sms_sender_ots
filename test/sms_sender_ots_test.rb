# encoding: utf-8
require 'test_helper'

class SmsSenderOtsTest < ActiveSupport::TestCase
  test_messages = [
    SmsSenderOts::MobileNumberNormalizer.normalize_message('This message has been sent from automated test 😎'),
    SmsSenderOts::MobileNumberNormalizer.normalize_message('این پیام از آزمون خودکار فرستاده شده است 😎')
  ]
  # Config webmock for sending messages 
  test_messages.each do |m|
    request_body_header = {:body => {'AppSid' => ENV['appsid'], 'Recipient' => SmsSenderOts::MobileNumberNormalizer.normalize_number(ENV['mobile_number']), 'Body' => m}, :headers => {'Content-Type'=>'application/x-www-form-urlencoded'}}
    request_body_header[:body]['SenderID'] = ENV['sender'] if !ENV['sender'].blank?
    WebMock::API.stub_request(:post, 'api.unifonic.com/rest/Messages/Send').
      with(request_body_header).
      to_return(:status => 200, 
        :body => "{\"data\":{\"MessageID\":\"6542\",\"Status\":\"Sent\",\"NumberOfUnits\":\"2\",\"Cost\":0.4,\"Balance\":\"100\",\"Recipient\":\"#{ENV['mobile_number']}\",\"DateCreated\":\"2014-07-22\"}}", 
        :headers => {'Content-Type' => 'application/json'})
  end
  # Config webmock for query balance 
  WebMock::API.stub_request(:post, 'api.unifonic.com/rest/Account/GetBalance').
    with(:body => {'AppSid' => ENV['appsid']},
      :headers => {'Content-Type'=>'application/x-www-form-urlencoded'}).
    to_return(:status => 200, 
      :body => "{\"success\":\"true\",\"message\":\"\",\"errorCode\":\"ER-00\",\"data\":{\"Balance\":\"48.03200\",\"CurrencyCode\":\"USD\",\"SharedBalance\":\"0.00000\"}}", 
      :headers => {'Content-Type' => 'application/json'})
  # Config webmock for query message
  WebMock::API.stub_request(:post, 'api.unifonic.com/rest/Messages/GetMessageIDStatus').
    with(:body => {'AppSid' => ENV['appsid'], 'MessageID' => '6542'},
      :headers => {'Content-Type'=>'application/x-www-form-urlencoded'}).
    to_return(:status => 200, 
      :body => "{\"success\":\"true\",\"message\":\"\",\"errorCode\":\"ER-00\",\"data\":{\"Status\":\"Sent\",\"DLR\":\"Delivered\"}}", 
      :headers => {'Content-Type' => 'application/json'})

  test "complete_cycle" do
    balance_before = SmsSenderOts.get_balance({password: ENV['appsid']})
    assert_equal balance_before[:error], nil
    test_messages.each do |m|
      send_sms_result = SmsSenderOts.send_sms({password: ENV['appsid']}, ENV['mobile_number'], m, ENV['sender'])
      assert_not_equal send_sms_result[:message_id], nil
      assert_equal send_sms_result[:error], nil
      query_result = SmsSenderOts.query_message({password: ENV['appsid']}, send_sms_result[:message_id])
      assert_equal query_result[:error], nil
      assert_equal query_result[:code], 0
    end
    balance_after = SmsSenderOts.get_balance({password: ENV['appsid']})
    assert_equal balance_after[:error], nil
  end
end
