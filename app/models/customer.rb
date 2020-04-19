class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :orders
  has_many :shipping_addresses
  has_many :carts

  validates :surname, presence: true
  validates :name, presence: true
  validates :kana_surname, presence: true, format: { with: /\A[ァ-ヶー－]+\z/ }
  validates :kana_name, presence: true, format: { with: /\A[ァ-ヶー－]+\z/ }
  validates :postal_code, presence: true, format: { with: /\A\d{7}\z/ }
  validates :address, presence: true
  validates :phone_number, presence: true, format: { with: /\A\d{10,11}\z/ }
  VALID_EMAIL_REGIX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
			format: { with: VALID_EMAIL_REGIX }, uniqueness: { case_sensitive: false }
end
