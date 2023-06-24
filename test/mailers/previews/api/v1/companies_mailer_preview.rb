# typed: ignore

# Preview all emails at http://localhost:3000/rails/mailers/api/v1/companies_mailer
class Api::V1::CompaniesMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/api/v1/companies_mailer/signup
  def signup
    Api::V1::CompaniesMailer.with(company: Company.first).signup
  end

end
