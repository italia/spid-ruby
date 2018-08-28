# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spid::Saml2::Utils::QueryParamsSigner do
  subject(:signer) do
    described_class.new(
      saml_message: "<samlp:AuthnRequest />",
      relay_state: "/path/to/return",
      private_key: private_key,
      signature_method: signature_method
    )
  end

  let(:private_key_str) { File.read(generate_fixture_path("private-key.pem")) }
  let(:private_key) { OpenSSL::PKey::RSA.new(private_key_str) }
  let(:signature_method) { Spid::RSA_SHA256 }

  it { is_expected.to be_a described_class }

  describe "#signature" do
    let(:signature) do
      <<~SIGNATURE
        cUXnVsxtFmBH7+JXIfBzvuf/x3TKwvFdguETlaVHQDCGabmK+s4B2HcqSRkU
        9vJ9wB2hQ0Qtpm0XyjQh7MtFbYUZ8GyWeaCsHZpUdnvGgoMCFUg8jqTNs2Bl
        xoFPFN+ceyAH4bX7cht4kn+zXBKB4HOQeXjTLjYlBiPVTRsdc/Vy3z9ebm5k
        Zitw+oLH1VMQKb4+F97e+2woZ8bJ1N2AFAx8VNfAfs5NRhKkfzOujc9vELyN
        JPIoW7pUtdKjFycruY0uMW64Z4zv1t58dihDmSwKoOYP+7gX2xLEaPOkaRP0
        xwstYNFKAk7LGm2BIIWATk4UOY0m4tdG7/FixaQNaGq5flZ1hqkk0JLSHCkp
        Y2SmTmgZp8F4qG06KKwBstgwt7/UbIk0HqB/wHCxP5vAh0MfO4y2/Vtz/cKC
        aRpEgxL0imZJbxfRTtPAxJLJe66UkesVSDVRQFTk/p2TNHt8rXEIFRmIv0s7
        ih0u4mcpoAwFJAOmhdcweoXFaxeT54Cd8j0ouPjnPM5+EhYl5FFxsPaxl7U/
        WHTk5Z/7d1Ge1famD4rY0ewDWvgLkWyaODjXwvZZXkXN1enj+EEnlIhT4Gmd
        w5irqU4Dm1PexOeimo1zbSuW5/fWDQBdl8VE/sdPgoVCcllxUZHrfqmrvSO/
        Bj9d+a7w4uR8Iztavmjo9Xw=
      SIGNATURE
    end

    it "returns the query params signature" do
      expect(signer.signature).to eq signature
    end
  end

  describe "#signed_query_params" do
    before do
      allow(signer).to receive(:signature).and_return("a-signature")
    end

    let(:expected_params) do
      a_hash_including(
        "SAMLRequest",
        "RelayState",
        "SigAlg",
        "Signature" => "a-signature"
      )
    end

    it "returns query params with signature" do
      expect(signer.signed_query_params).to match expected_params
    end
  end
end
