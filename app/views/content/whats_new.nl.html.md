# Wat is er nieuw in het Energietransitiemodel?

___

# Mei 2025

**Nieuwe functies**

* Meerdere verbeteringen zijn gedaan om de rekensnelheid van het model te verhogen, wat bijdraagt aan een betere gebruikerservaring.
* Verbeteringen aan startjaardata van de dataset van Antwerpen zijn geïmplementeerd, gerelateerd aan transport en ruimteverwarming in de gebouwde omgeving. Ga naar de <a href="https://data.energytransitionmodel.com/datasets/BEGM11002" target="_blank">Dataset Manager</a> om de dataset te bekijken.

<details>
  <summary>**Bug fixes**</summary>

  * Hoewel er continu wordt gewerkt aan het verhelpen van issues, zijn er deze maand geen noemenswaardige bug fixes.

</details>

<details>
  <summary>**Technical changelog**</summary>

  * Er zijn geen relevante wijzigingen in inputs.

</details>
</br>

___

# April 2025

## Nieuwe functies

### Lancering stabiele versie #2025-01

De eerste stabiele versie van het ETM is gelanceerd, een belangrijke mijlpaal voor het model. Van oudsher wordt het ETM voortdurend ontwikkeld om de nieuwste functies voor energiesysteemmodellering, bug fixes en updates van datasets beschikbaar te maken. Het nadeel hiervan is dat scenario-instellingen, resultaten en datasetwaardes in de loop van de tijd kunnen veranderen. Met de introductie van de stabiele versie hebben gebruikers nu de keuze om te werken met de traditionele standaardversie, `#latest`, of met de nieuwe stabiele versie, `#2025-01`.

Het overzicht hieronder toont de verschillen tussen `#latest` en `#2025-01`, en laat zien hoe je van omgeving kunt wisselen in het model.

-> <img src="/assets/pages/whats_new/stable-version-release.png" width="800" /> <-

De standaardversie en de stabiele versie van het model zijn momenteel precies hetzelfde, maar aangezien `#latest` in ontwikkeling blijft, zal deze na verloop van tijd gaan divergeren van `#2025-01`. Voor meer informatie over stabiele versies en hoe scenario's naar de stabiele versie verplaatst kunnen worden, zie de <a href="https://docs.energytransitionmodel.com/main/user_manual/model-versions/#move-scenarios-between-versions" target="_blank">documentatie</a>.

<div style="padding: 10px; background-color: #E7F3FF; color: #333; margin-bottom: 15px;">
  <b>Let op</b>: de lancering van de stabiele versie heeft geen invloed op scenario's die voor deze lancering zijn aangemaakt.
</div>

### Overige nieuwe functies

* Het is nu mogelijk een overzicht van alle schuifjesinstellingen van een scenario te downloaden in de sectie
<a href="https://energytransitionmodel.com/scenario/data/data_export/overview-of-slider-settings" target="_blank">Data-export</a>.
* Verbeteringen in de startjaardata gerelateerd aan het eindverbruik in de landbouw voor de gemeente Noordoostpolder. Ga naar de <a href="https://data.energytransitionmodel.com/datasets/GM0171" target="_blank">Dataset Manager</a> om de dataset te bekijken.
* Update van de grafiek "Eindgebruik energie in de Overige sector" waarin de dragers nu zijn uitgesplitst naar energetische en niet-energetische (grondstoffen) vraag.

<details>
  <summary>**Bug fixes**</summary>

  * Er was een bug in de modellering van verliezen bij de behandeling van gewonnen aardgas. Dit resulteerde in een mismatch tussen de modellering van jaarlijkse en uurlijkse aardgasbalancering en in een overschatting van aardgasimport in bepaalde scenario's. Deze bug is nu verholpen.
  * De grafieken <a href="https://collections.energytransitionmodel.com/" target="_blank">Collecties</a> die het eindgebruik van energie "per energiedrager" en "per sector per energiedrager" laten zien, waren niet consistent met elkaar. Dit resulteerde in een verschil tussen deze grafieken in het totale eindgebruik van Vloeibare biobrandstoffen en van Olie en olieproducten. De grafieken zijn nu gestroomlijnd waardoor deze discrepantie is verholpen.
  * De broeikasgasemissies van de Overige sector waren niet opgenomen in de visual <a href="https://energytransitionmodel.com/scenario/data/data_visuals/greenhouse-gas-footprint" target="_blank">Broeikasgas-voetafdruk</a>. Deze zijn hier nu wel in opgenomen onder Industrie, Energie & Overig.
  * In bepaalde omstandigheden veroorzaakte het <a href="https://docs.energytransitionmodel.com/main/battery-forecasting" target="_blank">forecasting-algoritme</a> voor elektriciteitsopslag een incorrecte uurlijkse elektriciteitsprijs wanneer er productiebeperking (curtailment) was. Dit probleem is nu verholpen, de elektriciteitsprijs wordt nu 0 €/MWh in uren dat er productiebeperking optreedt.
  * Het elektriciteitsgebruik door vraagsturing (DSR) in de centrale ICT-sector werd niet meegenomen in alle berekeningen voor finale vraag. Dit probleem is nu opgelost.
  * Het outputvermogen van <a href="https://energytransitionmodel.com/scenario/flexibility/flexibility_storage/large-scale-batteries" target="_blank">grootschalige batterijen</a> (inclusief batterijsystemen gecombineerd met <a href="https://energytransitionmodel.com/scenario/supply/electricity_renewable/wind-turbines" target="_blank">wind op land</a> en <a href="https://energytransitionmodel.com/scenario/supply/electricity_renewable/solar-power" target="_blank">zon PV op land</a>) en <a href="https://energytransitionmodel.com/scenario/flexibility/flexibility_storage/flow-batteries" target="_blank">flowbatterijen</a> is gelijkgesteld aan het inputvermogen, in lijn met andere opslagtechnologieën. Als gevolg hiervan kan het opgestelde outputvermogen van dit type opslagtechnologieën enigszins veranderd zijn in bestaande scenario's.

</details>

<details>
  <summary>**Technical changelog**</summary>

  * Er zijn geen relevante wijzigingen in inputs.
</details>
</br>

___

# Maart 2025

**Nieuwe functies**

* Er worden nu versie-tags gebruikt voor "Opgeslagen scenario's" en "Collecties" in API-responses (in voorbereiding op de release van een stabiele versie van het ETM). Lees meer over de wijzigingen in de API in de <a href="https://docs.energytransitionmodel.com/api/changelog" target="_blank">API changelog</a>.

