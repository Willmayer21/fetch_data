class ApplicationController < ActionController::Base
  def not_found!
    render json: {"error": "400"}
  end
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
end
