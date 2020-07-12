class User < ApplicationRecord
  has_and_belongs_to_many :user_roles

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable

  accepts_nested_attributes_for :user_roles

  validates :username, presence: true, uniqueness: { case_sensitive: false }
    validate :validate_username
    attr_writer :login

  def roles
    user_roles.pluck(:role)
  end

  def login
    @login || username || email
  end

  def validate_username
    errors.add(:username, :invalid) if User.where(username: username).exists?
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(['lower(username) = :value OR lower(email) = :value', { value: login.downcase }]).first
    elsif conditions.key?(:username) || conditions.key?(:email)
      where(conditions.to_h).first
    end
  end

end
