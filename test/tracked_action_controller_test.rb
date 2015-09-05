require "test_helper"

class TrackedActionControllerTest < ActionController::TestCase
  tests BooksController

  test "creating a book with valid params" do
    @request.env["HTTP_REFERER"] = "http://localhost:3000/books/new"

    post :create, { book: { title: "How to be Anon", publishing_year: "1984" } }

    assert_equal "ok", response.body

    assert_equal 1, Book.count
    assert_equal 1, ve_reported.length

    report = ve_reported[0]

    assert_equal 1, report[:models].length
    assert_equal "http://localhost:3000/books/new", report[:referrer]
    assert_equal "books", report[:controller]
    assert_equal "create", report[:action]
  end

  test "creating a book with invalid params" do
    post :create, { book: { publishing_year: "1984" } }

    assert_equal "oops", response.body

    assert_equal 0, Book.count
    assert_equal 1, ve_reported.length

    report = ve_reported[0]
    assert_equal "books", report[:controller]
    assert_equal "create", report[:action]

    assert_equal [{:id=>nil, :name=>"Book", :errors=>[{
      :name=>"title", :message=>"can't be blank", :value=>nil }],
      :valid=>false}], report[:models]
  end

  test "creating multiple records in a single request" do
    post :bulk_create, {}

    assert_equal "books#bulk_create", response.body

    assert_equal 2, Book.count
    assert_equal 1, ve_reported.length
    assert_equal 2, ve_reported[0][:models].length
  end

  test "the current user can be included in tracking" do
    post :create, { user_id: 13, book: { publishing_year: "1984" } }

    assert_equal 1, ve_reported.length
    assert_equal 13, ve_reported[0][:user][:id]
  end

  test "filter uses around_action options" do
    post :excluded_post, {}
    assert_equal "books#excluded_post", response.body

    assert_equal 1, Book.count
    assert_equal 0, ve_reported.length
  end

  test "skipping GET requests" do
    get :skipped_get

    assert_equal "books#skipped_get", response.body

    assert_equal 1, Book.count
    assert_equal 0, ve_reported.length
  end
end
