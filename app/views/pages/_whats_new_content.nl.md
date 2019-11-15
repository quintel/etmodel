# Wat is er nieuw in het Energietransitiemodel?


### 1. Gasvraag berekend op uurbasis

De vraag en productie van gas wordt vanaf nu berekend op uurbasis in plaats van op jaarbasis. Hierdoor kunnen gebruikers bekijken op welke momenten in het jaar er gas gebruikt wordt, bijvoorbeeld voor verwarming van huizen of voor elektriciteitsproductie. Ook kunnen gebruikers verkennen hoe dit in de toekomst gaat veranderen en welke impact de weersomstandigheden hebben op de (piek)vraag naar gas.

-> ![](/assets/pages/whats_new/gas_demand_chart_nl.png) <-

-> ![](/assets/pages/whats_new/gas_storage_chart_nl.png) <-

De resultaten zijn te zien in drie nieuwe grafieken over gasvraag, -productie en -opslag. Vind ze door rechtsboven in het model op 'Meer grafieken bekijken' te klikken en te scrollen naar 'netwerkgas'

-> ![](/assets/pages/whats_new/gas_charts_nl.png) <-

### 2. Verken de invloed van extreme weersomstandigheden

Extreme weersomstandigheden, zoals extreme koude/warme periodes en tekorten/overschotten aan zon en wind, kunnen invloed hebben op je scenario. Lage temperaturen kunnen resulteren in een verhoogde warmtevraag. Weinig zon en wind heeft een negatieve invloed op de elektriciteitsproductie. Om deze impact  op je scenario te verkennen, kan een jaar met extreme weersomstandigheden gekozen worden:

- 1987: "Dunkelflaute" tijdens extreem koude winter
- 1997: Energie-misoogst (incl. "Dunkelflaute") en extreem koude dagen
- 2004: Overschotten en tekorten

Deze functionaliteit is alleen beschikbaar voor (regio's in) Nederland.

[Verken hier de effecten van extreme weersomstandigheden!][weather slide]

### 3. CO2-factsheet voor je scenario beschikbaar

Bekijk de CO2-voetafdruk van je scenario vanaf nu onder de resultaten sectie in het ETM. Je kan zowel de voetafdruk van het startjaar als het eindjaar bekijken. Zo kan je gemakkelijk de impact van jouw keuzes op de CO2 uitstoot in jouw regio zien. Deze sheet is printklaar.

[Bekijk hier de factsheet voor je scenario!][factsheet slide]

-> ![](/assets/pages/whats_new/co2_factsheet_nl.png) <-

### 4. Hybride warmte in industrie

Het is nu mogelijk om met elektriciteitsoverschotten warmte te produceren voor de industrie en daarmee de vraag naar gas en waterstof te verminderen. Deze elektrische boilers kunnen worden ingezet naast de baseload elektrische boilers die reeds gemodelleerd waren. Met deze hybride warmte implementatie voorkom je dat de elektrische boilers draaien op elektriciteit geproduceerd door gascentrales aangezien de boilers enkel overschotten gebruiken. Deze modellering wordt per uur gedaan; de resulterende gas- en waterstofvraagprofielen zijn dus afhankelijk van de beschikbare overschotten. Hybride warmte is beschikbaar voor de volgende sectoren: chemische industrie, raffinaderijen, voedingsmiddelenindustrie en papierindustrie.

[Ontdek hier de impact van hybride warmte in de industrie!][hybrid heat slide]

-> ![](/assets/pages/whats_new/hybrid_heat_industry_nl.png) <-

### 5. Hydrogen in industry

It is now also possible to use hydrogen in the other industry sector, next to the energy carriers already present.

[Check out this improvement here!][hydrogen other industry slide]

-> ![](/assets/pages/whats_new/hydrogen_other_industry_en.png) <-


### 6. Biomassamodellering verbeterd

De modellering van biomassa in het ETM is verbeterd in samenwerking met TKI Nieuw Gas, Gasunie, GasTerra en TNO. De inzet van biomassa is eenvoudiger en inzichtelijker gemaakt. Het is nu mogelijk om in één oogopslag te zien welke biomassastromen er in de regio zijn, zowel in het heden als in toekomstscenario's. Daarnaast is ook de **potentie voor verschillende biomassastromen** onderzocht door TNO, waardoor te zien is hoeveel biomassa er voor Nederland en ook per regio beschikbaar is. Een ander belangrijk verbeterpunt is het toevoegen van **superkritische watervergassing (SCW)** en **vergassing van droge biomassa** voor groengas. Alle benodigde data over biomassa en conversietechnieken is aangepast en gedocumenteerd op onze [GitHub][biomass documentation] op basis van onderzoek door TNO.

[Ontdek hier alle verbeteringen rondom de inzet van biomassa in het ETM!][biomass slide]

-> ![](/assets/pages/whats_new/biomass_sankey_nl.png) <-

-> ![](/assets/pages/whats_new/biomass_potential_nl.png) <-

### 7. Nieuwe grootschalige elektriciteitsopslag technologieën toegevoegd

Er zijn twee grootschalige elektriciteitsopslag technologieën toegevoegd aan het ETM: **Ondergrondse Pomp Accumulatie Centrale (OPAC)** en **grootschalige batterijopslag**. Elektriciteitsoverschotten kunnen nu worden opgeslagen in deze technologieën en op een later moment weer worden ingezet. De toekomstige kosten voor deze technologieën zijn door de gebruiker aan te passen.

[Bekijk hier de impact van deze nieuwe opslagtechnologieën op het elektriciteitsnetwerk!][flex slide]

-> ![](/assets/pages/whats_new/new_flex_options_nl.png) <-


[biomass documentation]: https://github.com/quintel/documentation/blob/master/general/biomass.md

[biomass slide]: /scenario/supply/biomass/overview

[flex slide]: /scenario/flexibility/excess_electricity/order-of-flexibility-options

[wind slide]: /scenario/supply/electricity_renewable/wind-turbines

[factsheet slide]: /scenario/data/data_visuals/co-sub-2-sub-footprint

[hybrid heat slide]: /scenario/flexibility/flexibility_conversion/conversion-to-heat-for-industry

[hydrogen other industry slide]: /scenario/demand/industry/other

[weather slide]: /scenario/flexibility/flexibility_weather/extreme-weather-conditions