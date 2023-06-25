class Api::V1::UsersMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.api.v1.users_mailer.signup.subject
  #
  def signup
    @user = params[:user]
    @company = @user.company
    @link_to_active = api_v1_user_active_url(token: @user.token)

    mail to: email_address_with_name(@user.email, @user.full_name)
  end
end
