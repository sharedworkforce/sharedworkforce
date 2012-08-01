if defined?(ActionController::Metal)
  class Railtie < Rails::Railtie
    initializer 'shared_workforce' do |app|      
      app.config.middleware.use SharedWorkforce::EndPoint
      app.config.after_initialize do
        if Rails.env.development?
        	if SharedWorkforce.configuration.valid?
            # Stop log buffering when using Foreman in development
            $stdout.sync = true
            SharedWorkforce::ResponsePoller.start
          else
            puts 'Shared Workforce: API key not configured.'
          end
        end
      end
    end
  end
end