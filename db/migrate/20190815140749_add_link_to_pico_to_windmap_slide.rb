class AddLinkToPicoToWindmapSlide < ActiveRecord::Migration[5.2]
  def up
    Description.where("content_nl like ?", old_description).take
               .update_attributes(content_nl: new_description)
  end

  def down
    Description.where("content_nl like ?", new_description).take
               .update_attributes(content_nl: old_description)
  end

  def new_description
    'Gebruik de PICO kaartlaag voor windenergie om de potentie voor windmolens '+
    'op land en aan de kust te verkennen. '+
    '<a href="/embeds/pico" data-remote="true">' +
      'Verken de potentie van wind op land en aan de kust.'+
    '</a>'
  end

  def old_description
    'Voor windstroom is veel land- of zeeoppervlak nodig. Hoeveel windstroom '+
    'wil je inzetten?'
  end
end
