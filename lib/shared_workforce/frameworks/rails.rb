if defined?(ActionController::Metal)
  class Railtie < Rails::Railtie
    initializer 'shared_workforce' do |app|      
      app.config.middleware.use SharedWorkforce::EndPoint
      app.config.after_initialize do
        if Rails.env.development?
        	if SharedWorkforce.configuration.valid?
            # Stop log buffering when using Foreman in development
            $stdout.sync = true
          else
            puts 'Shared Workforce: API key not configured.'
          end
        end
      end
    end

    rake_tasks do
      load "shared_workforce/tasks/collect.rake" if Rails.env.development?
    end
  end
end