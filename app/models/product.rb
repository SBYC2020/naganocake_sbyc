class Product < ApplicationRecord

has_many :orders_products
has_many :carts
belongs_to :genre
attachment :image

validates :product_name, presence: true
validates :product_description, presence: true
validates :genre_id, presence: true
validates :tax_included_price, presence: true
end
