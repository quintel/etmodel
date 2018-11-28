class AddHideResultsTipToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :hide_results_tip, :boolean,
      null: false, default: false, after: :role_id
  end
end
