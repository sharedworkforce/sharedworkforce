if defined?(ActionController::Metal)
  class Railtie < Rails::Railtie
    initializer :load_hci do |app|
      SharedWorkforce::Client.load_path = Rails.root + SharedWorkforce.configuration.load_path
      SharedWorkforce::Client.load!
    end
  end
else
  Rails.configuration.after_initialize do
    SharedWorkforce::Client.load_path = Rails.root + SharedWorkforce.configuration.load_path
    SharedWorkforce::Client.load!
  end
end