if defined?(ActionController::Metal)
  class Railtie < Rails::Railtie
    initializer :load_hci do |app|
      Hci::Client.load_path = Rails.root + Hci::Client.load_path
      Hci::Client.load!
    end
  end
else
  Rails.configuration.after_initialize do
    Hci::Client.load_path = Rails.root + Hci::Client.load_path
    Hci::Client.load!
  end
end