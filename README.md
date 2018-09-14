# spid-ruby

| Project                | Spid Ruby |
| ---------------------- | ------------ |
| Gem name               | spid |
| License                | [BSD 3](https://github.com/italia/spid-ruby/blob/master/LICENSE) |
| Version                | [![Gem Version](https://badge.fury.io/rb/spid.svg)](http://badge.fury.io/rb/spid) |
| Continuous integration | [![Build Status](https://secure.travis-ci.org/italia/spid-ruby.svg?branch=master)](https://travis-ci.org/italia/spid-ruby) |
| Test coverate          | [![Coverage Status](https://coveralls.io/repos/github/italia/spid-ruby/badge.svg?branch=master)](https://coveralls.io/github/italia/spid-ruby?branch=master) |
| Credits                | [Contributors](https://github.com/italia/spid-ruby/graphs/contributors) |
| Slack Channel          | [![Join the #spid-ruby channel](https://img.shields.io/badge/Slack%20channel-%23spid--ruby-blue.svg?logo=slack)](https://developersitalia.slack.com/messages/C7F1H35L5 ) [![Get invited](https://slack.developers.italia.it/badge.svg)](https://slack.developers.italia.it/) |
| Forum                  | [![SPID on forum.italia.it](https://img.shields.io/badge/Forum-SPID-blue.svg)](https://forum.italia.it/c/spid) |

## Installazione & Configurazione

### Installazione
Aggiungi al tuo Gemfile
```ruby
gem "spid"
```
ed esegui nel terminale
```bash
$ bundle install
```

### Configurazione
A questo punto è necessario aggiungere il middleware `Spid::Rack` nello stack dell'applicazione, avendo cura di inserirlo **dopo** un middleware per la gestione della sessione, ad esempio `Rack::Session::Cookie`

```ruby
use Rack::Session::Cookie
use Spid::Rack
```

E configurare il parametri spid tramite il seguente codice
```ruby
Spid.configure do |config|
  #config ...
end
```
tramite il quale potete accedere alle seguenti configurazioni:

|Nome|valore default||Obbligatorio?|
|:---|:---|:---|:---|
|config.hostname||Hostname dell'applicazione, che verrà utilizzato come entity_id del service provider|✓|
|config.idp_metadata_dir_path||Directory dove si troveranno copia dei metadata degli Identity Provider del sistema SPID|✓|
|config.private_key_pem||Chiave privata del Service Provider in rappresentazione pem|✓|
|config.certificate_pem||Certificato X509 del Service Provider in rappresentazione pem|✓|
|config.attribute_services||Array degli attribute service indexes richiesti dal Service Provider all'Identity Provider (vedi sotto)|✓|
|config.metadata_path|`/spid/metadata`|Path per la fornitura del metadata del Service Provider||
|config.login_path|`/spid/login`|Path per la generazione ed invio dell'AuthnRequest all'Identity Provider||
|config.acs_path|`/spid/sso`|Path per la ricezione dell'Assertion di autenticazione||
|config.logout_path|`/spid/logout`|Path per la generazione ed invio della LogoutRequest all'Identity Provider||
|config.slo_path|`/spid/slo`|Path per la ricezione dell'Assertion di chiusura della sessione||
|config.default_relay_state_path|`/`|Indirizzo di ritorno dopo aver ricevuto un Assertion||
|config.digest_method|Spid::SHA256|Algoritmo utilizzato per la generazione del digest per le firme||
|config.signature_method|Spid::RSA_SHA256|Algoritmo utilizzato per la generazione della signature XML||
|config.acs_binding|Spid::BINDINGS_HTTP_POST|Binding method utilizzato per la ricezione dell'Assertion di autenticazione||
|config.slo_binding|Spid::BINDINGS_HTTP_REDIRECT|Binding method utilizzato ler la ricezione dell'Assertion di chiusura della sessione||
|config.logging_enabled|false|Se true, abilita il logging delle richieste||
|config.logger|Logger.new($stdout)|Indica lo stream dove viene salvato il log delle AuthnRequest e delle Response||

#### Attribute Services
Il protocollo SPID prevede la possibilità di specificare almeno un servizio di attributi. Ogni servizio ha un nome e un elenco di attributi richiesti.

Per configurare dei servizi bisogna utilizzare questa configurazione
```ruby
  Spid.configure do |config|
    ...
    config.attribute_services = [
      { name: "Service 1 name", fields: [ elenco_attributi_servizio_1 ] },
      { name: "Service 2 name", fields: [ elenco_attributi_servizio_2] }
    ]
```
Gli attributi disponibili sono
```
 :spid_code, :name, :family_name, :place_of_birth, :date_of_birth, :gender, :company_name, :registered_office, :fiscal_number, :iva_code, :id_card, :mobile_phone, :email, :address, :digital_address
```
### Scaricamento metadata degli Identity Providers
Per motivi di sicurezza il sistema SPID prevede che un Service Provider abbia una copia 'sicura' dei metadata degli Identity Providers.

Al fine di facilitarne lo scaricamento la gemma `spid-ruby` prevede un task rake che li installa nella directory `config.idp_metadata_dir_path`.

```bash
$ rake spid:fetch_idp_metadata
```

Essendo dei segreti, è sconsigliato salvare i metadata di produzione nel codebase, quindi è preferibile rimandare il task durante la fase di deploy.

Utilizzando [capistrano](https://capistranorb.com/) un modo potrebbe essere:
```ruby
# config/deploy.rb

set :linked_dirs %(
  /path/to/idp_metadata_dir
)

namespace :deploy do
  task :fetch_idp_metadata do
    on roles(:web) do
      execute :rake, "spid:fetch_idp_metadata"
    end
  end
end
```

Se invece state usando [heroku](https://heroku.com) potete usare un buildpack apposito
```bash
$ heroku buildpacks:add  https://github.com/cantierecreativo/spid-ruby-heroku-buildpack.git
```
che lancierà automaticamente il comando durante il deploy. In questo modo i metadata verranno **congelati** nel dyno e saranno sempre disponibili

#### Sinatra
Occorre modificare il `Rakefile` dell'applicazione aggiungendo
```ruby
# qui è necessario caricare preventivamente la configurazione SPID
# require "sinatra-app.rb"
require "spid/tasks"
```

## Nota sulle chiavi OpenSSL
Per generare delle chiavi di test è possibile utilizzare il seguende comando:
```bash
openssl req -x509 -nodes -sha512 -subj '/C=IT' -newkey rsa:4096 -keyout spid-private-key.pem -out spid-certificate.pem
```

La configurazione di `spid-ruby` prevede che venga fornita direttamente la codifica `.pem` del certificato. Questo perché in sistemi quali [Heroku](https://heroku.com) sarebbe necessario avere le chiavi all'interno del repository git, cosa altamente sconsigliata in quanto segreto.

Nel caso di deploy su una macchina personale una possibile soluzione è l'utilizzo di [capistrano](https://capistranorb.com/) in modo che i certificati siano gestiti esternamente dal repository.

Esempio di configurazione:
```ruby
# config/deploy.rb

set :linked_files, %w(
  /path/to/private-key.pem,
  /path/to/certificate.pem
)
```
e nella configurazione
```ruby
Spid.configure do |config|
  config.private_key_pem = File.read("/path/to/private-key.pem")
  config.certificate_pem = File.read("/path/to/certificate.pem")
end
```

## Funzionamento
### Login

Per iniziare un login con SPID è necessario utilizzare un url in questo formato `/spid/login?idp_name=posteid&relay_state=/path/to/return&attribute_index=0`, dove

* **/spid/login**: è il path configurato nel parametro `config.login_path`
* **idp_name**: rappresenta l'identificativo dell'Identity Provider con cui si vuole autenticarsi
* **relay_state**: rappresenta l'url dove deve essere fatto il redirect a seguito della ricezione della response di autenticazione
* **attribute_index**: rappresenta l'indice del servizio di attributi che vogliano vengano forniti dall'Identity Provider in caso di autenticazione riuscita

### Logout
Per iniziare un logout con SPID l'url da utilizzare è `/spid/logout?idp_name=posteid&relay_state=/path/to/return`, dove

* **/spid/logout**: è il path configurato nel parametro `config.logout_path`
* **idp_name**: rappresenta l'identificativo dell'Identity Provider dove vogliamo terminare la sessione di autenticazione
* **relay_state**: rappresenta l'url dove deve essere fatto il redirect a seguito della ricezione della response di logout

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
|verification of `Assertion/Signature` value|✓|
|verification of `Assertion/Signature` certificate against IdP/AA metadata|✓|
|verification of `SubjectConfirmationData/@Recipient`||
|verification of `SubjectConfirmationData/@NotOnOrAfter`||
|verification of `SubjectConfirmationData/@InResponseTo`||
|verification of `Issuer`|✓|
|verification of `Destination`|✓|
|verification of `Conditions/@NotBefore`|✓|
|verification of `Conditions/@NotOnOrAfter`|✓|
|verification of `Audience`|✓|
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
|verification of `Issuer`|✓|
|verification of `Destination`|✓|
|PartialLogout detection||
|**LogoutRequest parsing (for third-party-initiated logout):**||
|parsing of LogoutRequest XML|✓|
|verification of `Response/Signature` value (if any)||
|verification of `Response/Signature` certificate (if any) against IdP metadata||
|verification of `Issuer`|✓|
|verification of `Destination`|✓|
|parsing of `NameID`|✓|
|**LogoutResponse generation (for third-party-initiated logout):**||
|generation of LogoutResponse XML|✓|
|HTTP-Redirect binding||
|HTTP-POST binding|✓|
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

## Testing

Clona il repository
```bash
$ git clone git@github.com:italia/spid-ruby
$ cd spid-ruby
$ bundle install
$ bundle exec rake
 ```

## Contribuire

Chiunque è benvenuto nella community e libero di contribuire al suo sviluppo. Ci aspettiamo che chi contribuisca aderisca al codice di condotta [Contributor Covenant](http://contributor-covenant.org).

Per contribuire al repository

* Forka il progetto
* Crea il tuo feature branch `git checkout -b my-feature-branch`
* Committa le tue modifiche `git commit -a -m "Add some feature"`
* Pusha il tuo branch `git push origin my-feature-branch -u`
* Crea una pull request

Essendo SPID un sistema atto a garatire un sistema di autenticazione certificato con le PA la correttezza del codice deve essere sempre garantita, pertanto ogni pull request che andrà a modificare il codice della libreria dovrà essere corredato degli specifici tests che ne dimostrano la correttezza. Pertanto pull requests senza relativi tests non verranno mergiate.


Nel caso di apertura di una issue relativa ad un bug, siete pregati di fornire o un commit con un test fallimentare o tutti gli step necessari alla riproduzione del bug.


## License

Questa gemma è disponibile in open source sotto i termini della [licenza BSD-3](https://opensource.org/licenses/BSD-3-Clause)

## Code of Conduct

Chiunque interagisca con il codice, l'issue tracker o qualunque altro canale di comunicazione è pregato di rispettare il seguente [codice di condotta](https://github.com/italia/spid-ruby/blob/master/CODE_OF_CONDUCT.md).

## Authors

* [David Librera](https://github.com/davidlibrera) - [Cantiere Creativo <img src="https://www.cantierecreativo.net/images/illustrations/logo-07f378ea.svg"/>](https://www.cantierecreativo.net)
