class CreateBookUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :book_users do |t|
      t.belongs_to :book, null: false
      t.belongs_to :user, null: false
      t.timestamps
    end
  end
end
