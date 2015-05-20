require 'test_helper'

class SmsSenderOtsTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, SmsSenderOts
  end

  test "complete_cycle" do
    balance_before = SmsSenderOts.get_balance(ENV['appsid'])
    assert_equal balance_before[:error], nil
    send_sms_result = SmsSenderOts.send_sms(ENV['appsid'], ENV['mobile_number'], ENV['sender'], 'This message has been sent from automated test')
    assert_not_equal send_sms_result[:message_id], nil
    assert_equal send_sms_result[:error], nil
    balance_after = SmsSenderOts.get_balance(ENV['appsid'])
    assert_equal balance_after[:error], nil
    #assert_equal balance_before[:balance], balance_after[:balance] + 1
    # Query message
    query_result = SmsSenderOts.query_message(ENV['appsid'], send_sms_result[:message_id])
    assert_equal query_result[:error], nil
    assert_equal query_result[:code], 0
  end
end
