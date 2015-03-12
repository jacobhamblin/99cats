class User < ActiveRecord::Base
  has_many(
    :cats,
    class_name: :Cat,
    foreign_key: :user_id,
    primary_key: :id
  )

  has_many(
    :cat_requests,
    class_name: :CatRentalRequest,
    foreign_key: :user_id,
    primary_key: :id
  )
  attr_reader :password

  validates :user_name, :password_digest, :session_token, presence: true
  validates :user_name, :password_digest, uniqueness: true

  before_validation :ensure_session_token

  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64
  end

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64
    self.save
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)

    return nil if user.nil?

    BCrypt::Password.new(user.password_digest).is_password?(password) ? user : nil
  end
end
