class PaymentController < ApplicationController
  require 'paypal-sdk-adaptivepayments'
  def payment

    PayPal::SDK.configure(
        :mode      => "sandbox",
        :app_id    => "APP-80W284485P519543T",
        :username  => "buy_kemaodanh_api1.gmail.com",
        :password  => "1389262223",
        :signature => "AiPC9BjkCyDFQXbSkoZcgqH3hpacA2.23cH0w1SUU3PjMcgfh3NI2cKK"
    )

    @api = PayPal::SDK::AdaptivePayments.new

# Build request object
    @pay = @api.build_pay({
                              :actionType => "PAY",
                              :cancelUrl => "http://localhost:3000",
                              :currencyCode => "USD",
                              :feesPayer => "SENDER",
                              :ipnNotificationUrl => "http://localhost:3000",
                              :receiverList => {
                                  :receiver => [{
                                                  :amount => 100,
                                                  :email => "seller_kemaodanh@gmail.com"
                                                },
                                                {
                                                    :amount => 200,
                                                    :email => "white_kemaodanh@gmail.com"
                                                },
                                  ]
                              },
                              :returnUrl => "http://localhost:3000"
                          })
# Make API call & get response
    @response = @api.pay(@pay)

# Access response
    if @response.success?
      @response.payKey
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
