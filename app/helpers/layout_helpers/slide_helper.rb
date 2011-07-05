module LayoutHelpers::SlideHelper
  def slide_type_in_collection(slide, all_slides)
    case slide
    when all_slides.last
      :last
    when all_slides.first
      :first
    else
      nil
    end
  end
end