require "test_helper"

class ArrayTest < ActionDispatch::IntegrationTest
  test "diff note outside of review" do
    jo = ArrayController.new
    array = jo.index
  end
end
