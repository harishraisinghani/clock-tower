class Api::BaseController < ApplicationController

  skip_before_filter :verify_authenticity_token

  private

  def current_user
    if request.headers[:'x-api-key'] && api_key = ApiKey.find_by(key: request.headers[:'x-api-key'])
      api_key.update_attributes(
        last_accessed: DateTime.now,
        last_ip: request.remote_ip
      )
      @current_user ||= User.find_by(active: true, id: api_key.user_id)
    elsif session[:user_id]
      super
    else
      nil
    end
  end

end
