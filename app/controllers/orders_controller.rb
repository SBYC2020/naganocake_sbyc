class OrdersController < ApplicationController

	def new
		@order = Order.new
		@order.customer_id = current_customer.id
		@shipping_addresses = ShippingAddress.where(customer_id: current_customer.id)
		# @total = total(current_customer) + @order.postage
	end

	def create
		session[:payment_method] = order_params[:payment_method]
		if params[:address_info] == "self_address_info"
			session[:address] = current_customer.address
			session[:postal_code] = current_customer.postal_code
			session[:name] = current_customer.surname + current_customer.name
		elsif params[:address_info] == "shipping_address_info"
			session[:address] = order_params[:address]
		end
		if session[:payment_method].present? && session[:address].present?
			redirect_to order_confirm_url
		end
	end



	# def 確認ページのアクションをここに作る
	# 	@order = Order.new(order_params)
	# 	@order.customer_id = current_customer.id

	# 	if params[:address_info] == "self_address_info"
	# 		@order.postal_code = current_customer.postal_code
	# 		@order.address = current_customer.address
	# 		@order.name = current_customer.surname + current_customer.name
	# 		@order.save
	# 		redirect_to orders_confirm_url
	# 	end
	# end

	def confirm
		@address = session[:address]
		@unko = @address.split(" ")
		session[:postal_code] = @unko[0]
		session[:address] = @unko[1]
		session[:name] = @unko[2]
	end


	private

	def order_params
		params.require(:order).permit(:payment_method, :postage,
									  :order_status, :total_payment,
									  :postal_code, :address, :name)
	end

	def total(customer)
		total_price = 0
		customer.carts.each do |c|
			total_price += c.quantity * c.product.tax_included_price
		end
		return total_price
	end


end
