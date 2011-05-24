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
      a = out[I18n.t(tab.element.key.capitalize)] = {}
      tab.children.each do |sidebar_item|
        b = a[I18n.t("sidebar_item.#{sidebar_item.element.key}")] = {}
        sidebar_item.children.each do |slide|
          c = b[I18n.t("slidetitle.#{slide.element.name}")] = {"sliders" => []}
            slide.children.each do |input|
              if input.element_type == "InputElement"
                c["sliders"] << I18n.t("slider.#{input.element.name}")
              else
                # c["charts"] << input.element.key
              end
            end
        end
      end
    end

    out.to_yaml
  end
end
