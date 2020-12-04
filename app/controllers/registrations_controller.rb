class RegistrationsController < Devise::RegistrationsController

  # When creating a controller that is associated with devise you can follow along with what they did
  # on their controller. For reference(https://github.com/heartcombo/devise/blob/master/app/controllers/devise/registrations_controller.rb)

  def create
    build_resource(sign_up_params)

    resource.class.transaction do
      resource.save
      yield resource if block_given?
      if resource.persisted?
        # create a payment
        @payment = Payment.new({ email: params["user"]["email"],
                                token: params[:payment]["token"],
                                user_id: resource.id })

        # if payment is not valid
        flash[:error] = "Please check registration errors" unless @payment.valid?

        # begin of the payment processing flow
        begin
          @payment.process_payment
          @payment.save
        rescue Exception => e
          flash[:error] = e.message

          resource.destroy
          puts "Payment failed"
          render :new and return
        end

        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end

      end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:payment)
  end

end