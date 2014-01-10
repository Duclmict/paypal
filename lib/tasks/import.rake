namespace :db do
  desc "send email automatic"
  task :import =>[:environment] do

    require 'paypal-sdk-adaptivepayments'
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
      @url = @api.payment_url(@response).to_s  # Url to complete payment
      UserMailer.sendmail(@url).deliver
    else
      @response.error[0].message
    end

  end

end
