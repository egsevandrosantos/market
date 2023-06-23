# typed: strict
require 'sorbet-runtime'

class ApplicationController < ActionController::API
  extend T::Sig
  include ::ActionController::MimeResponds

  around_action :require_authentication
  before_action :switch_locale

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

  sig { void }
  def switch_locale
    locale = extract_locale_from_accept_language_header
    I18n.locale = !locale.nil? && I18n.available_locales.include?(locale.to_sym) ? locale.to_sym : I18n.default_locale
  end

  sig { returns(T.nilable(String)) }
  def extract_locale_from_accept_language_header
    lang = T.let(request.env['HTTP_ACCEPT_LANGUAGE'], T.nilable(String))
    return nil if lang.nil?
    return T.cast(lang.scan(/^[a-z]{2}/).first, String)
  end

end
