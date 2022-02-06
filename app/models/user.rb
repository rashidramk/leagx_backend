# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string
#  last_name              :string
#  phone                  :string
#  gender                 :string
#  address                :string
#  api_token              :string
#  role                   :string
#  dob                    :string
#  confirmation_token     :string
#  unconfirmed_email      :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  profile_img            :string
#  cover_img              :string
#  provider               :string
#  uid                    :string
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  ############ Associations ##############
  # has_one_attached :avatar
  has_many :user_devices, dependent: :destroy
  # attr_accessor :user_image

  scope :verified, -> { where('confirmed_at IS NOT NULL') }

  ############ Validations ##############

  validates :first_name, presence: true
  validates :email, presence: true, unless: -> { is_fb_user }
  validates :email, uniqueness:  true, unless: -> { is_fb_user }

  after_save :email_to_lowercase

  # validates :avatar, content_type: {in: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif'], message: 'Please upload a valid image'}
  # validates :avatar, size: { less_than: 2.megabytes , message: 'Image size should be less than 2 MB' }
  #

  def self.to_csv
    attributes = %w{id email first_name last_name dob created_at}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.find_each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end

  def pretty_name
    fullname
  end

  def fullname
    "#{first_name} #{last_name}"
  end

  def is_fb_user
    uid.present?
  end

  # Provided for Rails Admin to allow the password to be reset
  def set_password; nil; end

  def set_password=(value)
    return nil if value.blank?
    self.password = value
    self.password_confirmation = value
  end

  def admin
    self.role == "admin"
  end

  def gender_enum
    ['Male', 'Female']
  end

  def role_enum
    ['admin', 'appuser']
  end

    # Assign an API Token on create
  before_create do |user|
    user.api_token = User.generate_api_token
  end

  # Generate a unique API Token
  def self.generate_api_token
    loop do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      break token unless User.exists?(api_token: token)
    end
  end

  def update_user_api_token(create_new=false)
    self.api_token = create_new ? User.generate_api_token : nil
    self.save(:validate => false)
  end

  def setup_devices(token)
    self.de_active_devices
    device = self.user_devices.where(push_token: token).first_or_create
    device.set_active
  end

  def de_active_devices
    self.user_devices.update_all(is_active: false)
  end

  def send_push
    if self.user_devices.active.first.present?
      response = FcmPush.new.send_push_notification('','','')
      self.push_logs.new.save_log(response)
    end
  end

  def active_device
    self.user_devices.active.first
  end
  
  def self.filter_fields
    {
        email: 'Email',
        first_name: 'First Name',
        last_name: 'Last Name',
        phone: 'Phone'
    }
  end

  def self.dropdown_options
    all.map{|s| [s.fullname, s.id]}
  end

  def user_age
    begin
      self.dob.present? ? (Date.today - Date.parse(self.dob)).to_i/365 : nil
    rescue
      return nil
    end
  end

  def self.get_age(date)
    begin
      date.present? ? (Date.today - Date.parse(date)).to_i/365 : nil
    rescue
      return nil
    end
  end

  def is_confirmed
    confirmed_at.present?
  end

  def email_to_lowercase
    self.update_column(:email, self.email.downcase)
  end

  def attributes
    {
      id:             self.id,
      email:          self.email,
      first_name:     self.first_name,
      last_name:      self.last_name,
      created_at:     self.created_at,
      updated_at:     self.updated_at,
      phone:          self.phone,
      gender:         self.gender,
      address:        self.address,
      # api_token:      self.api_token,
      # profile_img:    self.profile_img,
      # cover_img:      self.cover_img,
      dob:            self.dob
    }
  end


end
