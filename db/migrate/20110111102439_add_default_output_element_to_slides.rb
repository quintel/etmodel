class AddDefaultOutputElementToSlides < ActiveRecord::Migration
  def self.up
    OutputElementNode.delete_all
    SlideNode.all.each do |slide_node|
      if slide = slide_node.element and slide.default_output_element_id
        output_element = OutputElement.find(slide.default_output_element_id)
        OutputElementNode.create!(:element => output_element, :parent => slide_node)
      end
    end
  end

  def self.down
  end
end
