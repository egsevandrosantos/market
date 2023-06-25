# typed: strict
require 'sorbet-runtime'

class Api::V1::CompanyUserInvitationsController < ApplicationController
  extend T::Sig

  wrap_parameters :company_user_invitation, include: [:user_email, :user_email_confirmation]

  sig { void }
  def create
    company_user_invitation = CompanyUserInvitation.new(company_user_invitation_params)
    company_user_invitation.company = @current_company
    if company_user_invitation.valid?
      begin
        company_user_invitation.save!
        T.let(Api::V1::CompanyUserInvitationsMailer, T.untyped).with(company_user_invitation: company_user_invitation).invite_user.deliver_later
        head :created, location: api_v1_company_user_invitation_path(company_user_invitation)
      rescue Exception => ex
        Rails.logger.error "Error create invitation to user: " + ex.full_message
        head :internal_server_error
      end
    else
      respond_to do |format|
        format.json { render json: company_user_invitation.errors.messages, status: :bad_request }
        format.any { head :unsupported_media_type }
      end
    end
  end

  sig { void }
  def show
    head :method_not_allowed
  end

  private

  sig { returns(ActionController::Parameters) }
  def company_user_invitation_params
    params.require(:company_user_invitation).permit(:user_email, :user_email_confirmation)
  end
end
