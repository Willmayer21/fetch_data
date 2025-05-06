require "test_helper"

class ArrayTest < ActionDispatch::IntegrationTest
  test "test array" do
    jo = ArrayController.new
    array = jo.index
  end
end
