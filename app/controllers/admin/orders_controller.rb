class Admin::OrdersController < ApplicationController

	def index
		@orders = Order.all.page(params[:page]).per(10)
	end

	def show
		@order = Order.find(params[:id])
		@orders_products = OrdersProduct.all.page(params[:page]).per(4)
	end

	def update
		@order = Order.find(params[:id])
		if @order.update(order_params)
			if @order.order_status == "入金確認"
			   @order.orders_products.update(production_status: "製作待ち")
			end
		   redirect_back(fallback_location: root_path)
		else
			render :show
		end
	end

	private
	def order_params
		params.require(:order).permit(:customer_id, :name, :address, :payment_method, :order_status, :created_at, :quantity, :product_id, :price, :production_status, :total_payment)
	end


	# before_action :authenticate_admin!

end
