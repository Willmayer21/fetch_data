require "net/http"

class MyApiController < ApplicationController
  class ArrayCountOver1 < StandardError; end

  def merge_request_notes(project_id, iid)
    uri_merge_requests = URI("https://gitlab.com/api/v4/projects/#{project_id}/merge_requests/#{iid}")
    api_response = api_call(uri_merge_requests)
    uri_merge_requests_notes = URI("https://gitlab.com/api/v4/projects/#{project_id}/merge_requests/#{iid}/notes")
    api_response_notes = api_call(uri_merge_requests_notes)
    note_event = []
    api_response_notes.each do |note|
     note_event.push(
      {
        project_id: api_response["project_id"],
        iid: api_response["iid"],
        event: "NoteEvent",
        body: note["body"],
        note_id: note["id"],
        author: note["author"]["name"],
        created_at: note["created_at"]
      }
     )
    end
    note_event
  end

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
        state: "Open",
        project_id: api_response["project_id"]
      })
    uri_resource_state_events = URI("https://gitlab.com/api/v4/projects/#{project_id}/merge_requests/#{iid}/resource_state_events")
    api_response_events = api_call(uri_resource_state_events)

    if api_response_events.count > 1
      raise ArrayCountOver1
    elsif api_response_events.count == 1
      api_response_events.map do |el|
        open_event.push(
        {
          project_id: api_response["project_id"],
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
   notes = merge_request_notes(project_id, iid)
   events.push(notes)
   flat_events = events.flatten
   for event in flat_events do
    return if find_event(event)
    if event[:event] == "OpenedEvent"
      create_mr(event)
      mr = find_merge_request(event)
      create_event(event, mr)
    elsif event[:event] == "ClosedEvent" || event[:event] == "MergedEvent"
      mr = update_mr(event)
      create_event(event, mr)
    elsif event[:event] == "NoteEvent"
      mr = find_merge_request(event)
      note = create_note(event, mr)
      create_note_event(event, mr, note)
    end
   end
  end

  def update_mr(event)
    mr = find_merge_request(event)
    mr.update({ state: event[:state] })
    mr
  end

  def create_note(event, mr)
    Note.create(
      merge_request_id: mr.id,
      project_id: mr.project_id,
      iid: event[:iid],
      event: event[:event],
      body: event[:body],
      author: event[:author],
      occured_at: event[:created_at]
    )
  end

  def create_mr(event)
    MergeRequest.create(
      iid: event[:iid],
      actor: event[:actor],
      occured_at: event[:occured_at],
      state: "mr open",
      project_id: event[:project_id]
    )
  end

  def create_note_event(event, mr, note)
    Event.create(
      note_id: note.id,
      merge_request_id: mr.id,
      project_id: mr.project_id,
      event_type: event[:event],
      actor: event[:actor],
      iid: event[:iid],
      occured_at: event[:occured_at]
    )
  end

  def create_event(event, mr)
    Event.create(
      merge_request_id: mr.id,
      project_id: mr.project_id,
      event_type: event[:event],
      actor: event[:actor],
      iid: event[:iid],
      occured_at: event[:occured_at]
    )
  end

  def find_event(event)
    Event.find_by({ iid: event[:iid], occured_at: event[:occured_at], note_id: event[:note_id] })
  end

  def find_merge_request(event)
    MergeRequest.find_by({ iid: event[:iid], project_id: event[:project_id] })
  end

  def api_call(uri)
    req = Net::HTTP::Get.new(uri)
    req["PRIVATE-TOKEN"] = ENV["GITLAB_TOKEN"]
    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end
    JSON.parse(res.body)
  end

  def sync_merge_request
    data = save_events(params["project_id"], params["iid"])
    render json: data
  end
end
