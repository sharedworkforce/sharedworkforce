module SharedWorkforce
  class Client
    class << self
      attr_accessor :load_path
      
      def version
        SharedWorkforce::VERSION
      end
    
      def load!
        Dir[File.join(load_path, "*.rb")].each do |file|
          load file
        end
      end
    end
  end
end