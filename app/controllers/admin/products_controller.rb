class Admin::ProductsController < ApplicationController

	def new
		@product = Product.new
		@genres = Genre.all
	end

	def index
		@products = Product.all
	end

	def show
		@product = Product.find(params[:id])
	end

	def create
		@product = Product.new(product_params)
		@genres = Genre.all
		if @product.save!
		   redirect_to admin_product_url(@product)
		else
			render 'new'
		end
	end

	def edit
		@product = Product.find(params[:id])
		@genres = Genre.all
	end

	def update
		@product = Product.find(params[:id])
		if @product.update(product_params)
		   redirect_to admin_product_url(@product)
		else
			render 'edit'
		end
	end

	private
	def product_params
		params.require(:product).permit(:product_name,
		                         :product_description, :genre_id,
		                         :sale_status, :image,
		                         :tax_included_price)
	end

end
