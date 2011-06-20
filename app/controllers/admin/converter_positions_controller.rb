module Admin
class ConverterPositionsController < BaseController

  def create
    if params[:coordinates]
      params[:coordinates].each do |key,pos|
        x,y = pos
        if bcp = ConverterPosition.find_by_converter_id(key)
          bcp.update_attributes :x => x, :y => y
        else
          ConverterPosition.create :x => x, :y => y, :converter_id => key
        end
      end
    end
    render :text => ''
  end
end
end