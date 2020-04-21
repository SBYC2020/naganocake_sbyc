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
		@genres = Genre.where(is_active: true)
		@product = Product.find(params[:id])
		@cart = Cart.new
	end
end
