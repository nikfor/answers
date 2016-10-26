class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_authorization_check

  def facebook
    simple_sign_in(request.env['omniauth.auth'])
  end

  def twitter
    auth = request.env['omniauth.auth']
    unless simple_sign_in(auth)
      session['devise.auth'] = { provider: auth.provider, uid: auth.uid }
      redirect_to add_email_form_path
    end
  end

  private

  def simple_sign_in(auth)
    @user = User.find_for_oauth(auth)
    if @user && @user.persisted?
      sign_in_and_redirect @user, event: :authenticaton
      set_flash_message(:notice, :success, kind: auth.provider) if is_navigational_format?
    end
  end

end
