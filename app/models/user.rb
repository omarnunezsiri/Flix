class User < ApplicationRecord

  before_save :to_lower_username, :to_lower_email

  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_movies, through: :favorites, source: :movie
  
  has_secure_password

  validates :name, presence: true

  validates :email, format: { with: /\S+@\S+/ },
                uniqueness: { case_sensitive: false }

  validates :username, presence: true,
                format: { with: /\A[A-Z0-9]+\z/i },
                uniqueness: { case_sensitive: false }

  def to_param
    username
  end

private
  def to_lower_username
    self.username = username.downcase
  end
  
  def to_lower_email
    self.email = email.downcase
  end
end