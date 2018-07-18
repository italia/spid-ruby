# Changelog

## [Unreleased]
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

[Unreleased]: https://github.com/italia/spid-ruby/compare/v0.6.0...HEAD
[0.6.0]: https://github.com/italia/spid-ruby/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/italia/spid-ruby/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/italia/spid-ruby/compare/v0.3.1...v0.4.0
[0.3.1]: https://github.com/italia/spid-ruby/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/italia/spid-ruby/compare/v0.2.2...v0.3.0
[0.2.2]: https://github.com/italia/spid-ruby/compare/v0.2.1...v0.2.2
[0.2.1]: https://github.com/italia/spid-ruby/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/italia/spid-ruby/compare/v0.1.1...v0.2.0
