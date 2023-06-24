# typed: strict
require 'sorbet-runtime'

class Api::V1::LoginController < ApplicationController
  extend T::Sig

  skip_around_action :require_authentication, only: [:login]

  sig { void }
  def login
    domain = params[:domain]
    permitted_params = params.require(:login).permit(:email, :password)
    company = Company.status_active.find_by(domain: domain)
    user = User.status_active.find_by(email: permitted_params[:email], company: company) if company.present?
    if company.present? && user.present? && user.authenticate_password(permitted_params[:password])
      response.headers['Access-Token'] = JwtUtil.create_token(T.must(company.id), T.must(user.id))
      head :ok
    else
      head :unauthorized
    end
  end
end
