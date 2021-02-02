module Secured
  def authenticate_user!
    # Bearer xxxxx
    token_regex = /Bearer (\w+)/
    # lear HEADER de auth
    headers = request.headers
    # verificar que sea valido
    if headers['Autorization'].present? && headers['Autorization'].match(token_regex)
      token = headers['Autorization'].match(token_regex)[1]
      # debemos verificar eque el token corresponda a user
      if (Current.user = User.find_by_auth_token(token))
        return
      end
    end

    render json: {error: 'Unauthorized'}, status: :unauthorized
  end
end