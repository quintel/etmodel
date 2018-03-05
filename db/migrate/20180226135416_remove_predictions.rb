class RemovePredictions < ActiveRecord::Migration[5.1]
  def up
    drop_table :prediction_values
    drop_table :prediction_measures
    drop_table :predictions
  end

  def down
    create_table "prediction_measures" do |t|
      t.integer "prediction_id"
      t.string "name"
      t.integer "impact"
      t.integer "cost"
      t.integer "year_start"
      t.string "actor"
      t.text "description"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer "year_end"
      t.index ["prediction_id"], name: "index_prediction_measures_on_prediction_id"
    end

    create_table "prediction_values" do |t|
      t.integer "prediction_id"
      t.float "value", limit: 24
      t.integer "year"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.index ["prediction_id"], name: "index_prediction_values_on_prediction_id"
      t.index ["year"], name: "index_prediction_values_on_year"
    end

    create_table "predictions" do |t|
      t.integer "input_element_id"
      t.integer "user_id"
      t.boolean "expert"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text "description"
      t.string "title"
      t.string "area"
      t.index ["area"], name: "index_predictions_on_area"
      t.index ["input_element_id"], name: "index_predictions_on_input_element_id"
      t.index ["user_id"], name: "index_predictions_on_user_id"
    end
  end
end
