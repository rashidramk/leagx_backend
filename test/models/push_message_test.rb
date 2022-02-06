# == Schema Information
#
# Table name: push_messages
#
#  id          :integer          not null, primary key
#  description :text
#  title       :text
#  status      :integer          default("0")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require "test_helper"

class PushMessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
