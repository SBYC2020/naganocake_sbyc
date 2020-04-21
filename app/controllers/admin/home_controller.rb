class Admin::HomeController < ApplicationController
#before_action :authenticate_admin!
	def top
		@order = Order.where("created_at >= ?", Time.zone.now.beginning_of_day)

	end

	def new
	end
end


