class OrdersController < ApplicationController

  before_filter(only: [:paypal, :payment]) { Shoppe::Paypal.setup_paypal }

  def destroy
    current_order.destroy
    session[:order_id] = nil
    redirect_to root_path, :notice => "Basket emptied successfully."
  end

  def checkout
    @order = Shoppe::Order.find(current_order.id)
    if request.patch?
      if @order.proceed_to_confirm(params[:order].permit(:first_name, :last_name, :billing_address1, :billing_address2, :billing_address3, :billing_address4, :billing_country_id, :billing_postcode, :email_address, :phone_number))
        redirect_to checkout_payment_path
      end
    end
  end

  def payment
    @order = Shoppe::Order.find(session[:current_order_id])
    if request.post?
      if @order.accept_stripe_token(params[:stripe_token])
        redirect_to checkout_confirmation_path
      else
        flash.now[:notice] = "Could not exchange Stripe token. Please try again."
      end
      if params[:success] == "true" && params[:PayerID].present?
        @order.accept_paypal_payment(params[:paymentId], params[:token], params[:PayerID])
      end
    end
  end

  def confirmation
    if request.post?
      current_order.confirm!
      session[:order_id] = nil
      redirect_to root_path, :notice => "Order has been placed successfully!"
    end
  end

  def paypal
    @order = Shoppe::Order.find(session[:current_order_id])
    url = @order.redirect_to_paypal(checkout_payment_url(success: true), checkout_payment_url(success: false))
    redirect_to url
  end



end
