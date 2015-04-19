require "test_helper"

class UntackedActionControllerTest < ActionController::TestCase
  tests AuthorsController

  test "creating an author with valid params" do
    @request.env["HTTP_REFERER"] = "http://localhost:3000/authors/new"

    post :create, { author: { name: "John Doe" } }

    assert_equal "ok", response.body
    assert_equal 1, Author.count
    assert_equal 0, ve_reported.length
  end
end
