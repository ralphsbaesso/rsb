module AuthHelper
  def sign_up(user)
    post '/auth/', params: {
       email: user.email,
       password: user.password,
       password_confirmation: user.password_confirmation
    }
    @auth_tokens = response.headers.slice('client', 'access-token', 'uid')
  end

  def login(user)
    post '/auth/sign_in/', params: { email: user.email, password: user.password }
    response.headers.slice('client', 'access-token', 'uid')
    @auth_tokens = response.headers.slice('client', 'access-token', 'uid')
  end

  def json_body
    @json_body ||= JSON.parse(response.body, symbolize_names: true)
  end

  def json_data
    json_body[:data]
  end

  def json_meta
    json_body[:meta]
  end
end