class Product < ApplicationRecord

has_many :orders_products
has_many :carts
belongs_to :genre
end
