class Api::V1::CompanyUserInvitationsMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.api.v1.company_user_invitations_mailer.invite_user.subject
  #
  def invite_user
    @company_user_invitation = params[:company_user_invitation]
    @link_to_create_account = api_v1_users_url(token: @company_user_invitation.token)

    mail to: @company_user_invitation.user_email
  end
end
