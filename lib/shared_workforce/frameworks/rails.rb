if defined?(ActionController::Metal)
  class Railtie < Rails::Railtie
    initializer 'shared_workforce' do |app|      
      app.config.middleware.use SharedWorkforce::EndPoint
      SharedWorkforce::ResponsePoller.start if Rails.env.development?
    end
  end
end