<details>
  <summary>**Bug fixes**</summary>

  * De <a href="https://energytransitionmodel.com/scenario/flexibility/flexibility_weather/temperature-and-full-load-hours" target="_blank">vollasturenschuifjes</a> voor zon-PV werkten niet altijd correct de vollasturen en productie van zon-PV technologieën bij. Dit is nu verholpen zodat de productie van zon-PV technologieën nu overeenkomt met de ingestelde vollasturen.
  * Het aanpassen van de <a href="https://energytransitionmodel.com/scenario/flexibility/flexibility_weather/temperature-and-full-load-hours" target="_blank">vollasturen</a> resulteerde in inconsistente energiestromen bij de zonnecentrale PV voor H2 en de windturbine op zee voor H2, tussen de componenten voor elektriciteitsproductie en waterstofproductie. Dit is verholpen zodat de stromen tussen deze componenten consistent zijn.
  * Door een bug in de instellingen voor <a href="https://energytransitionmodel.com/scenario/flexibility/flexibility_net_load/curtailment-solar-pv" target="_blank">productiebeperking</a> van zon-PV leidde tot een verkeerde berekening van de piek voor productiebeperking. Deze bug is verholpen, zodat de juiste piek voor productiebeperking wordt getoond. De productie na beperking is onveranderd.
  * Door een bug in de <a href="https://energytransitionmodel.com/scenario/flexibility/flexibility_weather/temperature-and-full-load-hours" target="_blank">weerjarenset</a> (alleen voor Nederlandse regio's) werd de jaarlijkse warmtevraag in huishoudens niet aangepast wanneer een ander weerjaar werd gekozen. Dit is verholpen.
  * Het schuifje voor het uizetten van apparaten in de <a href="https://energytransitionmodel.com/scenario/demand/households/behaviour" target="_blank">Gedrag</a>-sectie van Huishoudens had ook invloed op de energievraag in de sector Gebouwen. Dit is gecorrigeerd zodat het schuifje nu alleen de energievraag voor apparaten in Huishoudens beïnvloedt.
</details>

<details>
  <summary>**Technical changelog**</summary>

  * Er zijn geen relevante wijzigingen in inputs
</details>
</br>

___

# Februari 2025

**Nieuwe functies**

* Nieuwe opzet van de "Mijn Scenario's" en "Mijn Profiel" pagina's
  * Er is een centrale omgeving voor het beheer van opgeslagen scenario's, Collecties en accountinstellingen
  * Gebruik deze omgeving om:
    * Opgeslagen scenario's te beheren en delen
    * Persoonlijke *Access Tokens* te genereren
    * Aan te melden voor de nieuwsbrief
    * Persoonlijke gegevens bij te werken
* De "Transitiepaden" of "Multi Year Charts" tool is hernoemd naar "Collecties"
  * De prefix in de URL is veranderd van `myc` naar `collections`
  * Een "Collectie" is een set van opgeslagen scenario's die samengesteld kan worden in "Mijn Scenario's"
  * Een "Transitiepad" is een type "Collectie", waarin een specifiek opgeslagen scenario geïnterpoleerd is naar tussengelegen jaren
* Nieuwe grafieken zijn toegevoegd aan het grafiekenoverzicht:
  * ‘Elektriciteit vraag en aanbod’
  * ‘Netwerkgas vraag en aanbod’
* Verbeteringen in niet-energetische CO<sub>2</sub>-emissies ter verbetering van een vergelijking tussen 1990, het start- en toekomstjaar:
  * Opsplitsing van niet-energetische en uitgestelde emissies naar afzonderlijke categorieën in de grafiek ‘CO<sub>2</sub>-emissies’
  * Update van de grafiekbeschrijving van grafiek ‘CO<sub>2</sub>-emissies’ met betrekking tot niet-energetische emissies
  * Update van documentatie over niet-energetische emissies in <a href="https://docs.energytransitionmodel.com/main/co2-1990-emissions" target="_blank">1990</a> en deze <a href="https://docs.energytransitionmodel.com/main/co2-overview-per-sector#emissions-per-sector" target="_blank">gemodelleerd in het ETM</a>
* Klimaat- en Energieverkenning (KEV) 2024 als uitegelicht scenario toegevoegd voor eindjaar <a href="https://energytransitionmodel.com/saved_scenarios/18836" target="_blank">2030</a> en <a href="https://energytransitionmodel.com/saved_scenarios/19310" target="_blank">2035</a>
* Verbeteringen in startjaardata voor de gemeente Emmen, met betrekking tot de chemiesector en overige industrie
* Update van dataset Antwerpen naar startjaar 2022
* Verdere verbeteringen aan onze automatische testomgeving die de modelberekeningen controleert

<details>
  <summary>**Bug fixes**</summary>

  * Kleine discrepantie verholpen tussen de berekende uurlijkse en jaarlijkse elektriciteitsstromen voor load shifting in de ICT-sector
  * Ontbrekende technologie hybride luchtwarmtepomp (oliegestookt) toegevoegd aan de grafiek ‘Aantal woningen per ruimteverwarmingstechnologie’
  * Ontbrekend uurlijkse profiel van export van aardgas toegevoegd aan de data-export 'Netwerkgasvraag, -productie en -opslag per uur'
  * Correctie in de stroom van biomassa naar warmte in de grafiek ‘Overzicht energiestromen’ (Sankey) om dubbeltelling van groen gas te voorkomen
  * Herontwerp van de grafiek ‘Netto stroom van raffinageproducten’ om de transformatie van niet-olie energiedragers te visualiseren wanneer er is gekoppeld aan een extern industriemodel
  * Gedrag van externe koppeling voor must-run interconnectoren gecorrigeerd
  * Kleine correctie in luchtvaartemissies van gemeentelijke datasets
  * Fix in Collecties waarmee wordt gecorrigeerd voor een dubbeltelling van groengas in eindgebruik
  * Correctie in grafiek 'Totale broeikasgasemissies (CO2-eq)' waardoor de weergegeven CO2 emissies nu overeenkomen met grafiek 'CO2-emissies'
</details>

<details>
  <summary>**Technical changelog**</summary>

  * <a href="/assets/pages/whats_new/changelog/202502_changelog_inputs.csv" download>202502_changelog_inputs.csv</a>
</details>
</br>

___

# Januari 2025

Nieuwe grafieken zijn toegevoegd voor vraag en aanbod in warmtenetten per temperatuurniveau (HT, MT, LT). Bekijk deze nieuwe grafieken in het grafiekenoverzicht in het ETM. Daarnaast zijn er deze maand diverse bug fixes en verbeteringen gedaan.

-> <img src="/assets/pages/whats_new/mekko_district_heating_nl.png" width="600" /> <-

___

# November 2024

### Toevoegingen en verbeteringen voor Europese landen

De landen Noorwegen, Servië en Zwitserland, evenals Groot-Brittannië, zijn nu beschikbaar in het ETM. Je kunt deze landen bekijken door deze te selecteren in de regio-dropdown bij het starten van een nieuw scenario.

Voor een volledig overzicht van alle gebruikte data, bekijk de **[ETM Dataset Manager](https://data.energytransitionmodel.com/)**. De finale energievraag voor de nieuwe landendatasets is zoveel mogelijk afgestemd op landelijke energiebalansen. Zoals altijd is er ruimte voor toekomstige verbeteringen, met name op het gebied van warmte- en elektriciteitsproductie. Desondanks zijn we erg enthousiast over deze eerste stap in het beschikbaar maken van de nieuwe datsets. Voel je vrij om ons suggesties te sturen via het **[contactformulier](https://energytransitionmodel.com/contact)**.

Daarnaast zijn er verbeteringen doorgevoerd in de verdeling van dragers in finaal energieverbruik van huishoudens voor alle Europese landen die beschikbaar zijn in het ETM, gebaseerd op de **[Eurostat finaal energieverbruik in huishoudens database](https://doi.org/10.2908/NRG_D_HHQ)**. De gehanteerde waarden zijn ook te vinden in de **[ETM Dataset Manager](https://data.energytransitionmodel.com/)**.
Later in november komen we met een update van de woningaantallen en niet-residentiële gebouwaantallen, gebaseerd op cijfers van de **[EU Building Stock Observatory](https://energy.ec.europa.eu/topics/energy-efficiency/energy-efficient-buildings/eu-building-stock-observatory_en)**.

### Toevoeging van waterstof en elektriciteit voor internationaal transport

Waterstof en elektriciteit kunnen nu beide worden gebruikt om de vraag naar internationaal transport te modelleren.
In de **[Internationaal transport](scenario/demand/transport_international_transport/international-transport)** sectie kan je de vraag naar internationaal transport in uw scenario modelleren.
De transportsoorten waaruit je kan kiezen zijn navigatie (per schip) en luchtvaart (per vliegtuig).

-> <img src="/assets/pages/whats_new/nl_whats_new_hy_elec_international.png" width="600" /> <-

---

# Juli 2024

### Update Profielen elektrische voertuigen

De laadprofielensectie van elektrische voertuigen is bijgewerkt!

We hebben zowel de standaardinstellingen voor de profielen als de profielen zelf bijgewerkt met nieuwe gegevens.

Ontdek deze nieuwe update in de sectie **[Vraagsturing - laadgedrag elektrische auto's](scenario/flexibility/flexibility_net_load/demand-response-electric-vehicles)** section.

-> <img src="/assets/pages/whats_new/nl_whats_new_electric_vehicle_profiles.png" width="600" /> <-

### Hybride wind op zee

Het is nu mogelijk de rol van hybride wind op zee in het toekomstige energiesysteem te verkennen. De hybride windturbines op zee kunnen opgewekte stroom aan het HV-netwerk op land of aan een elektrolyser op zee leveren. De elektrolyser op zee kan daarnaast ook stroom van het HV-netwerk ontvangen voor waterstofproductie.

Verken de nieuwe mogelijkheden door geïnstalleerd vermogen van de hybride windturbines op zee in te stellen in de **[Hernieuwbare elektriciteit](scenario/supply/electricity_renewable/wind-turbines)** sectie. Daarnaast kunnen relatieve vermogens van de elektrolyser en bekabeling op zee worden ingesteld in de **[Flexibiliteit](scenario/flexibility/flexibility_net_load/hybrid-offshore-wind-components)** sectie.

Ook zijn er nieuwe grafieken en een tabel toegevoegd die inzicht bieden in de opgestelde vermogens, piekbelasting en jaarlijkse energiestromen van de hybride wind op zee componenten. Onderstaand Sankey-diagram laat bijvoorbeeld zien hoeveel energie jaarlijks tussen de componenten stroomt. Verken de nieuwe gebruikersoutput zelf in het ETM in de lijst met grafieken.

-> <img src="/assets/pages/whats_new/hybrid_offshore_wind_energy_flows.png" width="600" /> <-

### Scenario collecties

Maak een collectie van opgeslagen scenarios en vergelijk de resultaten met elkaar. De nieuwe collecties tab in mijn scenarios bevat zowel collecties als bestaande transitiepaden.

Gebruik de nieuwe knop bovenin de collecties tab om een eerste collectie aan te maken. Een collectie bestaat uit maximaal 6 scenarios de je bezit, of waar iemand je toegang voor heeft gegeven.

-> <img src="/assets/pages/whats_new/collections-button.png" width="600" /> <-

De link naar de collectie kan met iedereen worden gedeeld, maar eenmaal geopend in de viewer, kunnen alleen gebruikers met toegangsrecht de scenario uitkomsten zien.

-> <img src="/assets/pages/whats_new/collections-show.png" width="600" /> <-

Het openen van een collectie opent een nieuwe viewer, waar de uitkomsten met dezelfde grafieken en tabellen kunnen worden vergeleken als men gewend is van de bestaande transitiepaden.

---

# Mei 2024

### Toevoeging van BECCUS

Het ETM bevat nu ook Bio-energie met Koolstofafvang, -gebruik en -opslag (<i>Bioenergy with Carbon Capture and Utilisation Storage</i>, BECCUS) centrales. Er zijn drie belangrijke updates om te bekijken.

Ten eerste zijn biomassacentrales toegevoegd aan het model. Gebruikers kunnen nu vermogen installeren voor biomassacentrales en WKK's die ofwel must-run of regelbaar zijn in de **[Biomassacentrales](scenario/supply/electricity_renewable/biomass-plants)** sectie.

Ten tweede is het mogelijk om CO<sub>2</sub>-emissies van deze elektriciteitscentrales af te vangen, door te bepalen welk deel van het geïnstalleerd vermogen is uitgerust met een CCS-eenheid (<i>Carbon Capture and Storage</i>). Dit kan ingesteld worden in de **[Afvang van CO2 in de energiesector](scenario/emissions/ccus/capture-of-co2-in-energy-sector)** sectie.

-> <img src="/assets/pages/whats_new/net_effect_CO2_nl.png" width="600" /> <-

Ten derde is er in het model een prijs geïntroduceerd voor afgevangen biogene CO<sub>2</sub>. Deze prijs kan worden ingesteld in de **[CCUS](scenario/emissions/other_emissions/overview)** sectie. De opbrengst die kan worden verkregen uit afgevangen biogene CO<sub>2</sub> wordt meegenomen bij het bepalen van de marginale kosten van elektriciteitscentrales of WKK's die draaien op biogene brandstoffen en een CCS-eenheid hebben. Het stelt deze installaties in staat om tegen lagere marginale kosten te draaien. De kosten van alle afgevangen biogene CO<sub>2</sub> worden weergegeven in de kostenoverzichten.


### Waterstofverbeteringen

De waterstofsectie van het model is verbeterd! Met de laatste update zijn flexibele productiemogelijkheden voor waterstof toegevoegd. Stoommethaanreformers, ammoniareformers en autothermische reformers kunnen nu worden geïnstalleerd met regelbaar vermogen bovenop het niet-regelbaar vermogen. Verken deze veranderingen in de **[Waterstofproductie](scenario/supply/hydrogen/hydrogen-production)** sectie.

Naast deze flexibele productiemethodes zijn de opties voor waterstofopslag verfijnd. Gebruikers kunnen nu zoutcavernes en lege gasvelden als opslagopties gebruiken in het model. Bij deze opslagopties kan zowel het volume als het vermogen ingesteld worden. Dit kan gevonden worden in de **[Waterstofoplsag](scenario/supply/hydrogen/hydrogen-production)** sectie.

Samen vormen de regelbare- en opslagproductiefaciliteiten de flexibele waterstofproductieroutes binnen de ETM. Welke productieroute eerst moet worden gebruikt, kan door de gebruiker worden ingesteld via de nieuwe waterstofproductie merit order. Deze merit order kan ingesteld worden in de **[Merit order van regelbare waterstofproductie](scenario/supply/hydrogen/merit-order-of-dispatchable-hydrogen-production)** sectie.

-> <img src="/assets/pages/whats_new/hydrogen_production_order_nl.png" width="500" /> <-

De flexibele vraagopties, die op dit moment bestaan uit de twee waterstofopslagopties, kunnen worden ingesteld via de nieuwe waterstofvraag merit order. Deze merit order kan ingesteld worden in de **[Merit order van regelbare watersofvraag](scenario/supply/hydrogen/merit-order-of-dispatchable-hydrogen-demand)** sectie.

-> <img src="/assets/pages/whats_new/hydrogen_demand_order_nl.png" width="500" /> <-


### Multi-user support en scenario versiegeschiedenis

Het is nu mogelijk om met meerdere gebruikers samen te werken aan een scenario. Via het Mijn Scenario's overzicht kun je andere gebruikers van het ETM uitnodigen voor één van jouw scenario's als <i>Gast</i>, <i>Bewerker</i> of <i>Eigenaar</i>. Je kunt ook personen uitnodigen die het ETM nog niet gebruiken. Afhankelijk van de gegeven rechten kan de genodigde jouw scenario inzien, bewerkingen doen en zelfs andere gebruikers toevoegen aan jouw scenario.

-> <img src="/assets/pages/whats_new/multi_user_nl.png" width="700" /> <-

Ook is er nu een overzicht beschikbaar van de versiegeschiedenis van scenario's. Hierin zijn oude versies van een scenario weergegeven met de gebruiker die deze het laatst heeft aangepast. Je kunt de oude scenarioversies openen in het ETM, een beschrijving aan oude versies toevoegen en oude versies terugzetten.

-> <img src="/assets/pages/whats_new/version_history_nl.png" width="700" /> <-
___

# Maart 2024

### Warmtemodellering gebouwde omgeving is grondig herzien

De gebouwvoorraad wordt nu op een hoger detailniveau uitgesplitst. Woningen worden gedifferentieerd naar combinaties van woningtype en bouwjaarklasse inclusief nieuwbouw. Gebouwen (utiliteit) worden gedifferentieerd naar bestaande bouw en nieuwbouw. Daarnaast kun je als gebruiker nu een prioritering instellen om warmtetechnologieën te verdelen over de woningvoorraad. De gebruiker heeft nu inzicht in de warmtetekorten per gebouwcategorie, kan zelf aan de knoppen zitten om warmtetechnologieën anders te dimensioneren met aanpasbare vermogens en heeft de mogelijkheid om twee verschillende representaties van het thermostaatprofiel in te stellen per combinatie van technologie en gebouwcategorie. Ook kan per gebouwcategorie de ontwikkeling van de warmtevraag ingesteld worden in kWh/m2.

Verken de nieuwe warmtemodellering in de **[Huishoudens](/scenario/demand/households/overview)** en **[Gebouwen](/scenario/demand/buildings/overview)** secties.

-> <img src="/assets/pages/whats_new/residential_heating_demand_nl.png" width="600" /> <-

### Kostenexportfunctionaliteit bijgewerkt en uitgebreid
De kostenexportfunctionaliteit van het ETM heeft een grote update ondergaan! De download biedt nu veel gedetailleerdere informatie over de kosten van een scenario. Beginnend met de totale kosten, de totale CAPEX en de totale OPEX geeft het csv-bestand details over de componenten van CAPEX en OPEX en de parameters die ten grondslag liggen aan CAPEX-berekeningen, zoals de technische levensduur. De kostenexportfunctionaliteit weerspiegelt nu beter welke mogelijkheden het ETM biedt voor kostenberekening.

-> <img src="/assets/pages/whats_new/costs_specification_costs_functionality_en.png" width="600" /> <-

### Zon PV op dak voor huishoudens en gebouwen zijn verhuisd naar Aanbod
De schuifjes voor zon PV op daken van huishoudens en gebouwen zijn aangepast: het opgestelde vermogen van deze technologieën kan nu direct ingesteld worden (in MW). De schuifjes zijn verplaatst naar de sectie **[Hernieuwbare elektriciteit](/scenario/supply/electricity_renewable/solar-power)**.

### Landgebruik van zonne- en windvisualisatie beschikbaar
Het ETM bevat nu een grafiek waarin het landgebruik van zonnepanelen en windturbines op land wordt weergegeven. Als onderdeel van deze grafiek kan de gebruiker ook virtueel onderscheid maken tussen grootschalige en kleinschalige windturbines zonder het feitelijke scenario te beïnvloeden. De bijgevoegde tabel geeft meer gedetailleerde informatie over b.v. capaciteiten en elektriciteitsproductie van alle inbegrepen technologieën.

-> <img src="/assets/pages/whats_new/land_use_of_solar_and_wind_nl.png" width="600" /> <-

### Propaan toegevoegd als bestanddeel van netwerkgas
Gebruikers van de ETM kunnen nu propaan toevoegen als drager in netwerkgas. Toevoeging van propaan kan nodig zijn om de energie-inhoud van netwerkgas te verhogen bij het bijmengen van andere gassen met een lagere calorische waarde, zoals biogas.
___

# Januari 2024

### Lokale prognose voor batterijen van huishoudens

Gebruikers kunnen nu 2 types prognose voor huishoudelijke batterijen kiezen. De eerste is het bestaande systeem prognose algoritme, die voor alle elektrische opslag beschikbaar is. De tweede is het nieuwe lokale algoritme. In plaats van op alle elektriciteitsvraag - en aanbod focust het lokaal prognose algorithme alleen op de huishoud elektricitietsvraag - en aanbod. De algoritmes hebben een andere uitwerking op het elektriciteitsnetwerk. Probeer het zelf in de **[Flexibiliteit](/scenario/flexibility/flexibility_storage/batteries-in-households)** sectie.



-> <img src="/assets/pages/whats_new/residential_forecasting_nl.png" width="600" /> <-

### Input capaciteit van vraagverschuiving

Het modelleren van load shifting voor de industriële sector is uitgebreid. Bij het toepassen van de vraagverschuiving in de industriële sector kunnen gebruikers nu de capaciteit voor het verminderen en verhogen van de belasting op het net afzonderlijk instellen. Deze uitbreiding stelt de gebruiker in staat om de impact van de verhoogde belasting op het net te verminderen. Dit is te vinden in de **[Flexibiliteit](/scenario/flexibility/flexibility_net_load/demand-response-load-shifting-in-industry)** sectie.

-> <img src="/assets/pages/whats_new/input_capacity_dsr_nl.png" width="600" /> <-
___

# December 2023

### Transitstromen

Veel regio's hebben te maken met energiestromen die niet geproduceerd of verbruikt worden binnen het lokale energiesysteem maar alleen worden doorgevoerd naar het achterland. Gebruikers kunnen nu meer inzicht krijgen in deze transitstromen of doorvoerstromen van energiedragers binnen hun systeem. Om transitstromen te modelleren in je scenario, kun je als gebruiker de inflexibele exportvolumes van verschillende energiedragers instellen. Het instellen van zo'n exportstroom dwingt ook een vraag naar import af in je scenario zodat het energiesysteem in balans blijft.

Er zijn nieuwe grafieken toegevoegd die een overzicht geven van de (netto) importstromen, exportstromen en transitstromen in het energiesysteem. Zie de **[Vraag](/scenario/demand/export_energy/introduction)** sectie voor de nieuwe functionaliteiten.

-> <img src="/assets/pages/whats_new/transit_flows_nl.png" width="600" /> <-

Ook is het mogelijk om voor CO<sub>2</sub> een transitstroom te modelleren door een importstroom in Mton in te stellen. Zie de **[Emissies](/scenario/emissions/ccus/capture-and-import-of-co2)** sectie.

-> <img src="/assets/pages/whats_new/co2_import_nl.png" width="600" /> <-

### Nieuwe waterstofdragers

Hiernaast zijn er 2 nieuwe waterstofdragers toegevoegd aan de ETM:

* **Vloeibare organische waterstofdragers (LOHC)** — LOHCs zijn stoffen die waterstof kunnen opslaan en transporteren in vloeibare vorm. Deze vorm biedt een hogere energiedichtheid in vergelijking met gasvormige waterstof.

* **Vloeibare waterstof (LH2)** — Bij extreem lage temperaturen gaat gasvormige waterstof over in vloeibare vorm. In vloeibare vorm is de energiedichtheid per volume-eenheid hoger, wat een voordeel oplevert bij het transport.

Dit maakt het bijvoorbeeld ook mogelijk om vloeibare waterstof te importeren, om te zetten naar waterstofgas en in deze vorm te exporteren naar het achterland. Zie ook de nieuwe LH2 vergassing en LOHC reforming technologieën in **[Aanbod](/scenario/supply/hydrogen/hydrogen-production)**.
___

# November 2023

### Warmte

Het modelleren van warmte voor gebouwen en huishoudens is grondig herzien. De volgende drie hoofdveranderingen zijn doorgevoerd.

### Temperatuurniveaus van warmtenetten

Er worden drie onderscheidingen gemaakt in temperatuurniveaus van warmtenetten in het model: Hoge temperatuur (HT), Medium temperatuur (MT) en Lage temperatuur (LT). Elke temperatuur heeft verschillende warmtebronnen. Voor elk niveau kan de vraag, het aanbod, transport en verliezen ingesteld worden. De kosten van de warmte infrastructuur zijn geüpdatet, waarbij specifieke waardes voor de verschillende temperatuurniveaus zijn gebruikt. Afsluitend zijn grafieken toegevoegd als hulpmiddel voor het zetten van de vraag en het aanbod. Ontdek de nieuwe **[Warmtenetten](/scenario/supply/heat/overview-district-heating)** sectie om meer te weten te komen.

-> <img src="/assets/pages/whats_new/district_heating_sankey_nl.png" width="600" /> <-

### Aquathermie

Extra Aquathermische technologieën voor warmtemodellering zijn toegevoegd aan het ETM.
Aquathermal verwijst naar het gebruik van water voor verwarming en koeling. Er worden drie soorten waterreservoirs in overweging genomen: drinkwater, oppervlaktewater en afvalwater.

Aquathermische technologieën kunnen gebruikt worden voor individuele houshuidens, zowel voor **[Ruimteverwarming & warm water](/scenario/demand/households/space-heating-and-hot-water)** als **[Koeling](/scenario/demand/households/cooling)**. Dit geldt ook voor **[Ruimteverwarming](/scenario/demand/buildings/space-heating)** en **[Koeling](/scenario/demand/buildings/cooling)** in gebouwen. Hiernaast kan aquathermie gebruikt worden in MT & LT warmtenetten. Een grafiek is toegevoegd aan het model zodat de gebruiker de vraag voor aquathermische warmte kan inzien en deze kan vergelijken met het potentieel.


-> <img src="/assets/pages/whats_new/aquathermal_heat_nl.png" width="600" /> <-

### Restwarmte

Het is nu mogelijk om precies de hoeveelheid restwarmte te specificeren die u wilt gebruiken in uw scenario. U kunt vervolgens de vraag naar restwarmte vergelijken met een schatting van het potentieel in een nieuw diagram. De schatting van het potentieel hangt af van de respectieve omvang van de industriële sectoren.

-> <img src="/assets/pages/whats_new/residual_heat_chart_nl.png" width="600" /> <-
___

# Juni 2023

## Aanpasbare specificaties voor technologieën voor elektriciteitsopslag

Twee specificaties van opslagtechnologieën voor elektriciteit kunnen nu worden aangepast in het model. De eerste is de retourefficiëntie. Dit kun je aanpassen in *Kosten & efficiënties* → *Flexibiliteit* → **[Opslag elektriciteit](/scenario/costs/costs_flexibility/electricity-storage)**.

Je kunt daarnaast het relatief opslagvolume van elke technologie aanpassen in *Flexibiliteit* → **[Opslag elektriciteit](/scenario/flexibility/flexibility_storage/batteries-in-households)**. Het relatief opslagvolume geeft aan hoeveel uur een technologie op vol vermogen moet laden om van 0% tot 100% geladen te gaan. Effectief kun je hiermee het totaal opgesteld opslagvolume voor een gegeven opgesteld vermogen instellen.

In de tabel "Specificaties opslagtechnologieën elektriciteit" kun je de specificaties voor de verschillende technologieën eenvoudig vergelijken:

-> <img src="/assets/pages/whats_new/relative_storage_volume_en.png" width="600" /> <-
___

# Maart 2023

## Lokaal vs. Globaal tool is gedeactiveerd

De **Lokaal vs. Globaal** tool is voor onbepaalde tijd gedeactiveerd. De tool stelde je in staat om meerdere scenario's te selecteren en hun gecombineerde resultaten te zien voor een aantal indicatoren. Hoewel de functionaliteit die de tool bood waardevol is, maakte de beperkte reikwijdte van de implementatie het niet langer de moeite waard het te onderhouden.

-> <img src="/assets/pages/whats_new/local_global_button_nl.png" width="300" /> <-

Onze ambitie is om in plaats daarvan verder te bouwen aan de **[Transitiepaden](/multi_year_charts)** tool. Deze tool is recent verder ontwikkeld en biedt veel flexibiliteit voor gebruikers die meerdere scenario's willen visualiseren en wijzigen binnen één interface. De functionaliteit die de Lokaal vs. Globaal tool bood zou in de toekomst in de Transitiepaden tool kunnen worden opgenomen.

-> <img src="/assets/pages/whats_new/transition_path_button_nl.png" width="300" /> <-

Als je vragen hebt over de Lokaal vs. Globaal tool, of suggesties hebt voor de verbetering van de Transitiepaden tool, neem dan **[contact](/contact)** op met Quintel.

___

# Februari 2023

## Nieuwe feature voor technologieën voor elektriciteitsopslag

In de sectie *Flexibiliteit* → **[Opslag elektriciteit](/scenario/flexibility/flexibility_storage/behaviour-of-storage-technologies)** kun je per opslagtechnologie kiezen of je het gedrag wilt laten bepalen door een prognose-algoritme.

De technologieën waarvoor dit prognose-algoritme is ingesteld zullen achtereenvolgens proberen de *[residual load curve](/scenario/flexibility/flexibility_overview/residual-load-curves)* van elektriciteit af te vlakken. De volgorde waarin deze technologieën worden ingezet kan je nu zelf instellen. Dit doe je in de sectie *Flexibiliteit → Opslag elektriciteit* → **[Merit order](/scenario/flexibility/flexibility_forecast_storage_order/forecasting-storage-order)**.

-> ![](/assets/pages/whats_new/forecasting_algorithm_merit_order_nl.png) <-

Ga voor meer informatie naar [onze documentatie](https://docs.energytransitionmodel.com/main/battery-forecasting#merit-order).

___

# Januari 2023

## Single sign-on

Het Energietransitiemodel heeft een nieuw inlogsysteem. Het ETM werkt zoals het altijd heeft gewerkt, maar heeft nu een nieuw jasje voor de inlog- en accountpagina's.

Het nieuwe systeem maakt het mogelijk om scenario's te koppelen aan jouw account, waardoor wordt gegarandeerd dat alleen jij wijzigingen kunt aanbrengen. Net zoals hiervoor zijn scenario's standaard publiekelijk beschikbaar. Hierdoor kunnen andere bezoekers jouw scenario zien en kopiëren, maar niet bewerken. Als je jouw scenario's liever privé houdt, kun je de privacy-instellingen veranderingen in je [account-instellingen](https://engine.energytransitionmodel.com/identity/profile). Privéscenario's kunnen alleen worden bekeken door hun eigenaar: jij.

Daarnaast is het ook mogelijk om per scenario te bepalen of het een privé of publiek toegankelijk is. Dit kun je instellen bij [jouw opgeslagen scenario's](/scenarios). Klik op het scenario dat je wilt veranderen en vervolgens op de "Publiek/Privé" selectie aan de rechterzijde van de pagina.

### API

Gebruikers van [onze API](https://docs.energytransitionmodel.com/api/intro) kunnen ook profiteren van de toegenomen beveiliging die single sign-on met zich meebrengt, door middel van [persoonlijke toegangstokens](https://docs.energytransitionmodel.com/api/authentication). Je kunt [jouw scenario's weergeven](https://docs.energytransitionmodel.com/api/scenarios#listing-your-scenarios) en [scenario's verwijderen](https://docs.energytransitionmodel.com/api/scenarios#deleting-your-scenarios). Daarnaast kun je werken met [opgeslagen scenario's](https://docs.energytransitionmodel.com/api/saved-scenarios) en [transitiepaden](https://docs.energytransitionmodel.com/api/transition-paths).

[Een complete lijst van veranderingen](https://docs.energytransitionmodel.com/api/changelog#10th-january-2023-) is beschikbaar op onze documentatiewebsite.

## WKK's voor lokale warmtevraag uit de landbouw
Het is nu mogelijk om warmte-krachtkoppeling (WKK) te installeren die warmte levert om aan de lokale vraag van de landbouw te voldoen. Je kunt het deel van de warmtevraag dat wordt geleverd door deze lokale WKK's instellen in de sectie *Vraag → Landbouw* → **[Warmte](/scenario/demand/agriculture/heat)**. Het vermogen voor verschillende types WKK's kan vervolgens worden ingesteld in de sectie *Vraag → Landbouw* → **[Warmte van lokale WKK's](scenario/demand/agriculture/heat-from-local-chps)**.

Er zijn twee grafieken toegevoegd, één die de totale vraag en aanbod van lokale warmte weergeeft. De andere grafiek (zie hieronder) toont ook de elektriciteitsstromen die worden geproduceerd door de WKK's.

-> ![](/assets/pages/whats_new/agriculture_sankey_nl.png) <-

## Elektriciteitsopslag in elektrische bussen, bestelbussen en vrachtwagens
Naarmate het aantal elektrische voertuigen toeneemt, wordt het steeds interessanter om de batterijen die aanwezig zijn in die voertuigen nuttig te gebruiken tijdens uren waarop ze niet voor vervoer worden gebruikt. Het was al mogelijk om met batterijen in elektrische auto's opslagdiensten aan het elektriciteitsnet te verlenen. Nu is dit ook mogelijk voor elektrische bussen, bestelbussen en vrachtwagens.

-> ![](/assets/pages/whats_new/electric_vehicles_storage_nl.png) <-

Ga naar de sectie *Flexibiliteit → Opslag elektriciteit* → **[Batterijen in elektrische voertuigen](/scenario/flexibility/flexibility_storage/batteries-in-electric-vehicles)** om te zien hoe je deze batterijen kunt inzetten. Het totale beschikbare batterijopslagvolume hangt af van het aantal elektrische voertuigen in je scenario. Dit kun je bepalen in de sectie *Vraag* → **[Transport](/scenario/demand/transport/overview)**.

## Grafiekensets
In de pop-up "Meer grafieken bekijken" kun je er nu voor kiezen om meerdere grafieken tegelijk te laden. Door op "Systeemoverzicht" te klikken, open je een vooraf bepaalde selectie van grafieken en tabellen die een volledig overzicht geven van jouw energiesysteem.

-> ![](/assets/pages/whats_new/chart_sets_nl.png) <-

Als je een andere grafiekenset wilt toevoegen, neem dan **[contact](/contact)** op met Quintel.

___

# December 2022

## Bio-ethanol voor binnenvaart
Binnenvaartschepen zijn tegenwoordig typisch uitgerust met conventionele dieselmotoren. Er zijn geavanceerde multi-fuelmotoren in ontwikkeling die verscheidene brandstoffen kunnen gebruiken, waaronder ook bio-ethanol. Je kunt het aandeel dieselmotoren instellen bij *Vraag → Vrachtvervoer* → **[Technologie binnenvaartschepen](/scenario/demand/transport_freight_transport/domestic-navigation-technology)**.
Vervolgens kun je bio-ethanol toevoegen door de brandstofmix aan te passen in *Aanbod → Transportbrandstoffen* → **[Binnenlandse scheepvaart](/scenario/supply/transport_fuels/domestic-navigation)**.

-> ![](/assets/pages/whats_new/bio_ethanol_inland_shipping_nl.png) <-

## Waterstofgebruik in het industriële warmtenet
Er zijn twee nieuwe technologieën toegevoegd die stoom kunnen leveren aan het industriële warmtenet. Je kunt nu vermogen installeren voor een waterstofturbine-WKK, die zowel stoom als elektriciteit produceert, en voor een waterstofketel, die alleen stoom produceert. Ga hiervoor naar *Vraag → Industrie* → **[Bronnen stoomnet](/scenario/demand/industry/steam-network-sources)**.

___

# November 2022

## Eerste Aziatische land is nu beschikbaar: Singapore
Singapore is als eerste stadstaat en eerste Aziatische land toegevoegd aan het ETM. Dit betekent dat het nu ook makkelijker is om andere landen van buiten de EU toe te voegen aan het ETM. Selecteer Singapore als regio bij het starten van een nieuw scenario om het energiesysteem te verkennen!

## Toevoeging van ammoniak
Het verschepen van vloeibare ammomiak (om het daarna te reformen naar waterstof) wordt als een meer praktische optie gezien om grote volumes groene waterstof te transporteren, dan om de groene waterstof direct te verschepen. Het is daarom nu mogelijk **[ammoniak import](/scenario/supply/hydrogen/ammonia-production)** in te stellen en dit te converteren naar waterstof door middel van een **[reformer](/scenario/supply/hydrogen/hydrogen-production)**.

Daarnaast is het ook mogelijk om de ammoniak direct te gebruiken in de **[kunstmestindustrie](/scenario/demand/industry/fertilizers)**, of als transportbrandstof in de **[binnenvaart](/scenario/demand/transport_freight_transport/domestic-navigation-technology)** of **[internationale scheepvaart](/scenario/demand/transport_international_transport/international-navigation-technology)**.

-> ![](/assets/pages/whats_new/ammonia_mekko_nl.png) <-

## Toevoeging van Autothermal reforming
Er is een nieuwe waterstofproductietechnologie toegevoegd aan het model: Autothermal reforming (ATR). Dit is een bewezen technologie die aardgas gebruikt om waterstof te produceren. Je kunt het vermogen instellen in *Aanbod → Waterstof* → **[Waterstofproductie](/scenario/supply/hydrogen/hydrogen-production)**.

Het voordeel van ATR ten opzichte van de gebruikelijke waterstofproductietechnologie, Steam methane reforming (SMR), is dat een groter deel van de CO<sub>2</sub>-emissies kunnen worden afgevangen. Je kunt afvang van CO<sub>2</sub> voor de ATR instellen in *Emissies → CCUS* → **[Afvang van CO<sub>2</sub>](/scenario/emissions/ccus/capture-of-co2)**.

## Nieuwe CO2-intensiteit van waterstof grafiek
Er is een nieuwe grafiek waarmee je de CO<sub>2</sub>-intensiteit van verschillende waterstofproductieroutes kunt vergelijken. Je kunt de grafiek openen via de grafiekselectie of door naar *Aanbod → Waterstof* → **[CO<sub>2</sub>-emissies van  geïmporteerde waterstof](/scenario/supply/hydrogen/co2-emissions-of-imported-hydrogen)** te gaan.

-> ![](/assets/pages/whats_new/hydrogen_co2_intensity_nl.png) <-

## Nieuwe elektriciteitsmix voor power-to-gas grafiek
Er is nog een nuttige grafiek toegevoegd. Deze grafiek laat zien welke elektriciteitsmix gebruikt is om waterstof te produceren door middel van elektrolyse (ook bekend als power-to-gas). Je kunt de grafiek openen via de grafiekselectie of door naar *Flexibiliteit → Conversie elektriciteit* → **[Conversie naar waterstof](/scenario/flexibility/flexibility_conversion/conversion-to-hydrogen)** te gaan.

-> ![](/assets/pages/whats_new/electricity_mix_p2g_nl.png) <-

## Analyse van flexibiliteitsbehoefte
Voor de gasvormige dragers waterstof en netwerkgas zorgt opslag voor de balancering van vraag en aanbod op uurbasis. Er zijn echter technische en economische beperkingen aan de mate waarin opslagvolume in een bepaalde regio gerealiseerd kan worden. Dit wordt met name relevant als er verschillende types ondergrondse opslag nodig zijn. Bepaalde vormen van opslag zijn kunnen nodig zijn om variaties in vraag en aanbod op korte termijn op te vangen, terwijl er ook opslag nodig kan zijn om met lange termijn, seizoensvariaties, om te gaan.

Er is een nieuwe sectie en tabel die je kan helpen de behoefte aan verschillende types opslag te evalueren. Je kunt dit vinden in *Flexibiliteit → Overzicht* → **[Flexibiliteitsbehoefte: tijdschalen](/scenario/flexibility/flexibility_overview/the-need-for-flexibility-timescales)**.

___

# Oktober 2022

## Nieuwe transporttechnologieën voor schepen en vliegtuigen
Het is nu mogelijk om voor binnenvaart de overstap te maken naar elektrische schepen. Je kan het aandeel van elektrische schepen in het totale transport door binnenvaart instellen in *Vraag → Transport → Vrachtvervoer* → **[Technologie binnenvaartschepen](/scenario/demand/transport_freight_transport/domestic-navigation-technology)**.

Voor de binnenlandse luchtvaart zijn er twee nieuwe technologieën. Naast kerosine, benzine en bio-ethanol kun je nu gebruik maken van elekriciteit en waterstof. Bekijk het in *Vraag → Transport → Passagiersvervoer* → **[Technologie binnenlandse luchtvaart](/scenario/demand/transport_passenger_transport/domestic-aviation-technology)**.

## Nieuwe verwarmingtechnologieën in de landbouw
Je kunt nu een water warmtepomp installeren in de landbouw. Dit is een elektrische water-water warmtepomp die een waterreservoir heeft als warmtebron. Er is dan nog slechts een beperkte hoeveelheid elektriciteit nodig om het water op de gewenste temperatuur te brengen. Dit maakt de warmtepomp veel efficiënter dan een simpele elektrische boiler. Je kunt de warmtepomp vinden in *Vraag → Landbouw* → **[Warmte](/scenario/demand/agriculture/heat)**.

In dezelfde sectie kun je nu ook vermogen instellen voor power-to-heat voor de landbouw. Dit is een elektrische boiler die wordt geïnstalleerd bij bestaande waterstof- of gasketels, waardoor het hybride ketels worden. De hybride ketels gebruiken elektriciteit als de elektriciteitsprijs lager is dan de maximale betalingsbereidheid, ook wel de *willingness-to-pay*. Als de elektriciteitsprijs te hoog is, zal de ketel weer terugvallen op de oorspronkelijke energiebron (gas of waterstof). Je kunt de betalingsbereidheid instellen in *Flexibiliteit → Conversie elektriciteit* → **[Conversie naar warmte voor landbouw](/scenario/flexibility/flexibility_conversion/conversion-to-heat-for-agriculture)**.

-> ![](/assets/pages/whats_new/agriculture_heating_nl.png) <-

---

# September 2022

## Update van de transitiepaden tool
De transitiepaden tool heeft een grote vernieuwing ondergaan. Met deze tool kun je een scenario openen en verkennen wat er tussen het start- en eindjaar gebeurt. Je kunt gemakkelijk veranderingen aanbrengen aan schuifjesinstellingen van de tussenliggende jaren en daarmee het transitiepad naar de toekomst vormgeven.

Onderdeel van de update is een verbeterde interface, verschillende nieuwe grafieken die zowel als vlak en als staaf weergegeven kunnen worden en een toegevoegde tabel onder de grafieken. Ook is het nu eenvoudig om data te exporteren als CSV-bestand. Bekijk de vernieuwde tool **[hier](https://pro.energytransitionmodel.com/multi_year_charts)**!

-> ![](/assets/pages/whats_new/transition_path_nl.png) <-

## Toevoeging van kleine modulaire kernreactoren
Een nieuwe type kerncentrale is aan het model toegevoegd: kleine modulaire reactoren. Deze nieuwe technologie is nu beschikbaar in aanvulling op de bestaande grote reactoren, de 2e en 3e generatie kerncentrales. Ga naar *Aanbod → Elektriciteit* → **[Kerncentrales](/scenario/supply/electricity/nuclear-plants)** om het aan jouw scenario toe te voegen.

## Vraagverschuiving in de centrale ICT sector
Vraagverschuiving is een vorm van vraagsturing waarbij elektriciteitsverbruikers ervoor kunnen kiezen hun vraag uit te stellen. Tijdens uren waarin de elektriciteitsprijs te hoog wordt bevonden, kunnen deze verbruikers hun vraag verlagen. Zodra de prijs weer daalt kunnen ze vervolgens het opgelopen tekort compenseren door de vraag juist te verhogen.

Deze vorm van vraagsturing was al beschikbaar voor de metaal-, chemische en overige industrie. Het is nu ook beschikbaar voor de **[centrale ICT](/scenario/demand/industry/central-ict)** sector, die bestaat uit datacenters, telecom en overige informatie- en communicatiediensten. Je kunt vraagverschuiving voor de centrale ICT toevoegen onder *Flexibiliteit → Netbelasting* → **[Vraagsturing - vraagverschuiving in industrie](/scenario/flexibility/flexibility_net_load/demand-response-load-shifting-in-industry)**.

___

# Juli 2022

## Waterstofschepen
Schepen die met waterstof worden aangedreven zijn nu beschikbaar als technologie in de transportsector. Waterstof kan worden gebruikt als brandstof voor de binnenvaart. Ga hiervoor naar de sectie *Vraag → Transport* → **[Vrachtvervoer](/scenario/demand/transport_freight_transport/domestic-navigation-technology)**. Daarnaast kan het worden gebruikt als brandstof voor de internationale scheepvaart, wat je in kunt stellen in de sectie *Vraag → Transport* → **[Internationaal transport](/scenario/demand/transport_international_transport/international-navigation-technology)**.


-> ![](/assets/pages/whats_new/hydrogen_shipping_nl.png) <-


## Hybride warmtepompo op waterstof voor gebouwen
In aanvulling op de hybride warmtepomp op gas is het nu ook mogelijk om de gebouwen in jouw scenario te verwarmen met een hybride warmtepomp die gebruik maakt van waterstof. Deze nieuwe verwarmingstechnologie kun je vinden in de sectie *Vraag → Gebouwen* → **[Ruimteverwarming](/scenario/demand/buildings/space-heating)**.

___

# April 2022

## Toevoegingen en verbeteringen voor EU-landen
Met de toevoeging van Cyprus, Estland en Malta zijn nu alle EU-landen beschikbaar in het ETM! Je kunt deze landen bekijken door er eentje te selecteren bij het kiezen van je regio als je een nieuw scenario start.

De basisjaargegevens voor deze landen zijn voornamelijk afkomstig uit de **[Eurostat Energiebalansen 2019](https://ec.europa.eu/eurostat/web/energy/data/energy-balances)** en **[JRC Potencia-tool](https://joint-research-centre.ec.europa.eu/potencia_en)**. Kijk voor een compleet overzicht van alle data die gebruikt wordt op de **[ETM Dataset Manager](https://data.energytransitionmodel.com/)**. De finale energievraag voor deze EU-landen komt zoveel mogelijk overeen met de Eurostat Energiebalansen. De aanbodzijde (warmte- en elektriciteitsproductie) is complexer en voor verbetering vatbaar. Voel je vrij suggesties te doen via het **[Contactformulier](https://energytransitionmodel.com/contact)**.

## Vrachttransport door bestelbussen
In plaats van onderdeel te zijn van de categorie vrachtwagens worden bestelbussen nu als een afzonderlijke categorie getoond in het model. Hierdoor kun je verschillende keuzes maken voor ontwikkelingen in het gebruik en de technologieën van vrachtwagens en bestelbussen in de *Vraag → Transport* → **[Vrachtvervoer](/scenario/demand/transport_freight_transport/applications)** sectie!

-> ![](/assets/pages/whats_new/vans_transport_nl.png) <-

## Verken vraagsturing in de industrie
Je kunt nu het effect van vraagsturing (*Demand Side Response*) voor de industrie op sub-sectorniveau verkennen in de *Flexibiliteit* sectie, onder **[Netbelasting](/scenario/flexibility_storage/behaviour-of-storage-technologies)**.

Vermogen om elektriciteitsvraag te verschuiven kan worden geïnstalleerd voor de metaal-, chemische en overige industrie. In uren dat de elektriciteitsprijs te hoog is zal de sector dan in staat zijn de vraag te verlagen. Het tekort dat in die uren oploopt wordt op een later moment ingehaald, als de elektriciteitsprijs gedaald is, wat kosten bespaart voor de industrie.

-> ![](/assets/pages/whats_new/load_shifting_nl.png) <-

## Kosten: nieuwe grafieken en data-export

Het ETM bevat nieuwe grafieken voor kosten. Deze grafieken tonen duidelijke categorieën. Ook de berekeningsmethode is veranderd. Het ETM berekent nu expliciet CAPEX, OPEX en brandstofkosten. Ga naar **[data-export](https://pro.energytransitionmodel.com/scenario/data/data_export/specifications-annual-costs)** om kostendetails van alle technologieën en energiedragers te exporteren. Meer details over kostenberekeningen in het ETM staan in de **[documentatie](**https://docs.energytransitionmodel.com/main/cost-main-principles)**.

-> ![](/assets/pages/whats_new/costs_nl.png) <-


---

# Januari 2022

## Verken prijsgevoelige elektriciteitsvraag
Eerder kon de inzet van flexibele elektriciteitsvraagtechnologieën bepaald worden door handmatig de volgorde te kiezen waarin deze technologieën gebruik mochten maken van elektriciteit. Dit is nu vervangen door prijs-gevoelig gedrag. Dit betekent dat er een willingness-to-pay ingesteld moet worden voor power-to-gas, power-to-heat en elektriciteitsopslag. Voor export wordt de willingness-to-pay bepaald door de prijzen van de interconnectoren.

Het gedrag van al deze technologieën kan worden bepaald in de *Flexibiliteit* sectie, voor **[Opslag](/scenario/flexibility/flexibility_storage/behaviour-of-storage-technologies)**, **[Conversie](/scenario/flexibility/flexibility_conversion/behaviour-of-conversion-technologies)** en **[Export](/scenario/flexibility/electricity_import_export/electricity-interconnectors)**. Daar zijn ook nieuwe grafieken te vinden die je helpen het gedrag te bepalen. Voor opslag moet er naast een willingness-to-pay ook een willingness-to-accept ingesteld worden. Optioneel is om in plaats van het prijs-gevoelige gedrag een prognose-algoritme in te stellen dat het gedrag van opslag bepaalt.

-> ![](/assets/pages/whats_new/price_sensitive_nl.png) <-

Als het winstgevend is, zullen elektriciteitscentrales nu ook leveren aan deze flexibele vraagtechnologieën. Afhankelijk van de prijzen kan bijvoorbeeld een kerncentrale gebruikt worden om waterstof te produceren door middel van power-to-gas. Dit betekent ook dat elektriciteitscentrales zullen produceren voor export als het winstgevend is.

**Belangrijk:** voor scenario's die voor deze update zijn gemaakt en waarvoor de flexibiliteit merit order handmatig gezet was, is de willigness-to-pay van elke technologie zo aangepast dat deze merit order nagebootst wordt. Let op dat de impact van deze model-update alsnog significant kan zijn voor bestaande scenario's, omdat de prijzen van interconnectoren voor zowel export als import niet zijn aangepast.

## Nieuwe EU landen kunnen worden geselecteerd voor scenario's
Met heel veel trots delen wij mee dat de meeste EU landen vanaf nu in het ETM te vinden zijn. Voor alle landen is (de meest recente) data uit 2019 gebruikt. Ontdek nu de verschillen in het energiesysteem tussen Frankrijk en Hongarije of maak een scenario voor Duitsland.

-> ![](/assets/pages/whats_new/eu_countries-nl.png) <-

## Keuze uit extra staalproductie technologieën

Het Energietransitiemodel is geüpdatet met de laatste inzichten rondom staalproductie. Het model bevat nu de nieuwe productietechnologie Direct Reduction of Iron (DRI), waarbij je kunt kiezen tussen waterstof en aardgas, en verbeteringen in de bestaande productietechnologieën. Deze productietechnologieën kun je vinden in *Aanbod → Industrie* → **[Staal](/scenario/demand/industry/steel)**.

Ook is het nu mogelijk om te bepalen wat er met overgebleven kolengas wordt gedaan met nieuwe schuifjes in *Emissies → CCUS* → **[Kolengas uit hoogovens (staalsector)](/scenario/emissions/ccus/coal-gases-from-blast-furnaces)**. Kolengas kan gebruikt worden voor elektriciteitsproductie of voor transformatie tot grondstof voor de chemische industrie.

-> ![](/assets/pages/whats_new/steel_whats_new_nl.png) <-

## Innovatieve flexibele technologieën
Een aantal innovatieve technologieën zijn toegevoegd aan het ETM en kunnen nu worden verkend. Deze technologieën zijn er allen op gericht de flexibiliteit van het elektriciteitssysteem te verbeteren.

Ten eerste is het mogelijk windmolens of zonnecentrales PV met een geïntegreerd batterijsysteem te installeren. Door het vermogen van de batterij en de capaciteit van de netaansluiting te veranderen kan je het profiel dat aan het net geleverd wordt beïnvloeden. Deze **[Windmolens](/scenario/supply/electricity_renewable/wind-turbines)** en **[Zonnecentrales](/scenario/supply/electricity_renewable/solar-power)** zijn te vinden in de Aanbod sectie.

-> ![](/assets/pages/whats_new/solar_with_battery_nl.png) <-

Ten tweede is een nieuwe vorm van elektriciteitsopslag beschikbaar: flowbatterijen. Het innovatieve aspect van deze batterijen is dat het volume onafhankelijk van het vermogen opgeschaald kan worden, voor relatief lage kosten ten opzichte van andere batterijen. Deze batterijen vind je onder *Flexibiliteit → Opslag elektriciteit* → **[Flowbatterijen](/scenario/flexibility/flexibility_storage/flow-batteries)**.

Ten derde zijn zonnecentrales PV op zee toegevoegd aan het model. Deze centrales drijven in de zee, wat het potentiële installatieoppervlak voor zonne-energie in een land vergroot. Deze centrales zijn te vinden onder *Aanbod → Hernieuwbare elektriciteit* → **[Zonne-energie](/scenario/supply/electricity_renewable/solar-power)**.

-> ![](/assets/pages/whats_new/solar_pv_offshore_nl.png) <-

Tenslotte is een nieuw warmtepompsysteem toegevoegd. Deze warmtepomp ontrekt warmte van hogere temperatuur aan een speciaal type zonnepanelen, PVT-panelen, waardoor deze efficiëntier is dan veel andere warmtepompen. Deze panelen produceren tegelijkertijd ook elektriciteit. Je kunt deze warmtepompen met PVT-panelen installeren onder *Vraag → Huishoudens* → **[Ruimteverwarming & warm water](/scenario/demand/households/space-heating-and-hot-water)**.

---

# Oktober 2021

## Startjaar 2019 nieuwe standaard voor scenario's voor Nederland

In het Energietransitiemodel kan je voor een regio naar keuze het energiesysteem van de toekomst ontwerpen door aanpassingen te maken aan het huidige energiesysteem. Voor Nederland hebben we nu het startjaar, dat het huidige energiesysteem weergeeft, geüpdatet van 2015 naar 2019. Dit betekent dat, als je een nieuw scenario opent voor Nederland, je een weergave ziet van het energiesysteem van 2019, waaronder de hoeveelheid broeikasgasemissies, de elektriciteitsproductie per energiebron, het aandeel duurzame energie etc.

**Belangrijk:** er verandert niets voor scenario's die voor deze update gemaakt zijn en 2015 als startjaar hebben. Je kunt oude scenario's die je hebt opgeslagen nog steeds openen en bewerken onder **["Mijn Scenario's"](/scenarios)**.

De open source energiebalans van Eurostat vormt de basis van deze dataset en wordt aangevuld door verschillende andere databronnen, zoals het CBS. Alle databronnen die we hebben gebruikt om de nieuwe dataset te maken, zijn te vinden in onze documentatie op **[Github](https://github.com/quintel/etdataset-public/tree/master/data/nl/2019)**. Verder hebben we het dataset update-proces verbeterd, wat ook de kwaliteit van de nieuwe Nederlandse dataset en toekomstige datasets verhoogt.

-> ![](/assets/pages/whats_new/co2_emissions_2019_nl.png) <-

---

# September 2021

## Verander de oliemix en voeg bio-olie toe

Het is nu mogelijk om de oliemix te bepalen en bio-olie toe te voegen in huishoudens, gebouwen, industrie en de landbouw. Dit kun je doen in *Aanbod → Biomassa* → **[Mix van olie en olieproducten](/scenario/supply/biomass/mix-of-oil-and-oil-products)**.

-> ![](/assets/pages/whats_new/final_demand_of_oil_nl.png) <-

## Waterstoftreinen

Waterstoftreinen worden gezien als een mogelijkheid om diesel treinen te vervangen. Je kunt nu waterstoftreinen toevoegen aan je scenario door de nieuwe slider te gebruik in *Vraag → Transport → Passagiers vervoer* → **[Technologie passagierstreinen](/scenario/demand/transport_passenger_transport/train-technology)**.

## CCS Afvalverbranding

Afvalverbranding wordt gezien als een hernieuwbare bron maar is nog wel een bron van broeikasgassen. Met de afvang van CO<sub>2</sub> (CCS) kunnen deze emissies voorkomen worden, waardoor afvalverbranding milieuvriendelijker wordt. Je kunt nu CCS toevoegen aan afvalverbranding in *Emissies → CCUS* → **[Capture of CO<sub>2</sub>](/scenario/emissions/ccus/capture-of-co2)**.

## Luchtwarmtepomp gebouwen sector

Luchtwarmtepompen worden gebruikt om gebouwen te voorzien van verwarming of koeling. Hiervoor was het niet mogelijk om luchtwarmtepompen toe te voegen voor gebouwen maar sinds kort kan dat wel met de nieuwe slider in *Vraag → Gebouwen* → **[Ruimteverwarming](/scenario/demand/buildings/space-heating)** & **[Koeling](/scenario/demand/buildings/cooling)**.

---

# Augustus 2021

## Kosten sectie vernieuwd en nieuwe efficiëntie sliders

De 'Kosten' sectie in het ETM is opnieuw gestructureerd en nieuwe sliders zijn toegevoegd die de efficiënties van technologieën beschrijven. Dit betekent dat je nu de efficiëntie van van de meeste technologieën in het ETM kunt aanpassen. Je kunt de nieuwe sliders vinden onder **[Elektriciteit](/scenario/costs/specs_electricity/coal-plants)**, **[Hernieuwbare elektriciteit](/scenario/costs/specs_renewable_electricity/biomass-plants)** en **[Warmte](/scenario/costs_heat/efficiencies-heating-in-houses-and-buildings)**. De 'Kosten' sectie is hernoemd naar 'Kosten en efficiënties'.

-> ![](/assets/pages/whats_new/costs_efficiencies_nl.png) <-

## HR combiketel (waterstof) toegevoegd voor huishoudens en gebouwen

Het is nu mogelijk om HR combiketels op waterstof voor ruimteverwarming en warm water toe te voegen aan je scenario. Ga naar *Vraag → Huishoudens →* **[Ruimteverwarming en warm water](/scenario/demand/households/space-heating-and-hot-water)** om de slider te gebruiken.

-> ![](/assets/pages/whats_new/boiler_hydrogen_nl.png) <-

------------------------------------------------------------------------

# Juni 2021

## Nieuwe Broeikasgassen sectie

Een **[Emissies](/scenario/emissions/other_emissions/overview)** item is toegevoegd aan de zijbalk met daarbinnen de bestaande 'CCUS' sectie en een nieuwe 'Broeikasgassen' sectie. In de nieuwe **[Broeikasgassen](/scenario/emissions/other_emissions/overview)** sectie kun je de uitstoot van non-energetische CO<sub>2</sub> emissies en andere broeikasgassen bekijken en beïnvloeden. Alle energetische CO<sub>2</sub> emissies worden automatisch berekend in het ETM gebaseerd op het energiesysteem. Door het toevoegen van non-energetische CO<sub>2</sub> emissies en andere broeikasgassen in het ETM kun je nu een overzicht krijgen van alle broeikasgassen in jouw gebied.

-> ![](/assets/pages/whats_new/other_emissions_nl.png) <-

## Broeikasgas-voetafdruk update

De emissies die zijn toegevoegd aan de nieuwe broeikasgassen sectie zijn ook toegevoegd aan de **[Broeikasgas-voetafdruk](/regions/nl?time=future&scenario=)**. Dit betekent dat de voetafdruk nu een overzicht geeft van alle emissies in jouw gebied.

-> ![](/assets/pages/whats_new/emissions_footprint_nl) <-

------------------------------------------------------------------------

# Mei 2021

## Regionale brondata beschikbaar in ETM Dataset Manager

Als je een (nieuw) scenario start in het Energietransitiemodel wordt brondata voor het startjaar in het model geladen. Deze data geeft voor het gebied dat je hebt geselecteerd de huidige staat van het energiesysteem weer. Deze huidige staat wordt gebruikt als basis voor het modelleren van jouw toekomstscenario en is uniek voor elk gebied.

Om de transparantie van onze data te vergroten, hebben we een online omgeving ontwikkeld inclusief versiebeheer voor de documentatie van de regionale brondata: de **[ETM Dataset Manager](https://data.energytransitionmodel.com/)**. Deze tool geeft een compleet en gestructureerd overzicht van alle data én bronnen die gebruikt worden voor deze gebieden. Op dit moment kun je vooral gebieden binnen een land openen in de ETM Dataset Manager en nog niet alle landen. Op den duur zullen alle landen beschikbaar komen in de ETM Dataset Manager.

In de ETM hebben we een knop toegevoegd die u direct naar het geselecteerd gebied in de ETM Dataset Manager linkt om de brondata te bekijken. Deze knop is te vinden in **[Resultaten & data → Brondata](/scenario/data/data_sources/present-year-data)**.

-> ![](/assets/pages/whats_new/dataset_manager_nl.jpg) <-

------------------------------------------------------------------------

# April 2021

## Nieuwe grafiek die flexibiliteitsvoorziening laat zien

In onze update van februari 2021 hebben we een aantal grafieken toegevoegd die inzicht geven in de flexibiliteitsbehoefte. De volgende stap is om in die flexibiliteit te voorzien. We hebben daarom een grafiek toevoegd die het geïnstalleerde vermogen van flexibele vraag- en aanbodtechnologieën laat zien, zoals bijvoorbeeld power-to-gas electrolyzers of gascentrales. Het vergelijken van deze vermogens met de maximale overschot- en tekortpieken helpt je te bepalen of je genoeg flexibel vermogen hebt geïnstalleerd om je energiesysteem te balanceren.

-> ![](/assets/pages/whats_new/installed_flexible_capacities_nl.png) <-

Je kunt de grafiek vinden in **[Flexibility → Overview](/scenario/flexibility/flexibility_overview/the-provision-of-flexibility-capacity)**, waar we ook de verhaallijn bij de andere grafieken vernieuwd hebben. We gaan nu in meer detail in op het inflexibele aanbod en vraag en de resiudal load curves.

## Nieuwe grafiek die het opgeslagen elektriciteitsvolume laat zien

Een belangrijke prestatie-indicator voor opslagtechnologieën voor elektriciteit is de mate waarin ze benut worden. We hebben daarom het op- en ontlaadgedrag van deze technologieën gevisualiseerd in een nieuwe grafiek, die het opslagen volume per uur laat zien.

Je kunt de grafiek vinden in **[Flexibility → Excess electricity → Storage](/scenario/flexibility/flexibility_storage/electricity-storage)**. Je kan kiezen of je alle opslagtechnologieën op elkaar gestapeld wilt zien, of slechts één tegelijk:

* Batterijen in huishoudens
* Batterijen in elektrische auto's
* Grootschalige batterijopslag
* OPAC
* Stuwmeren (afhankelijk van de geselecteerde regio)

-> ![](/assets/pages/whats_new/hourly_stored_volume_of_electricity_nl.png) <-

------------------------------------------------------------------------

# Februari 2021

## Nieuwe grafieken die de behoefte aan flexibiliteit tonen

Natuurlijke patronen zoals de seizoenen (jaarlijks), veranderingen in het weer (wekelijks), dag en nacht, en ons eigen ritme van opstaan, naar werk gaan, thuiskomen, etc. zorgen ervoor dat zowel de benodigdheid van energie als de beschikbaarheid ervan fluctueert. Flexibiliteit gaat over het balanceren van vraag en aanbod van energie op al deze tijdschalen.

We hebben een nieuwe sectie **[Flexibiliteit → Overzicht](/scenario/flexibility/flexibility_overview/what-is-flexibility)** aan het ETM toegevoegd met vier interactieve grafieken die laten zien hoe vraag en aanbod zich verhouden op verschillende tijdschalen. De grafieken tonen:

* Maandelijkse volumes van vraag en aanbod
* Onbalans in maandelijkse volumes van vraag en aanbod
* Flexibiliteitsbehoefte: volume
* Flexibiliteitsbehoefte: capaciteit

-> ![](/assets/pages/whats_new/monthly_supply_and_demand_volumes_nl.png) <-

Een gedetailleerd overzicht van de wijzigingen staat in onze [documentatie](https://docs.energytransitionmodel.com/main/flexibility).

## Profielen aanpassen

Het ETM rekent vraag en aanbod van gas, elekriciteit, warmte en waterstof uit op uurbasis. Het is nu ook mogelijk om je eigen uurprofielen in het ETM te laden en hiermee te werken in de [Flexibiliteit → Profielen aanpassen](https://pro.energytransitionmodel.com/scenario/flexibility/curve_upload/upload-curves) sectie. Er zijn drie typen uurprofielen die je kunt uploaden:

1. Vraagprofielen (bijv. elektrische bussen, warmte in industrie)
2. Aanbodprofielen (bijv. zon PV, wind op zee)
3. Prijscurves (bijv. voor elektriciteitsinterconnectoren)

De grafiek aan de rechterkant laat alle aanpasbare profielen zien op basis van het keuzemenu onder de grafiek. Als je een eigen profiel upload is dit direct zichtbaar in de grafiek.

![](/assets/pages/whats_new/modify_profiles_nl.png)

*Meer weten? Ga dan naar de [Curves](https://docs.energytransitionmodel.com/main/curves) pagina in de documentatie.*

## Download grafieken als afbeelding

Heb je een grafiek nodig voor in een rapport of wil je hem delen met collega's? Vanaf nu kunnen alle grafieken in het model gedownload worden als hoge-resolutie afbeelding door te klikken op de download-knop net boven de grafiek.

-> ![](/assets/pages/whats_new/chart_as_image_nl.png) <-

------------------------------------------------------------------------

# November 2020

## Afvang, opslag en hergebruik van CO<sub>2</sub> (CCUS)

De afvang, opslag en hergebruik van CO<sub>2</sub> (CCUS, carbon capture, utilisation and storage) is een verzameling technologieën om CO<sub>2</sub> te verminderen die kan worden toegepast op verschillende plekken in het energiesysteem. Het ETM neemt de toepassing van CCUS nu in veel meer detail mee dan voorheen.

Het ETM onderscheidt vier vormen van CO<sub>2</sub>-afvang:

* Afvang in de industrie. Het ETM maakt een onderscheid in de afvangpotenties, kosten en energieverbruiken van verschillende subsectoren.
* Afvang in de elektriciteitssector
* Afvang bij de productie van waterstof ('blauwe' waterstof)
* Direct Air Capture, een technologie om CO<sub>2</sub> direct uit de lucht te halen

![](/assets/pages/whats_new/ccus_supply_demand_mekko.png)

Het ETM onderscheidt vier vormen van CO<sub>2</sub>-gebruik:

* Ondergrondse opslag in lege gas- en olievelden op zee
* Hergebruik van afgevangen CO<sub>2</sub> als grondstof voor synthetische kerosine
* Hergebruik van afgevangen CO<sub>2</sub> als grondstof voor synthetische methanol
* 'Overig' hergebruik, bijvoorbeeld voor de productie van frisdrank of in kassen

![](/assets/pages/whats_new/co2-sankey-en.png)

Het ETM onderscheidt twee vormen van CO<sub>2</sub>-transport:

* Via pijpleidingen
* Transport van vloeibare CO<sub>2</sub> in schepen

Ontdek deze nieuwe functionaliteiten in de sectie **[Aanbod → CCUS](scenario/emissions/ccus/capture-of-co2)**! Een gedetailleerd overzicht van de wijzigingen staat in onze [documentatie](https://docs.energytransitionmodel.com/main/co2-ccus) (Engelstalig).

## Negatieve emissies

Het ETM kan nu rekenen met zogeheten 'negatieve' CO<sub>2</sub> emissies. Deze emissies kunnen 'ontstaan' wanneer CO<sub>2</sub>-afvang wordt toegepast bij processen die biomassa gebruiken en wanneer CO<sub>2</sub> direct uit de lucht wordt gehaald door middel van Direct Air Capture. Bekijk ook onze [documentatie](https://docs.energytransitionmodel.com/main/co2-negative-emissions).

![](/assets/pages/whats_new/co2-negative-emissions.png)

## Scenario navigatie bar

Een nieuwe 'scenario navigatie bar' is toegevoegd dat de regio en eindjaar laat zien van jouw scenario. De naam van je scenario is ook zichtbaar wanneer je een opgeslagen scenario opent waardoor het makkelijker wordt om meerdere scenario's te openen in verschillende browser tabs. Via de "Scenario opslaan" knop aan de rechterkant kun je snel je scenario opslaan. Het is nu makkelijker om al je opgeslagen scenario's te bekijken door naar "Mijn scenario's" te gaan.

![](/assets/pages/whats_new/scenario_navigatie_bar_nl.png)

## Interactie met andere modellen uit de Mondaine Suite mogelijk

Om de complexe uitdaging van de energietransitie beheersbaar te maken, wordt er met verschillende energiemodellen aan de energietransitie gerekend. Om de sterktes van ieder model te benutten, is het noodzakelijk om modellen samen te laten werken. In het kader van het [Mondaine](https://www.mondaine-suite.nl) project is de Energy System Description Language ([ESDL](https://energytransition.github.io/)) ontwikkeld om modellen dezelfde taal te laten 'spreken'. Het biedt de mogelijkheid om informatie over zowel ruimtelijke, technische, economische, sociale en tijdsaspecten van de energietransitie in relatie tot elkaar te beschrijven. Daarmee wordt het mogelijk dat het ene model verder rekent met informatie uit een ander model. Het ETM kan in ESDL beschreven energiesystemen inlezen en op basis hiervan een scenario starten. Jouw bestand wordt omgezet in schuifjesinstellingen - zo kun je in het ETM het toekomstige energiesysteem verkennen en verder werken aan het scenario.

Bekijk de ESDL-importfunctionaliteit [hier](/import_esdl)!

![](/assets/pages/whats_new/mondaine.jpg)

------------------------------------------------------------------------

# Juni 2020

## Meerdere elektrische interconnectoren

Veel landen importeren en exporteren elektriciteit met hun buren via verschillende interconnectoren, en het ETM modelleerde dit eerst met een enkele interconnector. Landen hebben echter vaak meerdere interconnectoren met verschillende buren, elk met hun eigen capaciteit, prijs en beschikbaarheid.

In het ETM is het nu mogelijk om tot wel zes verschillende elektrische interconnectoren te modelleren tussen landen. Per interconnector kan je de capaciteit, CO2 uitstoot en (uurlijkse) prijs instellen. De gebruiker kan met een knop beslissen of er alleen overschotten kunnen worden geëxporteerd of dat ook dispatchable centrales elektriciteit kunnen produceren voor export. Op deze manier kan je all elektriciteitsstromen tussen landen realistisch modelleren. Een overzicht van al deze stromen is te zien in een nieuwe grafiek.

Ontdek deze nieuwe functionaliteit bij **[Flexibiliteit → Import/Export](/scenario/flexibility/electricity_import_export/electricity-interconnector-1)**!

![](/assets/pages/whats_new/electricity_sankey_nl.png)

## Warmtevraagprofielen voor gebouwen en landbouw temperatuursafhankelijk

De uurlijkse vraagcurves in de gebouwensector en landbouw zijn temperatuursafhankelijk gemaakt. Hierdoor veranderen de curves mee als de gebruiker een ander weerjaar selecteert. Voorheen gebruikte het ETM een statisch grootverbruikersprofiel voor de gebouwensector en een vlak profiel voor de landbouw. Nu gebruiken beide sectoren hetzelfde grootverbruikersprofiel, dat dynamisch is gegenereerd aan de hand van weerdata. Dit profiel is hierdoor ook beschikbaar voor de historische weerjaren 1987, 1997 en 2004, waardoor de warmtevraag in gebouwen en landbouw, net als bij huishoudens, meebeweegt met de buitentemperatuur.

Bekijk de impact van het weerjaar op de vraagprofielen bij **[Flexibiliteit → Weersomstandigheden](/scenario/flexibility/flexibility_weather/temperature-and-full-load-hours)**!

![](/assets/pages/whats_new/weather_years_buildings_heating_nl.png)

## Impact van buitentemperatuur op energievraag

De impact van een hogere of lagere gemiddelde buitentemperatuur is tegen het licht gehouden. Het veranderen van de buitentemperatuur heeft nu, naast huishoudens en gebouwen, ook invloed op de warmtevraag van landbouw. Daarnaast is de impact op de warmtevraag in deze drie sectoren een stuk groter dan voorheen. De impact van temperatuur op warmtevraag is afgeleid uit de 'graaddagenformule' die gehanteerd wordt door GTS. Bekijk onze [documentatiepagina](https://docs.energytransitionmodel.com/main/outdoor-temperature) voor meer informatie. Deze verbetering is relevant voor zowel de temperatuurschuif in de weerjarensectie van het ETM als het selecteren van een specifiek weerjaar.

Ga naar **[Flexibiliteit → Weersomstandigheden](/scenario/flexibility/flexibility_weather/temperature-and-full-load-hours)** om de verbetering te bekijken!

![](/assets/pages/whats_new/outdoor_temperature_nl.png)

------------------------------------------------------------------------

# Maart 2020

## Beperk de productie van zonnepanelen

Als er veel zonnepanelen geïnstalleerd zijn, kan dit resulteren in hoge pieken op het elektriciteitsnetwerk. Daarom is het wenselijk de productie te kunnen verlagen. In sommige gevallen is het slim om zonneparken aan te sluiten op slechts een bepaald percentage van het piekvermogen. In het ETM is het nu mogelijk om het percentage productiebeperking in te stellen voor verschillende types zonnepanelen.

Ontdek de productiebeperking van zonnepanelen bij **[Flexibiliteit → Netbelasting](/scenario/flexibility/flexibility_net_load/curtailment-solar-pv)**!

![](/assets/pages/whats_new/curtailment_solar_pv_nl.png)

## Zet elektriciteitsoverschotten om in warmte voor warmtenetten

Het is nu mogelijk om elektriciteitsoverschotten van zon en wind om te zetten in warmte voor warmtenetten. Dit kan middels een power-to-heat (P2H) elektrische boiler en een P2H warmtepomp die alleen warmte produceren als er overschotten zijn. De geproduceerde warmte kan direct worden ingezet of worden opgeslagen voor een later moment. Zo kun je bijvoorbeeld overschotten van wind en zon gebruiken om 's winters huizen mee te verwarmen.

Bekijk de P2H schuifjes voor warmtenetten bij **[Flexibiliteit → Elektriciteitsoverschotten → Conversie](/scenario/flexibility/flexibility_conversion/conversion-to-heat-for-district-heating)**!

![](/assets/pages/whats_new/p2h_seasonal_storage_nl.png)

## Bekijk het schakelgedrag van hybride warmtepompen

De efficiëntie van (hybride) warmtepompen is afhankelijk van de buitentemperatuur en wordt aangegeven met de 'coefficient of performance' (COP). De COP wordt lager als de buitentemperatuur afneemt. In het ETM was het al mogelijk om in te stellen boven welke COP de hybride warmtepomp moet schakelen van gas naar elektriciteit; dit noemen we de omslag-COP. Je kunt deze instellen op de financieel meest aantrekkelijke waarde voor de consument, maar kunt ook een instelling kiezen die minder netwerkimpact oplevert. Er zijn twee grafieken toegevoegd die de gebruiker ondersteunen in het maken van deze keuze: een grafiek die inzicht geeft in de kostenoptimale omslag-COP en een grafiek die de gas en elektriciteitsvraag per uur toont.

Bekijk het gedrag van hybride warmtepompen in detail bij **[Flexibiliteit → Netbelasting](/scenario/flexibility/flexibility_net_load/demand-response-behavior-of-hybrid-heat-pumps)**!

![](/assets/pages/whats_new/HHP_behaviour_nl.png)

## Verbeterde warmtevraagprofielen voor huishoudens

De warmtevraagprofielen in het ETM houden nu meer rekening met de gelijktijdigheid van de warmtevraag van huishoudens. De nieuwe profielen zijn gebasseerd op de gemiddelde vraag van 300 huizen. Voorheen waren de profielen afgeleid uit het stookgedrag van individuele huizen, wat leidde tot een overschatting van de piekvraag.

Let op: doordat de warmtevraagpieken voor huishoudens lager zijn, kunnen de uitkomsten van jouw scenario gaan veranderen. Wanneer bijvoorbeeld veel huizen aangesloten zijn op een warmtenet, kan het zijn dat er minder piekketels nodig zijn. Of wanneer veel huizen een warmtepomp hebben zal de netbelasting minder zijn. Als je moeite hebt met het duiden van de verschillen, schroom dan niet om [ons te mailen](mailto:info@energytransitionmodel.com).

## Data-export aangepast

In de data-export is het elektriciteitsprofiel voor ruimteverwarming in huishoudens uitgesplitst naar individuele warmtetechnologieën. Hierdoor is het nu bijvoorbeeld mogelijk om inzicht te krijgen in het elektriciteitsprofiel voor luchtwarmtepompen.

------------------------------------------------------------------------

# Januari \| Februari 2020

## Warmtenetten verbeterd en uitgebreid

De modellering van warmtenetten is verbeterd en uitgebreid! Hieronder vindt u de wijzigingen:

* Warmtenetten in huishoudens, gebouwen en landbouw zijn samengevoegd tot één net ('**residentieel warmtenet**'). Er is geen uitwisseling van warmteoverschotten meer mogelijk tussen industriële (stoom)netten en residentiële netten

* De vraag en productie van warmte in residentiële warmtenetten wordt vanaf nu berekend op **uurbasis** in plaats van op jaarbasis

  -> ![](/assets/pages/whats_new/hourly_heat_nl.png) <-

* Er wordt onderscheid gemaakt tussen '**must-run**'-bronnen (niet-regelbare) en '**dispatchable**'-bronnen (regelbare). Dispatchables draaien alleen als de must-runs niet voldoende produceren om aan de vraag te voldoen. Hun draaiuren en profielen zijn daarmee variabel. Gebruikers kunnen instellen welke ketels als eerst aanspringen

  -> ![](/assets/pages/whats_new/heat_merit_order_nl.png) <-

* Het is nu mogelijk **grootschalige zonthermieparken** in te zetten voor residentiële warmtenetten

* Gebruikers kunnen ervoor kiezen om **seizoensopslag** van warmte 'aan' te zetten. In dat geval wordt overproductie van must-runbronnen opgeslagen voor later gebruik in plaats van gedumpt

  -> ![](/assets/pages/whats_new/seasonal_storage_heat_nl.png) <-

* **Restwarmte** uit de kunstmest-, chemie-, raffinage- en ICT-sector kan worden uitgekoppeld en worden ingevoed op residentiële warmtenetten. Bekijk onze documentatie op [GitHub](https://docs.energytransitionmodel.com/main/residual-heat-industry) voor de methode en gebruikte bronnen

* De **kostenberekening** voor warmte-infrastructuur is uitgebreid. In plaats van te rekenen met een vast bedrag per aansluiting, zijn de kosten nu onderverdeeld in inpandige kosten, distributiekosten (leidingen, onderstations) en primaire netkosten. De kostenberekening is afgestemd op het Vesta MAIS-model, waardoor vergelijking en uitwisseling van resultaten tussen de ETM en Vesta MAIS eenvoudiger is geworden. Bekijk onze documentatie op [GitHub](https://docs.energytransitionmodel.com/main/heat-infrastructure-costs) voor meer informatie.

Ontdek [hier](/scenario/supply/heat/heat-sources) de verbeterde modellering van warmtenetten en check onze [Github documentatie](https://docs.energytransitionmodel.com/main/heat-networks) voor een uitgebreidere toelichting.

## WKK's anders gemodelleerd

Alle WKKs (m.u.v. biogas-WKK) draaien nu mee als dispatchable in de elektriciteitsmerit order, ook de industriële WKKs. WKKs draaien dus nu primair voor de elektriciteitsmarkt. Hun warmteproductie is daarmee een 'gegeven' (must-run) voor warmtenetten. Voorheen waren WKKs niet-regelbaar en draaiden ze met een vast vlak productieprofiel. Let op: deze wijziging kan mogelijk impact hebben op je scenariouitkomsten!

## Windprofielen verbeterd

De windprofielen voor de default dataset van Nederland zijn nu gegenereerd volgens dezelfde methode (gebaseerd op KNMI data) als gebruikt voor de [extreme weerjaren (1987, 1997, 2004)](/scenario/flexibility/flexibility_weather/temperature-and-full-load-hours). Dit waarborgt de consistentie tussen de verschillende datasets voor Nederland. Check onze [Github documentatie](https://github.com/quintel/etdataset-public/tree/master/curves/supply/wind) voor een uitgebreidere toelichting op deze methode.

-> ![](/assets/pages/whats_new/wind_curves_nl.png) <-

## Documentatie toegankelijker

Voor bepaalde schuifjes was het al mogelijk om de technische specificaties te bekijken, zodat je onze aannames kon zien. Nu gaan we nog een stapje verder en maken we voor veel schuifjes ook onze gehele achtergrond analyse (die al op GitHub staat) beschikbaar met één druk op de knop. Vanuit de technische specificaties tabel kan je deze analyse direct downloaden als Excel.

-> ![](/assets/pages/whats_new/documentation_download_nl.png) <-

## Download schuifjesinstellingen

Voor opgeslagen scenarios is het vanaf nu mogelijk om de waardes van je gezette schuifjes te downloaden als csv bestand. Dit kan handig zijn als je al jouw scenariowijzigingen op een rijtje wil hebben. Bekijk je opgeslagen scenarios via "Gebruiker → Mijn scenario's" (rechtsboven in het ETM) en klik op de titel van het gewenste scenario. Achter de url typ je nu '.csv' (je krijgt dus bijvoorbeeld pro.energytransitionmodel.com/saved_scenarios/0000.csv) en de download begint direct.

## Data-export aangepast

De bestandsindeling van de draaiprofielen en prijscurves van elektriciteit is veranderd. Per kolom uit de data-export wordt nu met "input" of "output" aangegeven of het om vraag of aanbod van elektriciteit gaat. Flexibiliteitsoplossingen hebben nu dus ook zowel een input als output kolom. Hiermee is de vorm van de data-export voor elektriciteit consistenter met de data-exports voor netwerkgas en waterstof.

[Hier vind je de aangepaste data-export voor elektriciteit!](/scenario/data/data_export/merit-order-price)
