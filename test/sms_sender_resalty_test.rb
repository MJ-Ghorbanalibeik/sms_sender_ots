require 'test_helper'

class SmsSenderResaltyTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, SmsSenderResalty
  end

  test "complete_cycle" do
    balance = SmsSenderResalty.get_balance(ENV['userid'], ENV['password']).body.to_i
    result = SmsSenderResalty.send_sms(ENV['userid'], ENV['password'], ENV['mobile_number'], ENV['sender'], 'This message has been sent from automated test')
    balance2 = SmsSenderResalty.get_balance(ENV['userid'], ENV['password']).body.to_i
    assert_equal balance, balance2 + 1
    # Query message
    from = result.body.index('MessageID : ') + 12
    end_of_number = result.body.index("\n", result.body.index('MessageID : '))
    to = (end_of_number) ? (end_of_number - 1) : result.body.length
    messageId = result.body[from..to]
    query = SmsSenderResalty.query_message(ENV['userid'], ENV['password'], messageId)
    assert query.body.starts_with?('STATUS')
  end
end
