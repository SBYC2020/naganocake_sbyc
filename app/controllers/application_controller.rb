class ApplicationController < ActionController::Base
before_action :configure_permitted_parameters, if: :devise_controller?

protected

	def after_sign_up_path_for(resource)
		case resource
		when Admin
		   admin_root_path
		when Customer
			root_path
		end
	end

	def after_sign_in_path_for(resource)
		case resource
		when Admin
			admin_root_path
		when Customer
			root_path
		end
	end

	def after_sign_out_path_for(resource_or_scope)
	    if resource_or_scope == :admin
	      new_admin_session_path
	    else
	      root_path
	    end
	end

	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: [:surname, :name, :kana_surname, :kana_name, :postal_code, :address, :phone_number, :account_status])
	end
end
