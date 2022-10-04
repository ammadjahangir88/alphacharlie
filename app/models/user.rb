class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, authentication_keys: [:login]
  # validates :username, presence: true, uniqueness: { case_sensitive: false }
  # # app/models/user.rb
  has_many :articles
  has_many :groups
  validate :validate_username
  has_many :user_groups,  dependent: :destroy
  has_many :groups, through: :user_groups
  has_many :comments , dependent: :destroy
  has_one_attached :image
  def validate_username
    if User.where(email: user_name).exists?
      errors.add(:user_name, :invalid)
    end
  end

  attr_writer :login

  def login
    @login || self.user_name || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where(["lower(user_name) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end
end
