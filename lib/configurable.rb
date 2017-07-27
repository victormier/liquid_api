module LiquidApiUtils
  module Configurable
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    class Configuration
      attr_accessor :default_host

      def initialize
        @default_host = 'localhost'
      end
    end
  end
end
