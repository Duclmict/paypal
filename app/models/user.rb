class User < ActiveRecord::Base
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
      return  @api.payment_url(@response)  # Url to complete payment
    else
      @response.error[0].message
      return "failue"
    end
  end
end
