class KillPolicyBarCharts < ActiveRecord::Migration
  def up
    t = OutputElementType.find_by_name('policy_bar')
    OutputElement.where(:output_element_type_id => t.id).destroy_all
    t.destroy
  end

  def down
  end
end
