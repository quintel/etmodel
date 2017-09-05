class AddColdSnapInputElement < ActiveRecord::Migration[5.0]
  EN_DESCRIPTION = <<-TEXT.strip_heredoc
    In 1987, the Netherlands experienced an exceptional cold snap in the
    second week of January, which significantly increased the demand for space
    heating. This may happen again in the future, and low temperatures may
    negatively affect the ability for air and hybrid heat pumps to satisfy
    demand.

    Enable the &ldquo;cold snap&rdquo; below to use the 1987 heat demand and air
    temperature. When turned off (the default), the ETM will use 2013 demand and
    temperature curves as the basis for your scenario.

    The average temperature in 1987 was 1 <sup>o</sup>C higher than the actual average temperature. To simulate this set the climate slide to -1 []o[]C.
  TEXT

  NL_DESCRIPTION = <<-TEXT.strip_heredoc
    In 1987 was er in Nederland een uitzonderlijk koude periode gedurende de tweede week van januari. 
    Dit zorgde voor een significante toename van de warmtevraag. Een dergelijk koude periode kan in de toekomst weer voorkomen. 
    De vraag is of de opgestelde warmtetechnologieën dan voldoende vermogen zullen hebben om in de warmtevraag te voorzien. 
    Om dat te verkennen kan hieronder een koud jaar worden geselecteerd.

    Voor de standaard warmtevraag- en temperatuurprofielen gebruikt het ETM data uit 2013.
    Selecteer hieronder de &ldquo;cold snap&rdquo; om om de profielen die passen bij het jaar 1987 te gebruiken.

    In 1987 was de gemiddelde temperatuur 1 1 <sup>o</sup>C lager dan in 2013. 
    Dit is te simuleren door bij "klimaat" een temperatuur van -1 <sup>o</sup>C in te stellen.

  TEXT

  def up
    slide = Slide.create!(
      key: :flexibility_flexibility_cold_snap,
      position: 12,
      description_attributes: {
        content_en: paragraphs(EN_DESCRIPTION),
        content_nl: paragraphs(NL_DESCRIPTION)
      },
      sidebar_item: SidebarItem.find_by_key(:electricity_storage),
      output_element: OutputElement.find_by_key(:household_heat_demand_and_production)
    )

    InputElement.create!(
      key: :settings_heat_curve_set,
      slide: slide,
      step_value: 1,
      unit: 'boolean'
    )
  end

  def down
    InputElement.find_by_key(:settings_heat_curve_set).destroy!
    Slide.find_by_key(:flexibility_flexibility_cold_snap).destroy!
  end

  private

  def paragraphs(text)
    text.gsub(/\n([^\n])/, ' \1').strip.split("\n").map do |para|
      "<p>#{ para.strip }</p>"
    end.join("\n\n")
  end
end
