class CartsController < ApplicationController
before_action :authenticate_customer!
	def index
		@carts = Cart.where(customer_id: current_customer.id)
		@total = total(current_customer)
	end

	def create
		@cart = Cart.new(cart_params)
		@cart.customer_id = current_customer.id
		if current_customer.carts.where(product_id: params[:cart][:product_id].to_i).empty?
			@cart.save
			redirect_to carts_url
		else
			redirect_to product_path(@cart.product.id), flash: { alert: '既にカートに入っています！' }
		end
	end

	def update
		cart = Cart.find(params[:id])
		if cart.update(cart_params)
			redirect_to carts_url
		else
		@carts = Cart.where(customer_id: current_customer.id)
		@total = total(current_customer)
		p cart.errors.full_messages
			render 'index'
		end
	end

	def destroy
		cart = Cart.find(params[:id])
		 if cart.destroy
		    redirect_to carts_url
		else
			render 'index'
		end
	end

	def empty_cart
		cart = Cart.where(customer_id: current_customer.id)
		if cart.destroy_all
		   redirect_to carts_url
		else
			render 'index'
		end
	end

	private

	def cart_params
		params.require(:cart).permit(:product_id, :quantity)
	end

	def total(customer)
		total_price = 0
		customer.carts.each do |c|
			total_price += c.quantity * c.product.tax_included_price
		end
		return total_price
	end
end
