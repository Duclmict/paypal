class PaymentController < ApplicationController
  require 'paypal-sdk-adaptivepayments'
  def payment
    PayPal::SDK.load('config/paypal.yml',  ENV['RACK_ENV'] || 'development')

    @api = PayPal::SDK::AdaptivePayments.new
    @receiver = []
    @user = User.all
    @user.each do |user|
      if user.status == true
      @receiver.push(
                               {:amount => user.salary,
                                :email => user.pay_account
                               }
      )
      end
    end


# Build request object
    @pay = @api.build_pay({
          :actionType => "PAY",
          :cancelUrl => "http://localhost:3000",
          :currencyCode => "USD",
          :feesPayer => "SENDER",
          :ipnNotificationUrl => "http://localhost:3000",
          :receiverList => {

              :receiver =>  @receiver

          },
          :returnUrl => "http://localhost:3000"
                          })
# Make API call & get response
    @response = @api.pay(@pay)

# Access response
    if @response.success?
   redirect_to  @api.payment_url(@response)  # Url to complete payment
    else
      @response.error[0].message
    end
  end

  def show_payment
    payment = Payment.find("PAY-57363176S1057143SKE2HO3A")

# Get List of Payments
    payment_history = Payment.all( :count => 10 )
   render :json => payment_history.payments
  end

  def pay

    payment = Payment.find("PAY-57363176S1057143SKE2HO3A")

    if payment.execute( :payer_id => "DUFRQ8GWYMJXC" )
      # Success Message
    else
      payment.error # Error Hash
    end
  end

end
