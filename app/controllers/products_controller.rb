class ProductsController < ApplicationController


	def index
		if params[:genre_id].exist?
			@products = Product.where(genre_id: genre.id)
		else
			@products = Product.all
		end
	end

	def show
		@products = Product.find(params[:id])
	end
	private
	def products_params
		params.require(:products).permit(:image_id, :product_name, :tax_included_price)

	end
end
