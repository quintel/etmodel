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
    out = {}

    children.each do |tab|
      next unless tab.element
      a = out[tab.element.key] = {}

      tab.children.each do |sidebar_item|
        next unless sidebar_item.element
        b = a[sidebar_item.element.key] = {}

        sidebar_item.children.each do |slide|
          next unless slide.element
          c = b[slide.element.key] = {
            :input_elements  => [],
            :output_elements => []
            }
            slide.children.each do |input|
              next unless input.element
              if input.element_type == "InputElement"
                c[:input_elements] << input.element.key
              else
                c[:output_elements] << input.element.key
              end
            end
        end
      end
    end

    out.to_yaml
  end

end

__END__
