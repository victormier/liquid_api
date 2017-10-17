module AuthenticationHelpers  
  def authenticated?
    if current_user
      true
    else
      response.status = :unauthorized
      response.write({ "error": "Invalid authentication" }.to_json)
    end
  end

  def current_user
    @current_user ||= begin
      if env["jwt.payload"]["user_id"]
        user = User.find(env["jwt.payload"]["user_id"])
        user.try(:confirmed?) ? user : nil
      else
        nil
      end
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end
end
