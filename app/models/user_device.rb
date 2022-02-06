# == Schema Information
#
# Table name: user_devices
#
#  id         :integer          not null, primary key
#  push_token :text
#  is_active  :boolean          default("1")
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_user_devices_on_user_id  (user_id)
#

class UserDevice < ApplicationRecord

    ############ Associations ##############
  
    belongs_to :user
    #has_many :push_logs, dependent: :destroy
  
    ############ Validations ##############
    validates :push_token, :user_id, presence: true
  
    scope :active, -> { where('is_active IS TRUE') }
  
    def set_active
      self.is_active = true
      self.save!
    end
  
  end