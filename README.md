# Devise Auth

`Devise Auth` is an extension gem that provides various authentication strategies

## Prerequisites

- `net-ldap` >= `0.1`
- `devise` >= `4.8.1'`

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
  devise_for :users # Devise model name
  user_default_password '...'

  # Optional to add provider
  #

  # Way 1. configure by json 
  add_provider :ldap, file_path: 'config/ldap_config.json'

  # Way 2. configure by hash
  add_provider :ldap, host: 'localhost', port: '389'...
end
```

3. Add `auth_identitable` to model, example.

```ruby
# app/models/users.rb

devise :database_authenticatable, :registerable, :confirmable,
       ..., :auth_identitable
```

## Usage

Dispatch the strategy by OAuth grant_type and provider, and it's design is base on the gem doorkeeper so that you can pass the params to `auth_with_doorkeeper`.

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

  # retrun member or nil
  DeviseAuth.auth_with_doorkeeper(params)
rescue DeviseAuth::Errors::ThirdPartyNotProvideEmail
  # Custom Error 
rescue DeviseAuth::Errors::StrategyNotFound
  # Custom Error
rescue DeviseAuth::Errors::InvalidCredential
  # Custom Error
end
```

## Allowed Strategies

|     Name      |  Grant Type  | Provider | Permitted Attributes |      Description     |
| ------------- | ------------ | -------- | -------------------- | -------------------- |
| LocalStrategy |  `password`  |  `N/A`   | `email` & `password` | database autherciate |
| LdapStrategy  |  `password`  |  `ldap`  | `email` & `password` |   ldap autherciate   |

## Ldap Configuration

```json
{
  "host":"localhost",
  "port":"7389",
  "base":"dc=example,dc=com",
  // optional
  "encryption": {
    "method": "simple_tls" // "simple_tls", "start_tls"
  },
  "auth":{
    "method": "simple",
    "username": "cn=admin,dc=example,dc=com",
    "password": "admin"
  },
  // Be sure to configure one of uid or filter
  "uid": "mail",
  // username will be replaced with email when searching
  "filter": "(&(uid=%{username})(memberOf=cn=myapp-users,ou=groups,dc=example,dc=com))"
}
```

## Others