module DeviseAuth
  class Engine < Rails::Engine
    config.to_prepare do
      DeviseAuth.setup
    end
  end
end
