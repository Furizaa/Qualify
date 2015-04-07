require_dependency 'pbkdf2'

class Account < ActiveRecord::Base
  validates :email, email: true
  validates_presence_of :email
  validate :validate_password
  validates_uniqueness_of :email

  before_save :ensure_password_is_hashed

  PASSWORD_MIN_LENGTH = 6

  def self.email_available?(email)
    lower = email.downcase
    Account.where(email: lower).blank?
  end

  def password=(password)
    @raw_password = password unless password.blank?
  end

  def password
    read_attribute(:password)
  end

  def email=(email)
    write_attribute(:email, email.strip.downcase) if email
  end

  def confirm_password?(password)
    return false unless password_hash && salt
    self.password_hash == hash_password(password, salt)
  end

  def self.new_from_params(params)
    account = Account.new
    account.email = params['email']
    account.password = params['password']
    return account
  end

  private

  def hash_password(password, salt)
    Pbkdf2.hash_password(password, salt, Rails.configuration.pbkdf2_iterations)
  end

  def ensure_password_is_hashed
    if @raw_password
      self.salt = SecureRandom.hex(16)
      self.password_hash = hash_password(@raw_password, salt)
    end
  end

  def validate_password
    if @raw_password && @raw_password.length < PASSWORD_MIN_LENGTH
      errors.add(:password, I18n.t(:'models.account.password.to_short', min: PASSWORD_MIN_LENGTH))
    end
  end

end
