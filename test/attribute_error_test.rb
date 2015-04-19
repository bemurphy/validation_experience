require 'test_helper'

class AttributeErrorTest < ActiveSupport::TestCase
  test "an error on a non-filtered attribute" do
    error = ValidationExperience::AttributeError.new(:title, "Too short", "Oops")
    expected = { name: "title", message: "Too short", value: "Oops" }
    assert_equal expected, error.to_h
  end

  test "an error on a filtered attribute" do
    error = ValidationExperience::AttributeError.new(:password_confirmation, "Too short", "secret")
    expected = { name: "password_confirmation", message: "Too short", value: "[FILTERED]" }
    assert_equal expected, error.to_h
  end
end
