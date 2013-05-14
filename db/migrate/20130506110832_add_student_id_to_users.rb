class AddStudentIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :student_id, :integer
  end
end
