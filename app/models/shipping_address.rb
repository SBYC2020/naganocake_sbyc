class ShippingAddress < ApplicationRecord
belongs_to :customer

validates :postal_code, presence: true, format: { with: /\A\d{7}\z/ }
validates :address, presence: true
validates :address_name, presence: true
end
