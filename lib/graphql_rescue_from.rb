class GraphqlRescueFrom
  def initialize(error_superclass, resolve_func)
    @error_superclass = error_superclass
    @resolve_func = resolve_func
  end

  def call(obj, args, ctx)
    @resolve_func.call(obj, args, ctx)
  rescue @error_superclass => err
    # Your error handling logic here:
    # - return an instance of `GraphQL::ExecutionError`
    # - or, return nil:
    if errors = err.try(:errors)
      raise GraphQL::ExecutionError.new(self.class.full_message_errors(errors))
    else
      nil
    end
  end

  def self.full_message_errors(errors)
    return errors unless errors.respond_to?(:as_json)
    errors.as_json["errors"].map do |k,v|
      v.each.map { |message| "#{k.capitalize.gsub('_', ' ')} #{message}" }.join('. ')
    end.join('; ')
  end
end
