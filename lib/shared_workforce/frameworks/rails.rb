if defined?(ActionController::Metal)
  class Railtie < Rails::Railtie
    initializer 'shared_workforce' do |app|      
      app.config.middleware.use SharedWorkforce::EndPoint
      if Rails.env.development?
      	# Stop log buffering when using Foreman in development
        $stdout.sync = true
        SharedWorkforce::ResponsePoller.start
      end
    end
  end
end