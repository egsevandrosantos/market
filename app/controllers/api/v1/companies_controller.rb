# typed: strict
require 'sorbet-runtime'

class Api::V1::CompaniesController < ApplicationController
  extend T::Sig

  wrap_parameters :company, include: [:corporate_name, :fantasy_name, :email, :email_confirmation, :domain, :cnpj, :users_attributes]

  skip_around_action :require_authentication, only: [:create, :show, :active]

  sig { void }
  def create
    company = Company.new(company_params)
    if company.valid?
      begin
        company.save!
        head :created, location: api_v1_company_url(company)
      rescue Exception => ex
        Rails.logger.error "Error create company: " + ex.full_message
        head :internal_server_error
      end
    else
      respond_to do |format|
        format.json { render json: company.errors.messages, status: :bad_request }
        format.any { head :unsupported_media_type }
      end
    end
  end

  sig { void }
  def show
    head :method_not_allowed
  end

  sig { void }
  def show_by_token
    if @current_company.present?
      respond_to do |format|
        format.json { render 'api/v1/companies/show', status: :ok }
        format.any { head :unsupported_media_type }
      end
    else
      render :not_found
    end
  end

  sig { void }
  def active
    company = Company.status_inactive.find_by(token: params[:token])
    if company.present?
      begin
        company.update!(status: :active, token: nil)
        head :ok
      rescue Exception => ex
        Rails.logger.error "Error active company: " + ex.full_message
        head :internal_server_error
      end
    else
      head :not_found
    end
  end

  private

  sig { returns(ActionController::Parameters) }
  def company_params
    params.require(:company).permit(:corporate_name, :fantasy_name, :email, :email_confirmation, :domain, :cnpj, users_attributes: [:full_name, :cpf, :email, :email_confirmation, :password, :password_confirmation])
  end
end
