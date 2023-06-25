# typed: ignore
# Preview all emails at http://localhost:3000/rails/mailers/api/v1/company_user_invitations_mailer
class Api::V1::CompanyUserInvitationsMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/api/v1/company_user_invitations_mailer/invite_user
  def invite_user
    Api::V1::CompanyUserInvitationsMailer.with(company_user_invitation: CompanyUserInvitation.first).invite_user
  end

end
