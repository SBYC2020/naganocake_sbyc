class Admin::ProductItemsController < ApplicationController
before_action :authenticate_admin!

	def update
		# orders_products = OrdersProduct.find_by(id: params[:orders_product][:orders_product_id].to_i)
		orders_products = OrdersProduct.find(params[:orders_product_id])
		if orders_products.update(orders_product_params)
			if orders_products.production_status == "製作中"
			   orders_products.order.update(order_status: "製作中")
			end

			if orders_products.order.orders_products.all? {|orders_product| orders_product.production_status =="製作完了"}
			   orders_products.order.update(order_status: "発送準備中")
			end

		   redirect_back(fallback_location: root_path)
		else
			render :show
		end
	end

	private
	def orders_product_params
		params.require(:orders_product).permit(:production_status, :order_status, :orders_product_id)
	end

end
