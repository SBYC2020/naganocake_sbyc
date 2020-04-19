class ProductsController < ApplicationController
	def index
		@products = Product.all
	end
	def show
		@products = Product.find(params[:id])
	end
	private
	def products_params
		params.require(:products).permit(:image_id, :product_name, :tax_included_price)
	end
end
