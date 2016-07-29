class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def email_invalid?(email)
    !(email =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
  end

  def render_200(json)
    respond_to do |format|
      format.json { render json: json, status: 200 }
    end
  end

  def render_error_400
    respond_to do |format|
      format.json do
        render json: { error: 'invalid parameters' }, status: 400
      end
    end
  end

  def render_error_401
    respond_to do |format|
      format.json do
        render json: { error: 'cannot verify user information' }, status: 401
      end
    end
  end
end
