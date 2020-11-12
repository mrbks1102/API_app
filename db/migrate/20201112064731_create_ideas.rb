class CreateIdeas < ActiveRecord::Migration[6.0]
  def change
    create_table :ideas do |t|
      t.bigint :category, foreign_key: true, null: false
      t.text :body, null: false

      t.timestamps
    end
  end
end
