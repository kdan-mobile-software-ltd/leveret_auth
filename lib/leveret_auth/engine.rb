module LeveretAuth
  class Engine < Rails::Engine
    config.to_prepare do
      LeveretAuth.setup
    end
  end
end
