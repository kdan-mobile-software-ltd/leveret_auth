Gem::Specification.new do |s|
  s.name        = 'leveret_auth'
  s.version     = File.read('./VERSION.md')
  s.platform    = Gem::Platform::RUBY
  s.summary     = 'The devise extension for auth strategy'
  s.description = 'auth with different strategy'
  s.authors     = ['ChengChih Chang']
  s.email       = 'cc.chang@kdanmobile.com'

  s.files        = Dir["lib/**/*"]
  s.require_path = ["lib"]
  s.homepage     = "https://github.com/kdan-mobile-software-ltd/leveret_auth"
  s.license      = 'MIT'

  s.required_ruby_version = '>= 2.7.0'
  s.add_runtime_dependency 'net-ldap', '~> 0.1'
  s.add_runtime_dependency 'devise', '~> 4.8.1'

  s.add_development_dependency 'rails', '~> 6.0.3'
  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'rspec', '~> 3.6'
  s.add_development_dependency 'rspec-rails', '~> 4.0'
  s.add_development_dependency 'database_cleaner', '~> 2.0'
end
