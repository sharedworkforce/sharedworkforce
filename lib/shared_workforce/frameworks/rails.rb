if defined?(ActionController::Metal)
  class Railtie < Rails::Railtie
    initializer 'shared_workforce' do |app|      
      app.config.middleware.use SharedWorkforce::EndPoint
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