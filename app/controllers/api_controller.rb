require "net/http"

class ApiController < ApplicationController
class NoValidInput < StandardError; end

  def index
    render json: jo
  end

def fetch_pull_request_event
  # uri = URI("https://gitlab.com/api/v4/projects/69360696/merge_requests/3/resource_state_events")
  uri = URI("https://gitlab.com/api/v4/projects/69360696/merge_requests/3")

  call_result = api_call(uri)

  render json: call_result
end

  def fetch_project
    if params["id"].nil? && params["name"].nil?
      raise NoValidInput
    elsif !params["id"].nil?
      data = fetch_project_name_with_id
    elsif !params["name"].nil?
      data = fetch_project_id_with_name
    end

    if !data.nil? && params["type"] == "pull_request"
      pr = fetch_project_pull_request(data)
    end

    if !pr.nil?
      data = pr
    end

    render json: data
  end


  def fetch_project_pull_request(data)
    uri = URI("https://gitlab.com/api/v4/projects/#{data[:id]}/merge_requests")
    call_result = api_call(uri)
    call_result.map { |el| el["id"] }
    call_result.map do |el|
      { id: el["id"],
        iid: el["iid"],
        title: el["title"],
        state: el["state"],
        project_id: el["project_id"]
      }
    end
  end

  def fetch_project_name_with_id
    id = params["id"]

    uri = URI("https://gitlab.com/api/v4/projects/#{id}")

    call_result = api_call(uri)

    project_details = {
      id: call_result["id"],
      name: call_result["path_with_namespace"]
    }
  end

  def fetch_project_id_with_name
    name = params["name"]
    a, b = name.split("/")

    uri = URI("https://gitlab.com/api/v4/projects/#{a}%2F#{b}")

    call_result = api_call(uri)

    project_details = {
      id: call_result["id"],
      name: call_result["path_with_namespace"]
    }
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
