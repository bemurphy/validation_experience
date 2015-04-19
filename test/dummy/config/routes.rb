Rails.application.routes.draw do
  post "/authors", to: "authors#create"
  post "/books", to: "books#create"
  post "/bulk_create", to: "books#bulk_create"
  post "/excluded_post", to: "books#excluded_post"
  get "/skipped_get", to: "books#skipped_get"
end
