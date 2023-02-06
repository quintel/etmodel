# Wat is er nieuw in het Energietransitiemodel?
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
Er zijn twee nieuwe technologieën toegevoegd die stoom kunnen leveren aan het industriële warmtenet. Je kunt nu vermogen installeren voor een waterstofturbine-WKK, die zowel stoom als elektriciteit produceert, en voor een waterstofketel, die alleen stoom produceert. Ga hiervoor naar *Vraag → Industrie* → **[Bronnen warmtenet](/scenario/demand/industry/heat-network-sources)**.

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

Bekijk de impact van het weerjaar op de vraagprofielen bij **[Flexibiliteit → Weersomstandigheden](/scenario/flexibility/flexibility_weather/extreme-weather-conditions)**!

![](/assets/pages/whats_new/weather_years_buildings_heating_nl.png)

## Impact van buitentemperatuur op energievraag

De impact van een hogere of lagere gemiddelde buitentemperatuur is tegen het licht gehouden. Het veranderen van de buitentemperatuur heeft nu, naast huishoudens en gebouwen, ook invloed op de warmtevraag van landbouw. Daarnaast is de impact op de warmtevraag in deze drie sectoren een stuk groter dan voorheen. De impact van temperatuur op warmtevraag is afgeleid uit de 'graaddagenformule' die gehanteerd wordt door GTS. Bekijk onze [documentatiepagina](https://docs.energytransitionmodel.com/main/outdoor-temperature) voor meer informatie. Deze verbetering is relevant voor zowel de temperatuurschuif in de weerjarensectie van het ETM als het selecteren van een specifiek weerjaar.

Ga naar **[Flexibiliteit → Weersomstandigheden](/scenario/flexibility/flexibility_weather/extreme-weather-conditions)** om de verbetering te bekijken!

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

De windprofielen voor de default dataset van Nederland zijn nu gegenereerd volgens dezelfde methode (gebaseerd op KNMI data) als gebruikt voor de [extreme weerjaren (1987, 1997, 2004)](/scenario/flexibility/flexibility_weather/extreme-weather-conditions). Dit waarborgt de consistentie tussen de verschillende datasets voor Nederland. Check onze [Github documentatie](https://github.com/quintel/etdataset-public/tree/master/curves/supply/wind) voor een uitgebreidere toelichting op deze methode.

-> ![](/assets/pages/whats_new/wind_curves_nl.png) <-

## Documentatie toegankelijker

Voor bepaalde schuifjes was het al mogelijk om de technische specificaties te bekijken, zodat je onze aannames kon zien. Nu gaan we nog een stapje verder en maken we voor veel schuifjes ook onze gehele achtergrond analyse (die al op GitHub staat) beschikbaar met één druk op de knop. Vanuit de technische specificaties tabel kan je deze analyse direct downloaden als Excel.

-> ![](/assets/pages/whats_new/documentation_download_nl.png) <-

## Download schuifjesinstellingen

Voor opgeslagen scenarios is het vanaf nu mogelijk om de waardes van je gezette schuifjes te downloaden als csv bestand. Dit kan handig zijn als je al jouw scenariowijzigingen op een rijtje wil hebben. Bekijk je opgeslagen scenarios via "Gebruiker → Mijn scenario's" (rechtsboven in het ETM) en klik op de titel van het gewenste scenario. Achter de url typ je nu '.csv' (je krijgt dus bijvoorbeeld pro.energytransitionmodel.com/saved_scenarios/0000.csv) en de download begint direct.

## Data-export aangepast

De bestandsindeling van de draaiprofielen en prijscurves van elektriciteit is veranderd. Per kolom uit de data-export wordt nu met "input" of "output" aangegeven of het om vraag of aanbod van elektriciteit gaat. Flexibiliteitsoplossingen hebben nu dus ook zowel een input als output kolom. Hiermee is de vorm van de data-export voor elektriciteit consistenter met de data-exports voor netwerkgas en waterstof.

[Hier vind je de aangepaste data-export voor elektriciteit!](/scenario/data/data_export/merit-order-price)
