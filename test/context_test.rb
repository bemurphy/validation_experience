require 'test_helper'
require 'ostruct'

class ContextTest < ActiveSupport::TestCase
  test "has a set of models to prevent duplicates of same model" do
    context = ValidationExperience::Context.new(:request)

    book1 = Book.new
    book2 = Book.new

    context.models << book1
    context.models << book1
    context.models << book2

    assert_equal 2, context.models.length
    assert context.models.include?(book1)
    assert context.models.include?(book2)
  end

  test "converting to_h" do
    request = OpenStruct.new({
      :referrer   => "http://www.example.com/foo?bar=buzz",
      :params     => {
        :controller => "books",
        :action     => "create"
      }
    })

    context = ValidationExperience::Context.new(request)

    book1 = Book.new(title: "A Title", publishing_year: "1984")
    book1.validate
    context.models << book1

    book2 = Book.new(title: "A Title")
    book2.validate
    context.models << book2

    expected = {
      :referrer   => "http://www.example.com/foo?bar=buzz",
      :controller => "books",
      :action     => "create",
      :models     => [
        {:id=>book1.id, :name=>"Book", :errors=>[], :valid=>true},
        {:id=>nil, :name=>"Book", :errors=>[{:name=>"publishing_year", :message=>"can't be blank", :value=>nil}], :valid=>false}
      ]
    }

    assert_equal expected, context.to_h
  end
end
