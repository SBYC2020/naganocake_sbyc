class Admin::CustomersController < ApplicationController

	def index
		@customers = Customer.all.page(params[:page]).per(10)
	end

	def show
		@customer = Customer.find(params[:id])
	end

	def edit
		@customer = Customer.find(params[:id])
	end

	def update
		@customer = Customer.find(params[:id])
		if @customer.update(customer_params)
			redirect_to admin_customer_path(@customer.id)
		else
      		render 'edit'
		end
	end

	private
	def customer_params
		params.require(:customer).permit(:surname, :name, :kana_surname, :kana_name, :postal_code, :address, :phone_number, :email, :account_status)
	end

end
