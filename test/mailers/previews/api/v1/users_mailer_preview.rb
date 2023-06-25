# typed: ignore
# Preview all emails at http://localhost:3000/rails/mailers/api/v1/users_mailer
class Api::V1::UsersMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/api/v1/users_mailer/signup
  def signup
    Api::V1::UsersMailer.with(user: User.first).signup
  end

end
