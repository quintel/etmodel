# == Schema Information
#
# Table name: view_nodes
#
#  id             :integer(4)      not null, primary key
#  key            :string(255)
#  element_id     :integer(4)
#  element_type   :string(255)
#  ancestry       :string(255)
#  position       :integer(4)
#  ancestry_depth :integer(4)      default(0)
#  type           :string(255)
#

class ViewNode::Root < ViewNode
  validates :key, :presence   => true,
                  :length     => { :minimum => 1 },
                  :uniqueness => true

  with_options :foreign_key => 'root_node_id' do |node|
    node.has_and_belongs_to_many :constraints,  :join_table => 'constraints_root_nodes'
    node.has_and_belongs_to_many :policy_goals, :join_table => 'policy_goals_root_nodes'
  end


  def tree_to_yml
    # The structure is
    # RootNode
    #   Tab
    #     SidebarItem
    #       Slide
    #         InputElement
    #         OutputElement
    out = {
      :dashboard    => [],
      :tabs         => {},
      :policy_goals => []
    }

    constraints.ordered.each do |c|
      out[:dashboard] << c.key
    end

    policy_goals.each do |c|
      out[:policy_goals] << c.key
    end

    children.each do |tab|
      next unless tab.element
      tab_hash = out[:tabs][tab.element.key] = {
        :sidebar_items => {}
      }

      tab.children.each do |sidebar_item|
        next unless sidebar_item.element
        sidebar_hash = tab_hash[:sidebar_items][sidebar_item.element.key] = {
          :default_chart => nil,
          :slides => {}
        }

        sidebar_item.children.each do |slide|
          next unless slide.element
          sidebar_item_hash = sidebar_hash[:slides][slide.element.key] ||= {
              :input_elements  => [],
              :output_elements => []
            }
          slide.children.each do |input|
            next unless input.element
            if input.element_type == "InputElement"
              sidebar_item_hash[:input_elements] << input.element.key
            else
              sidebar_item_hash[:output_elements] << input.element.key
            end
          end
        end
      end
    end

    out.to_yaml
  end

end
