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

class PushMessage < ApplicationRecord
     ############ Associations ##############
  has_many :user_push_messages, dependent: :destroy
  has_many :users, through: :user_push_messages

  ############ Validations ##############

  validates :description, presence: true

  # after_create :send_push_to_users

  def send_push_to_users
    # users= self.users.joins(:user_devices).uniq
    # devices = []
    # users.each do |u|
    #   devices.push(u.active_device.push_token) if u.active_device.present?
    # end
    p "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    p "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++Push Notification+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    p "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    devices = UserDevice.active.pluck(:push_token)
    title = self.title
    body = self.description
    if devices.present?
      p devices
      FcmPush.new.send_push_notification(title, body, devices)
    end
  end
end
