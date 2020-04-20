class ProductsController < ApplicationController


	def index
		@genres = Genre.where(is_active: true)
		if params[:genre_id]
			@genre = Genre.find(params[:genre_id])
			@products = Product.where(genre_id: @genre.id)
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
