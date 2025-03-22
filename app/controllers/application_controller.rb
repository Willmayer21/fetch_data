class ApplicationController < ActionController::Base
  def not_found!
    render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
  end
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
end
