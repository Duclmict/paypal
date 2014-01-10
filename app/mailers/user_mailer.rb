class UserMailer < ActionMailer::Base
  default from: "kemaodanh.2008@gmail.com"
  def sendmail(url)
    @url = url
    mail(to: "kemaodanh.2008@gmail.com", subject: "sendmail")
  end
end
