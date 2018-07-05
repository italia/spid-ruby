# frozen_string_literal: true

module SamlManipulation
  def decode_and_inflate(string)
    decoded_from_base64 = Base64.decode64(string)
    Zlib::Inflate.new(-Zlib::MAX_WBITS).inflate(decoded_from_base64)
  end

  def parse_saml_request_from_url(saml_request_url)
    uri = URI.parse(saml_request_url)
    query_params = CGI.parse(uri.query)
    saml_request_param = query_params["SAMLRequest"]
    saml_request_param = saml_request_param[0] if saml_request_param.present?
    decode_and_inflate(saml_request_param)
  end
end

RSpec.configure do |config|
  config.include SamlManipulation
end
