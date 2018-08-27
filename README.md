# spid-ruby

Ruby library for SPID authentication


| Project                | Spid Ruby |
| ---------------------- | ------------ |
| Gem name               | spid |
| License                | [BSD 3](https://github.com/italia/spid-ruby/blob/master/LICENSE) |
| Version                | [![Gem Version](https://badge.fury.io/rb/spid.svg)](http://badge.fury.io/rb/spid) |
| Continuous integration | [![Build Status](https://secure.travis-ci.org/italia/spid-ruby.svg?branch=master)](https://travis-ci.org/italia/spid-ruby) |
| Test coverate          | [![Coverage Status](https://coveralls.io/repos/github/italia/spid-ruby/badge.svg?branch=master)](https://coveralls.io/github/italia/spid-ruby?branch=master) |
| Credits                | [Contributors](https://github.com/italia/spid-ruby/graphs/contributors) |

## Installation

Add into your Gemfile

```ruby
gem "spid"
```


## Features

|<img src="https://github.com/italia/spid-graphics/blob/master/spid-logos/spid-logo-c-lb.png?raw=true" width="100" /><br />_Compliance with [SPID regulations](http://www.agid.gov.it/sites/default/files/circolari/spid-regole_tecniche_v1.pdf) (for Service Providers)_||
|:---|:---|
|**Metadata:**||
|parsing of IdP XML metadata (1.2.2.4)|✓|
|parsing of AA XML metadata (2.2.4)||
|SP XML metadata generation (1.3.2)|✓|
|**AuthnRequest generation (1.2.2.1):**||
|generation of AuthnRequest XML|✓|
|HTTP-Redirect binding|✓|
|HTTP-POST binding||
|`AssertionConsumerServiceURL` customization|✓|
|`AssertionConsumerServiceIndex` customization||
|`AttributeConsumingServiceIndex` customization|✓|
|`AuthnContextClassRef` (SPID level) customization|✓|
|`RequestedAuthnContext/@Comparison` customization||
|`RelayState` customization (1.2.2)|✓|
|**Response/Assertion parsing**||
|verification of `Response/Signature` value (if any)||
|verification of `Response/Signature` certificate (if any) against IdP/AA metadata||
|verification of `Assertion/Signature` value||
|verification of `Assertion/Signature` certificate against IdP/AA metadata||
|verification of `SubjectConfirmationData/@Recipient`||
|verification of `SubjectConfirmationData/@NotOnOrAfter`||
|verification of `SubjectConfirmationData/@InResponseTo`||
|verification of `Issuer`||
|verification of `Destination`||
|verification of `Conditions/@NotBefore`||
|verification of `Conditions/@NotOnOrAfter`||
|verification of `Audience`||
|parsing of Response with no `Assertion` (authentication/query failure)||
|parsing of failure `StatusCode` (Requester/Responder)||
|**Response/Assertion parsing for SSO (1.2.1, 1.2.2.2, 1.3.1):**||
|parsing of `NameID`|✓|
|parsing of `AuthnContextClassRef` (SPID level)||
|parsing of attributes|✓|
|**Response/Assertion parsing for attribute query (2.2.2.2, 2.3.1):**||
|parsing of attributes||
|**LogoutRequest generation (for SP-initiated logout):**||
|generation of LogoutRequest XML|✓|
|HTTP-Redirect binding|✓|
|HTTP-POST binding||
|**LogoutResponse parsing (for SP-initiated logout):**||
|parsing of LogoutResponse XML|✓|
|verification of `Response/Signature` value (if any)||
|verification of `Response/Signature` certificate (if any) against IdP metadata||
|verification of `Issuer`||
|verification of `Destination`||
|PartialLogout detection||
|**LogoutRequest parsing (for third-party-initiated logout):**||
|parsing of LogoutRequest XML||
|verification of `Response/Signature` value (if any)||
|verification of `Response/Signature` certificate (if any) against IdP metadata||
|verification of `Issuer`||
|verification of `Destination`||
|parsing of `NameID`||
|**LogoutResponse generation (for third-party-initiated logout):**||
|generation of LogoutResponse XML||
|HTTP-Redirect binding||
|HTTP-POST binding||
|PartialLogout customization||
|**AttributeQuery generation (2.2.2.1):**||
|generation of AttributeQuery XML||
|SOAP binding (client)||

|<img src="https://github.com/italia/spid-graphics/blob/master/spid-logos/spid-logo-c-lb.png?raw=true" width="100" /><br />_Compliance with [SPID regulations](http://www.agid.gov.it/sites/default/files/circolari/spid-regole_tecniche_v1.pdf) (for Attribute Authorities)_||
|:---|:---|
|**Metadata:**||
|parsing of SP XML metadata (1.3.2)||
|AA XML metadata generation (2.2.4)||
|**AttributeQuery parsing (2.2.2.1):**||
|parsing of AttributeQuery XML||
|verification of `Signature` value||
|verification of `Signature` certificate against SP metadata||
|verification of `Issuer`||
|verification of `Destination`||
|parsing of `Subject/NameID`||
|parsing of requested attributes||
|**Response/Assertion generation (2.2.2.2):**||
|generation of `Response/Assertion` XML||
|Signature||
