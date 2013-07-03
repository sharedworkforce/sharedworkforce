module SharedWorkforce
  class EndPoint

    def initialize(app = nil)
      @app = app
    end

    def call(env)
      if env["PATH_INFO"] =~ %r{^/#{callback_path}}
        process_response(Rack::Request.new(env).body.rewind.read)
      else
        @app.call(env) if @app.respond_to? :call
      end
    end

    def process_response(body)
      body = JSON.parse(body)
      SharedWorkforce.logger.info "Processing Shared Workforce task callback"
      SharedWorkforce.logger.info { body.inspect }
      
      raise SecurityTransgression unless valid_api_key?(body['api_key'])
      
      SharedWorkforce::TaskResult.new(body).process!
    
      [ 200,
        { "Content-Type"   => "text/html",
          "Content-Length" => "0" },
        [""]  
      ]
    end
    
    def callback_path
      SharedWorkforce.configuration.callback_path
    end

    private

    def valid_api_key?(key)
      key == SharedWorkforce.configuration.api_key
    end

  end
end