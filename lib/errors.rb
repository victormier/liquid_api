module LiquidApiUtils
  module Errors
    def self.full_messages_array(errors)
      return errors unless errors.respond_to?(:as_json)
      errors.as_json["errors"].map do |k,v|
        v.each.map { |message| "#{k.capitalize.gsub('_', ' ')} #{message}" }
      end.flatten
    end

    class ErrorObject
      attr_reader :errors

      def initialize(errors)
        @errors = errors
      end

      def full_messages
        LiquidApiUtils::Errors.full_messages_array(@errors)
      end
    end
  end
end
