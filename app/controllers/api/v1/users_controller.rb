# typed: strict
require 'sorbet-runtime'

class Api::V1::UsersController < ApplicationController
  extend T::Sig

  skip_around_action :require_authentication, only: [:show, :active]

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
end
