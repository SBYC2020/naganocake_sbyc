class ApplicationController < ActionController::Base
before_action :configure_permitted_parameters, if: :devise_controller?

protected
	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: [:surname, :name, :kana_surname, :kana_name, :postal_code, :address, :phone_number, :account_status])
	end
end
