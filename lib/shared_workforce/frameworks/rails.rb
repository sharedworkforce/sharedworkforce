if defined?(ActionController::Metal)
  class Railtie < Rails::Railtie
    initializer 'shared_workforce' do |app|      
      app.config.middleware.use SharedWorkforce::EndPoint
      if Rails.env.development?
        # Stop log buffering when using Foreman in development
        $stdout.sync = true
      	if SharedWorkforce.configuration.valid?
          SharedWorkforce::ResponsePoller.start
        else
          puts 'Shared Workforce: API key not configured.'
        end
      end
    end
  end
end