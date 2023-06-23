# typed: strict
require 'sorbet-runtime'

class ApplicationController < ActionController::API
  extend T::Sig
  include ::ActionController::MimeResponds

  around_action :require_authentication

  private

  sig { params(blk: T.proc.void).void }
  def require_authentication(&blk)
    token = T.let(request.headers["HTTP_AUTHORIZATION"], T.nilable(String))
    jwt_decoded = JwtUtil.decode_token(token)

    if token.nil? || jwt_decoded.nil?
      return head :unauthorized
    end

    yield

    response.headers['Access-Token'] = JwtUtil.create_token()
  end
end
