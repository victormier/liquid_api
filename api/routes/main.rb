class LiquidApi
  include AuthenticationHelpers

  route do |r|
    if LiquidApi.development?
      r.root do
        data = {user_id: User.first.try(:id) || 1}
        token = Rack::JWT::Token.encode(data, ENV['RACK_JWT_SECRET'], 'HS256')
        set_layout_locals token: token
        view("graphiql")
      end
    end

    r.on "graphql" do
      authenticate!

      r.post do
        params = JSON.parse(request.body.read)
        if params["variables"]
          variables = params["variables"].is_a?(Hash) ? params["variables"] : JSON.parse(params["variables"])
        end
        result = Schema.execute(
          params["query"],
          variables: variables
        )

        response['Content-Type'] = 'application/json; charset=utf-8'
        result.to_json
      end
    end

    r.assets
    r.multi_route
  end
end
