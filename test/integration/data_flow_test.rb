require "test_helper"

class DataFlowTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "creation of a merged mr and events" do
    mr_expectation = {
      id: 980190963,
      iid: 1,
      actor: "Will Mayer",
      state: "merged",
      project_id: 69360696
    }
    events_expectation_1 = {
      id: 980190963,
      merge_request_id: 980190963,
      event_type: "OpenedEvent",
      iid: 1,
      actor: "Will Mayer",
      project_id: 69360696
    }
    events_expectation_2 = {
      id: 980190964,
      merge_request_id: 980190963,
      event_type: "MergedEvent",
      iid: 1,
      actor: "Will Mayer",
      project_id: 69360696
    }
    MergeRequest.delete_all
    Event.delete_all
    VCR.use_cassette(method_name) do
      assert_difference("MergeRequest.count", 1) do
        assert_difference("Event.count", 2) do
          jo = MyApiController.new
          events = jo.save_events(69360696, 1)
        end
      end
      binding.pry
      result_mr = MergeRequest.find_by({ iid: 1, project_id: 69360696 })
      result_events = Event.where({ iid: result_mr.iid, project_id: result_mr.project_id })
      assert_record(result_mr, mr_expectation)
      assert_record(result_events[0], events_expectation_1)
      assert_record(result_events[1], events_expectation_2)
    end
  end

  test "creation of a opened mr and event" do
    mr_expectation = {
      id: 980190963,
      iid: 2,
      actor: "Will Mayer",
      state: "mr open",
      project_id: 69360696
    }
    events_expectation_1 = {
      id: 980190963,
      merge_request_id: 980190963,
      event_type: "OpenedEvent",
      iid: 2,
      actor: "Will Mayer",
      project_id: 69360696
    }
    MergeRequest.delete_all
    Event.delete_all
    VCR.use_cassette(method_name) do
      assert_difference("MergeRequest.count", 1) do
        assert_difference("Event.count", 1) do
          jo = MyApiController.new
          events = jo.save_events(69360696, 2)
        end
      end
      binding.pry
      result_mr = MergeRequest.find_by({ iid: 2, project_id: 69360696 })
      result_events = Event.find_by({ iid: result_mr.iid, project_id: result_mr.project_id })
      assert_record(result_mr, mr_expectation)
      assert_record(result_events, events_expectation_1)
    end
  end

  test "creation of a closed mr and events" do
    mr_expectation = {
      id: 980190963,
      iid: 3,
      actor: "Will Mayer",
      state: "closed",
      project_id: 69360696
    }
    events_expectation_1 = {
      id: 980190963,
      merge_request_id: 980190963,
      event_type: "OpenedEvent",
      iid: 3,
      actor: "Will Mayer",
      project_id: 69360696
    }
    events_expectation_2 = {
      id: 980190964,
      merge_request_id: 980190963,
      event_type: "ClosedEvent",
      iid: 3,
      actor: "Will Mayer",
      project_id: 69360696
    }
    MergeRequest.delete_all
    Event.delete_all
    VCR.use_cassette(method_name) do
      assert_difference("MergeRequest.count", 1) do
        assert_difference("Event.count", 2) do
          jo = MyApiController.new
          events = jo.save_events(69360696, 3)
        end
      end
      binding.pry
      result_mr = MergeRequest.find_by({ iid: 3, project_id: 69360696 })
      result_events = Event.where({ iid: result_mr.iid, project_id: result_mr.project_id })
      assert_record(result_mr, mr_expectation)
      assert_record(result_events[0], events_expectation_1)
      assert_record(result_events[1], events_expectation_2)
    end
  end
end
