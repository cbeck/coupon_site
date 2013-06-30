class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
  
    @body[:url]  = "http://#{MY_HOST}/activate/#{user.activation_code}"
  
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://#{MY_HOST}/"
  end
  
  def forgot_password(user)
    setup_email(user)
    @body[:url] = "http://#{MY_HOST}/reset_password/#{user.password_reset_code}"
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = SUPPORT_EMAIL
      @subject     = "[#{MY_HOST}] "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
