class ShippingAddress < ApplicationRecord
	belongs_to :customer

	def address_info
		self.postal_code + " " +  self.address + " " + self.address_name
	end
end
