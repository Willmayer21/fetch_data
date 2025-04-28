require "net/http"

class ApiController < ApplicationController
  def index
    jo = params["source"]
    render json: jo
  end

  def fetch_project_name_with_id
    id = params["id"]

    uri = URI("https://gitlab.com/api/v4/projects/#{id}")

    call_result = api_call(uri)

    project_name = call_result["path_with_namespace"]
    render json: project_name
  end

  def fetch_project_id_with_name
    name = params["name"]
    a, b = name.split("/")

    uri = URI("https://gitlab.com/api/v4/projects/#{a}%2F#{b}")

    call_result = api_call(uri)

    project_id = call_result["id"]
    render json: project_id
  end

  def api_call(uri)
    req = Net::HTTP::Get.new(uri)
    req["PRIVATE-TOKEN"] = ENV["GITLAB_TOKEN"]
    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end
    result = JSON.parse(res.body)
  end
end


# http://localhost:3000/api/fetch?id=69360696
# http://localhost:3000/api/fetch?id=69360696
