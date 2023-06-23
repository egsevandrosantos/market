# typed: strict
require 'sorbet-runtime'

class Api::V1::HealthCheckController < ApplicationController
  extend T::Sig
  skip_around_action :require_authentication, only: [:index]

  sig { void }
  def index
    respond_to do |format|
      format.any { render plain: I18n.t('hello_world'), status: :ok }
    end
  end
end
