module Authorization
  def current_user
    return unless session[:user_id]
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def endpoint_user
    return unless params[:user_id]
    endpoint_user ||= User.find_by(id: params[:user_id])
  end

  def require_current_user
    raise Exceptions::UnauthorizedError unless current_user
  end

  def require_endpoint_user
    raise Exceptions::NotFoundError.new(message: "User:#{params[:user_id]} was not found") unless endpoint_user
  end

  def require_self
    require_current_user
    if params[:user_id] && endpoint_user != current_user
      raise Exceptions::UnauthorizedError
    end
  end

  def require_admin
    require_current_user
    raise Exceptions::UnauthorizedError unless current_user.is_admin?
  end

  def authorize_if_needed
    if params[:user_id]
      require_current_user
      require_endpoint_user
      if current_user != endpoint_user
        raise Exceptions::UnauthorizedError unless current_user.is_friend_of?(params[:user_id])
      end
    end
  end
end
