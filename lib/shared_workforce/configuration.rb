module SharedWorkforce
  class Configuration
    
    attr_writer :callback_host
    attr_writer :callback_path
    attr_writer :api_key
    attr_writer :logger

    attr_accessor :http_end_point
    attr_accessor :request_class
    
    def initialize
      @http_end_point = "http://api.sharedworkforce.com"
      @request_class = default_request_class
    end
    
    def callback_url
      callback_host.to_s + '/' + callback_path.to_s if callback_host
    end
    
    def callback_path
      @callback_path ||= "shared_workforce/task_response"
    end

    def api_key
      @api_key ||= ENV['SHAREDWORKFORCE_API_KEY']
    end

    def callback_host
      @callback_host ||= ENV['SHAREDWORKFORCE_CALLBACK_HOST']
    end

    def logger
      @logger ||= (rails_logger || default_logger)
    end

    private

    def default_request_class
      if defined?(Rails)
        if Rails.env.development?
          TaskRequest::HttpWithPoller
        elsif Rails.env.test?
          TaskRequest::BlackHole
        else
          TaskRequest::Http
        end
      else
        TaskRequest::Http
      end
    end

    def rails_logger
      (defined?(Rails) && Rails.respond_to?(:logger) && Rails.logger) ||
      (defined?(RAILS_DEFAULT_LOGGER) && RAILS_DEFAULT_LOGGER.respond_to?(:debug) && RAILS_DEFAULT_LOGGER)
    end

    def default_logger
      require 'logger'
      l = ::Logger.new($stdout)
      l.level = ::Logger::INFO
      l
    end
  end
end