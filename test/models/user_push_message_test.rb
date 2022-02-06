# == Schema Information
#
# Table name: user_push_messages
#
#  id              :integer          not null, primary key
#  status          :integer
#  user_id         :integer
#  push_message_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require "test_helper"

class UserPushMessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
