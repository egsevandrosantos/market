# typed: strict
require 'sorbet-runtime'

class Api::V1::UsersController < ApplicationController
  extend T::Sig

  wrap_parameters :user, include: [:full_name, :cpf, :email, :email_confirmation, :password, :password_confirmation]
  skip_around_action :require_authentication, only: [:create, :show, :active]

  sig { void }
  def create
    company_user_invitation = CompanyUserInvitation.find_by(token: params[:token])
    if company_user_invitation.present?
      user = User.new(user_params)
      user.company = company_user_invitation.company
      if user.valid?
        begin
          user.save!
          company_user_invitation.destroy!
          head :created, location: api_v1_user_url(user)
        rescue Exception => ex
          Rails.logger.error "Error create user: " + ex.full_message
          head :internal_server_error
        end
      else
        respond_to do |format|
          format.json { render json: user.errors.messages, status: :bad_request }
          format.any { head :unsupported_media_type }
        end
      end
    else
      head :not_acceptable
    end
  end

  sig { void }
  def show
    head :method_not_allowed
  end

  sig { void }
  def show_by_token
    if @current_user.present?
      respond_to do |format|
        format.json { render 'api/v1/users/show', status: :ok }
        format.any { head :unsupported_media_type }
      end
    else
      head :not_found
    end
  end

  sig { void }
  def active
    user = User.status_inactive.find_by(token: params[:token])
    if user.present?
      begin
        user.update!(status: :active, token: nil)
        head :ok
      rescue Exception => ex
        Rails.logger.error "Error active user: " + ex.full_message
        head :internal_server_error
      end
    else
      head :not_found
    end
  end

  private

  sig { returns(ActionController::Parameters) }
  def user_params
    params.require(:user).permit(:full_name, :cpf, :email, :email_confirmation, :password, :password_confirmation)
  end
end
