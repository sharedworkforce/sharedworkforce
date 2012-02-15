module SharedWorkforce
  class Client
    class << self
      def version
        SharedWorkforce::VERSION
      end
    end
  end
end