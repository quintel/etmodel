class AddNewMeritOrderCsvLinks < ActiveRecord::Migration[5.2]
  def up
    slide.update!(
      description_attributes: {
        content_en: <<-TXT.strip_heredoc,
          The merit order ranks power plants according to their marginal costs.
          Based on the hourly demand, the ETM calculates which power plants are
          dispatched each hour. Combined with the marginal costs of these
          plants, the ETM calculates the hourly electricity price. The ETM
          assumes that this price is equal to the marginal costs of the most
          expensive plant running.

          <br/><br/>

          The price curve for your scenario, as well as the load curves for all power plants, can be downloaded following the links below.

          <ul class="data-download merit-data-downloads">
            <li><a href="%{etengine_url}/api/v3/scenarios/%{scenario_id}/curves/merit_order.csv"><span class="fa fa-download"></span> Load curves <span class="filetype">(7MB CSV)</span></a></li>
            <li><a href="%{etengine_url}/api/v3/scenarios/%{scenario_id}/curves/electricity_price.csv"><span class="fa fa-download"></span> Price curve <span class="filetype">(300KB CSV)</span></a></li>
          </ul>

          <div class="data-deprecation">
            <span class="fa fa-info-circle"></span>
            The format of the load and price curves has recently changed. You can
            download copies of this data in the old format below, but note that
            these will be discontinued in April 2020.

            <ul class="data-download merit-data-downloads">
              <li><a href="%{etengine_url}/api/v3/scenarios/%{scenario_id}/merit/loads.csv"><span class="fa fa-download"></span> Load curves (old format) <span class="filetype">(11MB CSV)</span></a></li>
              <li><a href="%{etengine_url}/api/v3/scenarios/%{scenario_id}/merit/price.csv"><span class="fa fa-download"></span> Price curve (old format) <span class="filetype">(158KB CSV)</span></a></li>
            </ul>
          </div>
        TXT
        content_nl: <<-TXT.strip_heredoc,
          De merit order rangschikt de elektriciteitscentrales naar marginale
          kosten. In combinatie met de elektriciteitsvraag op uurbasis, berekent
          het ETM welke centrales zijn ingeschakeld. In combinatie met de
          draaikosten van deze centrales kan het ETM de prijs op uurbasis
          uitrekenen. Het ETM neemt aan dat deze prijs gelijk is aan de kosten
          van de duurste centrale die op dat moment is ingeschakeld.

          <br/><br/>

          De prijscurve voor jouw scenario en de draaiprofielen voor de
          verschillende soorten centrales zijn te downloaden via de links
          hieronder.

          <ul class="data-download merit-data-downloads">
            <li><a href="%{etengine_url}/api/v3/scenarios/%{scenario_id}/curves/merit_order.csv"><span class="fa fa-download"></span> Draaiprofielen <span class="filetype">(7MB CSV)</span></a></li>
            <li><a href="%{etengine_url}/api/v3/scenarios/%{scenario_id}/curves/electricity_price.csv"><span class="fa fa-download"></span> Prijscurve <span class="filetype">(300KB CSV)</span></a></li>
          </ul>


          <div class="data-deprecation">
            <span class="fa fa-info-circle"></span>
            De bestandsindeling van de draaiprofielen en prijscurves is recent veranderd.
            Hieronder kun je de data in het oude format downloaden.
            Let op: De oude bestanden blijven beschikbaar tot april 2020.

            <ul class="data-download merit-data-downloads">
              <li><a href="%{etengine_url}/api/v3/scenarios/%{scenario_id}/merit/loads.csv"><span class="fa fa-download"></span> Draaiprofielen (oud format) <span class="filetype">(11MB CSV)</span></a></li>
              <li><a href="%{etengine_url}/api/v3/scenarios/%{scenario_id}/merit/price.csv"><span class="fa fa-download"></span> Prijscurve (oud format) <span class="filetype">(158KB CSV)</span></a></li>
            </ul>
          </div>
        TXT
      }
    )
  end

  def down
    slide.update!(
      description_attributes: {
        content_en: <<-TXT.strip_heredoc,
        The merit order ranks power plants according to their marginal costs.
        Based on the hourly demand, the ETM calculates which power plants are
        dispatched each hour. Combined with the marginal costs of these plants,
        the ETM calculates the hourly electricity price. The ETM assumes that
        this price is equal to the marginal costs of the most expensive plant
        running.

        <br/><br/>

        The price curve for your scenario, as well as the load curves for all
        power plants, can be downloaded following the links below.

        <ul class="data-download merit-data-downloads">
          <li><a href="%{etengine_url}/api/v3/scenarios/%{scenario_id}/merit/loads.csv"><span class="fa fa-download"></span> Load curves <span class="filetype">(11MB CSV)</span></a></li>
          <li><a href="%{etengine_url}/api/v3/scenarios/%{scenario_id}/merit/price.csv"><span class="fa fa-download"></span> Price curve <span class="filetype">(158KB CSV)</span></a></li>
        </ul>
        TXT
        content_nl: <<-TXT.strip_heredoc,
          De merit order rangschikt de elektriciteitscentrales naar marginale
          kosten. In combinatie met de elektriciteitsvraag op uurbasis, berekent
          het ETM welke centrales zijn ingeschakeld. In combinatie met de
          draaikosten van deze centrales kan het ETM de prijs op uurbasis
          uitrekenen. Het ETM neemt aan dat deze prijs gelijk is aan de kosten
          van de duurste centrale die op dat moment is ingeschakeld.

          <br/><br/>

          De prijscurve voor jouw scenario en de draaiprofielen voor de
          verschillende soorten centrales zijn te downloaden via de links
          hieronder.

          <ul class="data-download merit-data-downloads">
            <li><a href="%{etengine_url}/api/v3/scenarios/%{scenario_id}/merit/loads.csv"><span class="fa fa-download"></span> Draaiprofielen <span class="filetype">(3.8MB CSV)</span></a></li>
            <li><a href="%{etengine_url}/api/v3/scenarios/%{scenario_id}/merit/price.csv"><span class="fa fa-download"></span> Prijscurve <span class="filetype">(158KB CSV)</span></a></li>
          </ul>
        TXT
      }
    )
  end

  private

  def slide
    Slide.find_by(key: 'flexibility_merit_order_merit_order_price')
  end
end
