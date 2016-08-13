class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.text :body
      t.belongs_to :question, null:false, foreign_key: true, index: true
      t.timestamps null: false
    end
  end
end
