class CreateSurveys < ActiveRecord::Migration[6.0]
  def change
    create_table :surveys do |t|
      t.references :user, foreign_key: true

      # Answers
      t.string  :background, limit: 256
      t.integer :how_often
      t.string  :typical_tasks, limit: 8192
      t.integer :how_easy
      t.integer :how_useful
      t.string  :feedback, limit: 8192

      t.timestamps
    end
  end
end
