class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :value
      t.references :voteable, polymorphic: true, index: true
      t.references :user, index: true
      t.timestamps null: false
      t.timestamps null: false
    end
  end
end
