# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string(255)
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string(255)
#  avatar_file_name       :string(255)
#  avatar_content_type    :string(255)
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#  role                   :integer          default(0), not null
#

class User < ApplicationRecord

  has_many :captions, inverse_of: :user, :dependent => :delete_all

  validates :name,
    presence: true,
    uniqueness: {
      case_sensitive: false
    }

  validates_format_of :name, with: /^[a-zA-Z0-9_\.]*$/, multiline: true
  validate :validate_name

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  attr_accessor :login

  def login=(login)
    @login = login
  end

  def login
    @login || self.name || self.email
  end

  def validate_name
    errors.add(:name, :invalid) if User.where(email: name).exists?
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    conditions[:email].downcase! if conditions[:email]
    login = conditions.delete(:login)

    where(conditions.to_hash).where(
      ["lower(name) = :value OR lower(email) = :value", { value: login.downcase }]
    ).first
  end

  has_attached_file :avatar, styles: {
    medium: '300x300>',
    thumb: '100x100>'
  }, default_url: '/missing.jpg'

  validates_attachment_content_type :avatar, content_type: [
    'image/jpg',
    'image/jpeg',
    'image/png',
    'image/gif'
  ]

  enum role: { user: 0, admin: 1 }
end
