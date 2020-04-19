class ProductsController < ApplicationController

	def index
		if params[:genre_id].exist?
			@products = Product.where(genre_id: genre.id)
		else
			@products = Product.all
		end

	end
end
