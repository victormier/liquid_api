module LiquidApiUtils
  module Errors
    def self.full_messages_array(errors)
      return errors unless errors.respond_to?(:as_json)
      errors.as_json["errors"].map do |k,v|
        v.each.map { |message| "#{k.capitalize.gsub('_', ' ')} #{message}" }
      end.flatten
    end
  end
end
