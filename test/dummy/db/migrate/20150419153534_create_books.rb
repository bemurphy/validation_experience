class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.string :publishing_year
      t.integer :author_id

      t.timestamps null: false
    end
  end
end
