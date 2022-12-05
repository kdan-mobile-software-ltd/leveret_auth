# Devise Auth

`Devise Auth` is a extension gem which provide various authenticate strategies

## Installation

Add `devise_auth` to your Rails application's `Gemfile`.

```ruby
gem 'devise_auth'
```

And then install the gem.

```bash
$ bundle install
```

## Setup

1. Run `rails g devise_auth:migration` to generate the migration file, you may also need to adjust some settings yourself.

2. You need configure the essential settings in initializer.

```ruby
# config/initializer/devise_auth.rb

DeviseAuth.configure do
  devise_for :members # Devise model name

  # Optional to add provider
  #

  # Way 1. configure by json 
  add_provider :ldap, file_path: 'config/ldap_config.json'

  # Way 2. configure by hash
  add_provider :ldap, host: 'localhost', port: '389'...
end
```

## Usage

Dispatch the strategy by OAuth grant_type and provider, it's design base on doorkeeper, so you can just pass the params to `auth_with_doorkeeper`.

```ruby
#config/initializer/doorkeeper.rb 裡用

resource_owner_from_credentials do
  # params: {
  #   client_id: client_secret,
  #   client_secret: client_secret,
  #   grant_type: "password",
  #   email: "test@gmail.com",
  #   password: "testtest"
  #   # provider: "ldap",
  # }
  DeviseAuth.auth_with_doorkeeper(params)
rescue DeviseAuth::Errors::ThirdPartyNotProvideEmail
  # Custom Error 
rescue DeviseAuth::Errors::StrategyNotFound
  # Custom Error
end
```

## Allowed Strategies

|     Name      | Grant Type | Provider | Permitted Attributes |      Description     |
| ------------- | ---------- | -------- | -------------------- | -------------------- |
| LocalStrategy |  `password`  |  `N/A`  | `email` & `password` | database autherciate |
| LdapStrategy  |  `password`  |  `ldap`  | `email` & `password` |   ldap autherciate   |

## Ldap Configuration

```json
{
  "host":"localhost",
  "port":"7389",
  "base":"dc=kdanmobile,dc=com",
  // optional
  "encryption": {
    "method": "simple_tls" // "simple_tls", "start_tls"
    "tls_options": {
      // OpenSSL::SSL::SSLContext Settings
      ...
    }
  },
  "auth":{
    "method": "simple",
    "username": "cn=admin,dc=kdanmobile,dc=com",
    "password": "admin"
  },
  // one of uid and filter must be configured
  "uid": "mail",
  // username will be replaced to email when search
  "filter": "(&(uid=%{username})(memberOf=cn=myapp-users,ou=groups,dc=example,dc=com))"
}
```

## Others

