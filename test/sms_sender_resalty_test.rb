require 'test_helper'

class SmsSenderResaltyTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, SmsSenderResalty
  end

  test "complete_cycle" do
    balance_before = SmsSenderResalty.get_balance(ENV['userid'], ENV['password'])
    assert_equal balance_before[:error], nil
    send_sms_result = SmsSenderResalty.send_sms(ENV['userid'], ENV['password'], ENV['mobile_number'], ENV['sender'], 'This message has been sent from automated test')
    assert_not_equal send_sms_result[:message_id], nil
    assert_equal send_sms_result[:error], nil
    balance_after = SmsSenderResalty.get_balance(ENV['userid'], ENV['password'])
    assert_equal balance_after[:error], nil
    assert_equal balance_before[:balance], balance_after[:balance] + 1
    # Query message
    query_result = SmsSenderResalty.query_message(ENV['userid'], ENV['password'], send_sms_result[:message_id])
    assert_equal query_result[:error], nil
    assert_equal query_result[:code], 5
  end
end
