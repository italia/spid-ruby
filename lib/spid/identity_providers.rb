# frozen_string_literal: true

require "faraday"
require "faraday_middleware"

module Spid
  class IdentityProviders # :nodoc:
    def self.fetch_all
      new.fetch_all
    end

    def fetch_all
      spid_idp_entities.map do |idp|
        {
          name: idp["entity_name"].gsub(/ ID$/, "").downcase,
          metadata_url: idp["metadata_url"],
          entity_id: idp["entity_id"]
        }
      end
    end

    private

    def spid_idp_entities
      return [] if response.body["spidFederationRegistry"].blank?
      response.body["spidFederationRegistry"]["entities"]
    end

    def response
      connection.get do |req|
        req.url "/api/identity-providers"
        req.headers["Accept"] = "application/json"
      end
    end

    def connection
      Faraday.new("https://registry.spid.gov.it") do |conn|
        conn.response :json, content_type: /\bjson$/

        conn.adapter Faraday.default_adapter
      end
    end
  end
end
