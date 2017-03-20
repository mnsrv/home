require 'test_helper'

class HallControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get hall_index_url
    assert_response :success
  end

end
