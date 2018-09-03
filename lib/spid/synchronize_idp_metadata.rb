# frozen_string_literal: true

require "json"
require "net/http"

module Spid
  class SynchronizeIdpMetadata # :nodoc:
    def initialize
      FileUtils.mkdir_p(Spid.configuration.idp_metadata_dir_path)
    end

    def call
      idp_list.map do |name, url|
        metadata_name = "#{name.delete(' ').downcase}-metadata.xml"
        metadata = get_metadata_from_url(url)

        File.open(metadata_path(metadata_name), "w") { |f| f.write metadata }
      end
    end

    def idp_list
      metadata_list.each.with_object({}) do |(name, url), acc|
        uri = URI(url)
        res = Net::HTTP.get_response(uri)
        acc[name] = if res.code == "302"
                      res["Location"]
                    else
                      url
                    end
      end
    end

    def metadata_list
      entities.each.with_object({}) do |entity, acc|
        entity_name = entity["entity_name"]
        entity_name = "SPIDItalia" if entity_name =~ /SPIDItalia/
        acc[entity_name] = entity["metadata_url"]
      end
    end

    def metadata_path(name)
      File.join(
        Spid.configuration.idp_metadata_dir_path,
        name
      )
    end

    def entities
      return [] if idp_list_raw.nil?

      JSON.parse(idp_list_raw)["spidFederationRegistry"]["entities"]
    end

    def get_metadata_from_url(url)
      uri = URI(url)
      req = Net::HTTP::Get.new(uri)

      res = Net::HTTP.start(
        uri.host, uri.port, use_ssl: uri.scheme == "https"
      ) do |http|
        http.request(req)
      end

      res.body
    end

    def idp_list_raw
      uri = URI(registry_url)

      req = Net::HTTP::Get.new(uri)
      req["Accept"] = "application/json"

      res = Net::HTTP.start(
        uri.host, uri.port, use_ssl: uri.scheme == "https"
      ) do |http|
        http.request(req)
      end

      res.body
    end

    def registry_url
      "https://registry.spid.gov.it/api/identity-providers"
    end
  end
end
