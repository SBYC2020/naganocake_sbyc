class CustomersController < ApplicationController
	before_action :authenticate_customer!

	def edit
	   @customer = Customer.find(current_customer.id)
	end

	def update
		@customer = Customer.find(current_customer.id)
        if @customer.update(customer_params)
           redirect_to root_path
        else
            render :edit
        end
	end


	private
	def customer_params
		params.require(:customer).permit(:surname, :name, :kana_surname, :kana_name, :email, :postal_code, :address, :phone_number)
	end
end

