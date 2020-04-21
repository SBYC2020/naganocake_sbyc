class OrdersController < ApplicationController
    # before_action :authenticate_customer!

	def index
		@orders = current_customer.orders.all
	end
	def show
		@order = Order.find(params[:id])
	end

	def new
		@order = Order.new
		@order.customer_id = current_customer.id
		@shipping_addresses = ShippingAddress.where(customer_id: current_customer.id)
	end

#とりあえず注文情報入力画面では注文を確定させないでsessionにデータを持たせておく
	def create
		session[:payment_method] = order_params[:payment_method]
		if params[:address_info] == "self_address_info"
			session[:address] = current_customer.address
			session[:postal_code] = current_customer.postal_code
			session[:name] = current_customer.surname + current_customer.name
		elsif params[:address_info] == "shipping_address_info"
			address = params[:address]
			info_array = address.split(" ")
			session[:postal_code] = info_array[0]
			session[:address] = info_array[1]
			session[:name] = info_array[2]
		elsif params[:address_info] == "new_address_info"
			session[:postal_code] = order_params[:postal_code]
			session[:address] = order_params[:address]
			session[:name] = order_params[:name]
		end
		if session[:payment_method].present? && session[:address].present? && session[:postal_code].present? && session[:name].present?
			redirect_to order_confirm_url
		else
			#もう一度入力してくださいのflashメッセージ
		end
	end

	def confirm
		@carts = Cart.where(customer_id: current_customer.id)
		@total = total(current_customer)
		@claim = total(current_customer) + 800
	end



	def finish
		@order = Order.new
		@order.customer_id = current_customer.id
		@order.postal_code = session[:postal_code]
		@order.address = session[:address]
		@order.name = session[:name]
		@order.postage = 800
		@order.order_status = 0
		@order.payment_method = session[:payment_method]
		@order.total_payment = @order.postage + total(current_customer)
		@order.save

		#orders_productsテーブルへの保存
		current_customer.carts.each do |cart|
			@orders_product = OrdersProduct.new
			@orders_product.order_id = @order.id
			@orders_product.product_id = cart.product.id
			@orders_product.quantity = cart.quantity
			@orders_product.price = cart.product.tax_included_price
			@orders_product.production_status = 0
			@orders_product.save!
		end
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
