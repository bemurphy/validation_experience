class BooksController < ApplicationController
  include ValidationExperience::Controller

  attr_accessor :current_user

  before_filter do
    if params[:user_id]
      self.current_user = OpenStruct.new(:id => params[:user_id].to_i)
    end
  end

  track_validation_experience except: :excluded_post

  def create
    book_params = params.require(:book).permit(:title, :publishing_year)

    book = Book.new(book_params)

    if book.save
      render text: "ok"
    else
      render text: "oops"
    end
  end

  def bulk_create
    2.times { create_valid }
    render_action
  end

  def excluded_post
    create_valid
    render_action
  end

  def skipped_get
    create_valid
    render_action
  end

  private

  def render_action
    render text: "#{params[:controller]}##{params[:action]}"
  end

  def create_valid
    Book.create!(title: "How to be Anon", publishing_year: "1984")
  end
end
