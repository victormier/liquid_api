module LiquidApiUtils
  module Configurable
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    class Configuration
      attr_accessor :default_client_host
      attr_accessor :default_api_host

      def initialize
        @default_client_host = 'localhost:8080'
        @default_api_host = 'localhost:3000'
      end
    end
  end
end
