class CustomersController < ApplicationController

	before_action :authenticate_customer!
	def edit

	   @customer = current_customer
	end
	def update
		@customer = current_customer
        if @customer.update!(customer_params)
           redirect_to root_path
        else
            render :edit
        end
	end


	private
	def customer_params
		params.require(:customer).permit(:surname, :name, :postal_code, :address, :phone_number)
	end
end
