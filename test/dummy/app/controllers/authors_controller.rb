class AuthorsController < ApplicationController
  def create
    author_params = params.require(:author).permit(:name)

    author = Author.new(author_params)

    if author.save
      render text: "ok"
    else
      render text: "oops"
    end
  end
end
