module AuthenticationHelpers
  def authenticate!
    unless current_user
      response.status = :unauthorized
      response.finish_with_body({ "error": "Invalid authentication" }.to_json)
    end
  end

  def current_user
    @current_user ||= begin
      env["jwt.payload"]["user_id"] && User.find(env["jwt.payload"]["user_id"])
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end
end
