require 'test_helper'

class TransApiControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get trans_api_index_url
    assert_response :success
  end

end
