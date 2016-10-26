class UsersController < ApplicationController
  skip_authorization_check

  def add_email_form
  end

  def add_email
    authh = session['devise.auth'].merge!(info: { email: params[:email] })
    auth = OpenStruct.new(authh)
    @user = User.find_for_oauth(auth)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authenticaton
    end
  end

end
