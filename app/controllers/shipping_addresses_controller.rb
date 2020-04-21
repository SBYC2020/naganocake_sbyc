class ShippingAddressesController < ApplicationController
	# before_action :authenticate_customer!

	def index
		@shipping_address = ShippingAddress.new
		#配送先情報の全権取得
		@shipping_addresses = current_customer.shipping_addresses.all
	end


	def create
		@shipping_address = ShippingAddress.new(shipping_address_params)
		@shipping_addresses = current_customer.shipping_addresses.all
		@shipping_address.customer_id = current_customer.id
		if @shipping_address.save
			redirect_to shipping_addresses_path
		else
			render :index
		end
	end



	def edit
		@shipping_address = ShippingAddress.find(params[:id])
	end

	def destroy
		@shipping_address = ShippingAddress.find(params[:id])
		@shipping_address.destroy
		redirect_to shipping_addresses_path
	end


	def update
		@shipping_address = ShippingAddress.find(params[:id])
		if @shipping_address.update(shipping_address_params)
			redirect_to shipping_addresses_path
		else
			render :edit
		end
	end



private
    def shipping_address_params
      params.require(:shipping_address).permit(:postal_code,:address,:address_name)
    end
end
