# Changelog

## [Unreleased]
### Fixed
- Metadata embed now signature
- Now it's possible to use attributes in attribute services in string format

## [0.17.2] - 2018-09-11
### Fixed
- `Spid::Rack::Login` now use authn_context value

## [0.17.1] - 2018-09-10
### Changed
- Identity Provider fetched by entity_id

## [0.17.0] - 2018-09-10
### Added
- Ensure private key lenght and certificate validation
- Previous SPID specification use sp_entity_id for /samlp:Response/@Destination
- Validate Subject attributes
- Validate Issuer and Assertion/Issuer

## [0.16.1] - 2018-09-05
### Changed
- Use login_path and logout_path instead of start_sso_path and start_slo_path

## [0.16.0] - 2018-09-05
### Added
- Task rake for IdPs metadata fetching
- Rails installer

## [0.15.2] - 2018-08-31
### Fixed
- Now response doesn't fail if status code is not success

## [0.15.1] - 2018-08-31
### Fixed
- Fix uuid generation for spid logout request

## [0.15.0] - 2018-08-31
### Fixed
- [IDP-Initiated SLO was not full implemented](https://github.com/italia/spid-ruby/issues/54)

## [0.14.0] - 2018-08-30
### Added
- IDP-Initiated SLO management
- Error Handling

## [0.13.0] - 2018-08-29
### Added
- Validation of Response and LogoutResponse

## [0.12.0] - 2018-08-27
### Added
- AttributeConsumingService management

## [0.11.0] - 2018-08-23
### Changed
- Use custom Saml2 library instead of ruby-saml gem

## [0.10.0] - 2018-08-02
### Added
- Handled Relay State in sso/slo responses
- session["spid"] initialized
- Configurable Bindings

### Changed
- Signature in url instead of in SAMLRequest body

### Fixed
- Metadata rack response body is now an array
- Typo on authn context comparison value
- AllowCreate is not expected in NameIDPolicy element
- Redirects to idp will not cached anymore

## [0.9.0] - 2018-07-31
### Added
- Rack middleware that handles spid login requests
- Rack middleware that handles spid logout requests
- Rack middleware that handles spid sso assertion
- Rack middleware that handles spid slo assertion
- Rack middleware that handles spid metadata requests
- Rack middleware that contains all specific middlewares

## [0.8.0] - 2018-07-26
### Added
- Spid configuration singleton class

### Changed
- Slo prefixed classes moved to Slo:: Namespace
- Sso prefixed classes moved to Sso:: Namespace
- Request and Response classes generate themselves setting objects

## [0.7.0] - 2018-07-18
### Added
- SloResponse class in order to validate saml response

## [0.6.0] - 2018-07-18
### Added
- Slo Settings and SloRequest class

## [0.5.0] - 2018-07-13
### Added
- Sso Settings with all saml settings required attributes

## [0.4.0] - 2018-07-13
### Added
- ServiceProviderConfiguration class handles configuration for a specific host
- SsoResponse class

## [0.3.1] - 2018-07-09
### Added
- Signature in authn_request

## [0.3.0] - 2018-07-06

### Added
- Fetch all identity provider from https://registry.spid.gov.it
- Parse and store metadata from single Identity Provider
### Changed
- Spid::AuthnRequest class inherit from OneLogin::RubySaml::Authrequest in order to override create_xml_document in chain
- Separate class for saml request generation

## [0.2.2] - 2018-07-02
### Fixed
- Spid::L1 constant duplicated
- Constraint for gemspec gem versions

## [0.2.1] - 2018-07-02
### Added
- metadata in gemspec

### Changed
- Update ```AuthnContextClassReftig``` classes according to (https://www.agid.gov.it/sites/default/files/repository_files/documentazione/spid-avviso-n5-regole-tecniche-errata-corrige.pdf)

## [0.2.0] - 2018-07-02
### Added
- Feature table in README
- Spid::AuthnRequest create a SAML AuthnRequest specific for SPID
- Added CHANGELOG.md

## 0.1.1 - 2018-06-27
### Added
- TravisCI Integration
- Coveralls Integration
- Rubygems version badge in README

[Unreleased]: https://github.com/italia/spid-ruby/compare/v0.17.2...HEAD
[0.17.2]: https://github.com/italia/spid-ruby/compare/v0.17.1...v0.17.2
[0.17.1]: https://github.com/italia/spid-ruby/compare/v0.17.0...v0.17.1
[0.17.0]: https://github.com/italia/spid-ruby/compare/v0.16.1...v0.17.0
[0.16.1]: https://github.com/italia/spid-ruby/compare/v0.16.0...v0.16.1
[0.16.0]: https://github.com/italia/spid-ruby/compare/v0.15.2...v0.16.0
[0.15.2]: https://github.com/italia/spid-ruby/compare/v0.15.1...v0.15.2
[0.15.1]: https://github.com/italia/spid-ruby/compare/v0.15.0...v0.15.1
[0.15.0]: https://github.com/italia/spid-ruby/compare/v0.14.0...v0.15.0
[0.14.0]: https://github.com/italia/spid-ruby/compare/v0.13.0...v0.14.0
[0.13.0]: https://github.com/italia/spid-ruby/compare/v0.12.0...v0.13.0
[0.12.0]: https://github.com/italia/spid-ruby/compare/v0.11.0...v0.12.0
[0.11.0]: https://github.com/italia/spid-ruby/compare/v0.10.0...v0.11.0
[0.10.0]: https://github.com/italia/spid-ruby/compare/v0.9.0...v0.10.0
[0.9.0]: https://github.com/italia/spid-ruby/compare/v0.8.0...v0.9.0
[0.8.0]: https://github.com/italia/spid-ruby/compare/v0.7.0...v0.8.0
[0.7.0]: https://github.com/italia/spid-ruby/compare/v0.6.0...v0.7.0
[0.6.0]: https://github.com/italia/spid-ruby/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/italia/spid-ruby/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/italia/spid-ruby/compare/v0.3.1...v0.4.0
[0.3.1]: https://github.com/italia/spid-ruby/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/italia/spid-ruby/compare/v0.2.2...v0.3.0
[0.2.2]: https://github.com/italia/spid-ruby/compare/v0.2.1...v0.2.2
[0.2.1]: https://github.com/italia/spid-ruby/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/italia/spid-ruby/compare/v0.1.1...v0.2.0
