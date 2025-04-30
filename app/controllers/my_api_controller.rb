require "net/http"

class MyApiController < ApplicationController
  class ArrayCountOver1 < StandardError; end
  def merge_requests_events(project_id, iid)
    uri_merge_requests = URI("https://gitlab.com/api/v4/projects/#{project_id}/merge_requests/#{iid}")
    api_response = api_call(uri_merge_requests)
    open_event = [ {
      iid: api_response["iid"],
      occured_at: api_response["created_at"],
      actor: api_response["author"]["name"],
      event: "OpenedEvent"
    } ]
    uri_resource_state_events = URI("https://gitlab.com/api/v4/projects/#{project_id}/merge_requests/#{iid}/resource_state_events")
    api_response_events = api_call(uri_resource_state_events)

    if api_response_events.count > 1
      raise ArrayCountOver1
    elsif api_response_events.count == 1
      api_response_events.map do |el|
        open_event.push(
        {
          iid: api_response["iid"],
          occured_at: el["created_at"],
          actor: el["user"]["name"],
          event: el["state"].camelize + "Event"
        })
      end
    end
  end

  def save_events(project_id, iid)
   events = merge_requests_events(project_id, iid)
   flat_events = events.flatten
   for event in flat_events do
    if event[:event] == "OpenedEvent"
      MergeRequest.create(
        idd: event[:iid],
        actor: event[:actor],
        occured_at: event[:occured_at]
      )
    end
   end
  end

  # def create_merge_request

  # end

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
