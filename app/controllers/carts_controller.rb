class CartsController < ApplicationController

	def index
		@carts = Cart.where(customer_id: current_customer.id)
		@total = total(current_customer)
	end

	def create
		cart = Cart.new(cart_params)
		cart.customer_id = current_customer.id
		if cart.save
			redirect_to carts_url
		else
			# 保存できなかった場合の記述を書く
		end
	end

	def update
		cart = Cart.find(params[:id])
		cart.update(cart_params)
		redirect_to carts_url
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
