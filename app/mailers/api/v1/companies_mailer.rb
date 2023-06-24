# typed: ignore

class Api::V1::CompaniesMailer < ApplicationMailer
  default from: 'notifications@example.com'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.api.v1.companies_mailer.signup.subject
  #
  def signup
    @company = params[:company]
    @link_to_active = api_v1_company_active_url(token: @company.token)

    mail to: email_address_with_name(@company.email, @company.corporate_name)
  end
end
