class CustomersController < ApplicationController
	before_action :authenticate_customer!

	def edit
	   @customer = Customer.find(current_customer.id)
	end

	def update
		@customer = Customer.find(current_customer.id)
        if @customer.update(customer_params)
           redirect_to customer_path
        else
            render :edit
        end
	end

	def confirm
	end

    def hide
        @customer = Customer.find(current_customer.id)
        #account_statusカラムにフラグを立てる(defaultはfalse)
        @customer.update(account_status: false)
        #ログアウトさせる
        reset_session
        flash[:notice] = "ありがとうございました。またのご利用を心よりお待ちしております。"
        redirect_to root_path
    end

	private
	def customer_params
		params.require(:customer).permit(:surname, :name, :kana_surname, :kana_name, :email, :postal_code, :address, :phone_number)
	end
end

