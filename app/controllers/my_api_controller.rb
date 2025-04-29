class MyApiController < ApplicationController
  def merge_requests
    uri_merge_requests = URI("https://gitlab.com/api/v4/projects/#{params["project_id"]}/merge_requests/#{params["mr_number"]}")
    api_response = api_call(uri_merge_requests)
    open_event = [ {
      occured_at: api_response["created_at"],
      actor: api_response["author"]["name"],
      event: api_response["state"].camelize + "Event"
    } ]
    uri_resource_state_events = URI("https://gitlab.com/api/v4/projects/#{params["project_id"]}/merge_requests/#{params["mr_number"]}/resource_state_events")
    api_response_events = api_call(uri_resource_state_events)

    if api_response_events.count > 1
    end

    api_response_events.map do |el|
      open_event.push(
      {
        occured_at: el["created_at"],
        actor: el["user"]["name"],
        event: el["state"].camelize + "Event"
      })
    end


    render json: open_event
  end

  def api_call(uri)
    req = Net::HTTP::Get.new(uri)
    req["PRIVATE-TOKEN"] = ENV["GITLAB_TOKEN"]
    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end
    JSON.parse(res.body)
  end
end


# 69360696
