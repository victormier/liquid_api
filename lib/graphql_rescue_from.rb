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
      errors.as_json
    else
      nil
    end
  end
end
