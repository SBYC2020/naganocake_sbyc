class HomeController < ApplicationController

	def top
		#Genreの中のis_activeカラムのデータ型がtrueのものだけを表示
		@genres = Genre.where(is_active: true)

		@products = Product.all

	end

	def show

	end


end