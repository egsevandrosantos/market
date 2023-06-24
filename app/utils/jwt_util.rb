# typed: strict
require 'sorbet-runtime'

class JwtUtil
  extend T::Sig

  sig { params(token: T.nilable(String)).returns(T.nilable(T::Array[T::Hash[String, T.untyped]])) }
  def self.decode_token(token)
    return if token.nil?
    token.gsub!('Bearer ', '')

    begin
      # sub = id do usuario
      # iss = emissor do token
      # exp = quando ira expirar
      # iat = quando foi criado
      # aud = destinario do token, representa a aplicação que ira usa-lo
      # Geralmente mais utilizados são sub, iss e exp
      # https://medium.com/tableless/entendendo-tokens-jwt-json-web-token-413c6d1397f6
      return JWT.decode(token, ENV['jwt_secret_key'], true, {
        verify_iss: true,
        iss: ENV['iss'],
        algorithm: 'HS256',
        verify_expiration: true
      })
    rescue JWT::ExpiredSignature => e
      Rails.logger.warn "JWT expired: " + e.to_s
    rescue JWT::DecodeError => e
      Rails.logger.warn "Error decoding the JWT: " + e.to_s
    end
    return nil
  end

  sig { params(company_id: Integer).returns(String) }
  def self.create_token(company_id)
    sub_info = T.let({}, T::Hash[Symbol, Integer])
    sub_info[:company_id] = company_id

    minutes = 1.minutes
    exp = (Time.zone.now + minutes).to_i
    payload = {
      "iss": ENV['iss'],
      "exp": exp,
      "sub": sub_info, # infos no JWT
    }

    return JWT.encode(payload, ENV['jwt_secret_key'], 'HS256')
  end
end