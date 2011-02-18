module Hci
  class EndPoint

    def initialize(app)
      @app = app
    end

    def call(env)
      puts "Called with #{env.inspect}"
      if env["PATH_INFO"] =~ /^\/#{Client.callback_path}/
        process_request(env)
      else
        @app.call(env)
      end

    end

    private

    def process_request(env)
      req = Rack::Request.new(env)
      params = req.params
    
      Hci::HitResult.new(params).process!
    
      [ 200,
        { "Content-Type"   => "text/html",
          "Content-Length" => "0" },
        [""]  
      ]
    end

  end
end