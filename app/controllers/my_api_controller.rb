require "net/http"

class MyApiController < ApplicationController
  class ArrayCountOver1 < StandardError; end
  def merge_requests_events(project_id, iid)
    uri_merge_requests = URI("https://gitlab.com/api/v4/projects/#{project_id}/merge_requests/#{iid}")
    api_response = api_call(uri_merge_requests)
    open_event = []
    open_event.push(
      {
        iid: api_response["iid"],
        occured_at: api_response["created_at"],
        actor: api_response["author"]["name"],
        event: "OpenedEvent",
        state: "Open"
      })
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
          event: el["state"].camelize + "Event",
          state: el["state"]
        })
      end
    end

    open_event
  end

  def save_events(project_id, iid)
   events = merge_requests_events(project_id, iid)

    # 1)for example 1 (69360696, 1) I get an array in a array [[xxx]] event tho
    # open event in merge_request_events is a normal array
    flat_events = events.flatten

   # in used flatten to remove a [] layer an use the array in the for loop
   # it works and I am able to create the mr and the event here under
   for event in flat_events do
    if event[:event] == "OpenedEvent"
      create_mr(event)
      mr = find_merge_request(event)
      create_event(event, mr)
    elsif event[:event] == "ClosedEvent" || event[:event] == "MergedEvent"
      mr = update_mr(event)
      create_event(event, mr)
    end
   end
  end

  # my problem is that when I go to the second example (69360696, 2)
  # and binding.pry under events = merge_requests_events(project_id, iid) here above
  # I get that events is nil event tho open array in merge_request_event is normal
  # I did not check is event exist yet but will do asap. I hope I make sense

  def update_mr(event)
    mr = find_merge_request(event)
    mr.update({ state: event[:state] })
    mr
  end

  def create_mr(event)
    MergeRequest.create(
      iid: event[:iid],
      actor: event[:actor],
      occured_at: event[:occured_at],
      state: "mr open"
    )
  end

  def create_event(event, mr)
    Event.create(
      merge_request_id: mr.id,
      event_type: event[:event],
      actor: event[:actor],
      iid: event[:iid],
      occured_at: event[:occured_at]
    )
  end

  def find_event(event)
    MergeRequest.find_by({ iid: event[:iid], occured_at: event[:occured_at] })
  end

  def find_merge_request(event)
    MergeRequest.find_by({ iid: event[:iid] })
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
