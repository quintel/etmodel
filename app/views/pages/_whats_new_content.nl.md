# Wat is er nieuw in het Energietransitiemodel?

---

# April 2021

## Nieuwe grafiek die flexibiliteitsvoorziening laat zien

In onze update van februari 2021 hebben we een aantal grafieken toegevoegd die inzicht geven in de flexibiliteitsbehoefte. De volgende stap is om in die flexibiliteit te voorzien. We hebben daarom een grafiek toevoegd die het geïnstalleerde vermogen van flexibele vraag- en aanbodtechnologieën laat zien. Het vergelijken van deze vermogens met het maximale overschot en tekort helpt je te bepalen of je genoeg flexibel vermogen hebt geïnstalleerd om je energiesysteem te balanceren.

-> ![](/assets/pages/whats_new/installed_flexible_capacities_nl.png) <-

De grafiek kan gevonden worden in de sectie **[Flexibility → Overview][flexibility]**, waar we de uitleg van de bijbehorende grafieken vernieuwd hebben. We gaan nu in meer detail in op het inflexibele aanbod en vraag en de resiudal load curves, dus neem vooral een kijkje!

## Nieuw grafiek die het opgeslagen elektriciteitsvolume laat zien
Een belangrijke prestatie-indicator voor elektriciteitsopslag technologieën is de mate waarin ze benut worden. We hebben daarom het op- en ontlaadgedrag van deze technologieën gevisualiseerd in een nieuwe grafiek, die het opslagen elektriciteitsvolume per uur laat zien.

Je kunt de grafiek vinden in de sectie **[Flexibility → Excess electricity → Storage][electricity storage]**. Je kan kiezen of je alle elektriciteitsoplag technologieën op elkaar gestapeld wilt zien, of slechts eentje:

* Batterijen in huishoudens
* Batterijen in elektrische auto's
* Grootschalige batterijopslag
* OPAC
* Stuwmeren (afhankelijk van de geselecteerde regio's)

-> ![](/assets/pages/whats_new/hourly_stored_volume_of_electricity_nl.png) <-

# Februari 2021

## Nieuwe grafieken die de behoefte aan flexibiliteit tonen

Natuurlijke patronen zoals de seizoenen (jaarlijks), veranderingen in het weer (wekelijks), dag en nacht, en ons eigen ritme van opstaan, naar werk gaan, thuiskomen, etc. zorgen ervoor dat zowel de benodigdheid van energie als de beschikbaarheid ervan fluctueert. Flexibiliteit gaat over het balanceren van vraag en aanbod van energie op al deze tijdschalen.

We hebben een nieuwe sectie **[Flexibiliteit → Overzicht][flexibility]** aan het ETM toegevoegd met vier interactieve grafieken die laten zien hoe vraag en aanbod zich verhouden op verschillende tijdschalen. De grafieken tonen:

* Maandelijkse volumes van vraag en aanbod
* Onbalans in maandelijkse volumes van vraag en aanbod
* Flexibiliteitsbehoefte: volume
* Flexibiliteitsbehoefte: capaciteit

-> ![](/assets/pages/whats_new/monthly_supply_and_demand_volumes_nl.png) <-

Een gedetailleerd overzicht van de wijzigingen staat in onze  [documentatie](https://docs.energytransitionmodel.com/main/flexibility).

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

---

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

Ontdek deze nieuwe functionaliteiten in de sectie **[Aanbod → CCUS][ccus slide]**! Een gedetailleerd overzicht van de wijzigingen staat in onze [documentatie](https://docs.energytransitionmodel.com/main/co2-ccus) (Engelstalig).

## Negatieve emissies
Het ETM kan nu rekenen met zogeheten 'negatieve' CO<sub>2</sub> emissies. Deze emissies kunnen 'ontstaan' wanneer CO<sub>2</sub>-afvang wordt toegepast bij processen die biomassa gebruiken en wanneer CO<sub>2</sub> direct uit de lucht wordt gehaald door middel van Direct Air Capture. Bekijk ook onze [documentatie](https://docs.energytransitionmodel.com/main/co2-negative-emissions).

![](/assets/pages/whats_new/co2-negative-emissions.png)

## Scenario navigatie bar

Een nieuwe ‘scenario navigatie bar’ is toegevoegd dat de regio en eindjaar laat zien van jouw scenario. De naam van je scenario is ook zichtbaar wanneer je een opgeslagen scenario opent waardoor het makkelijker wordt om meerdere scenario’s te openen in verschillende browser tabs. Via de “Scenario opslaan” knop aan de rechterkant kun je snel je scenario opslaan. Het is nu makkelijker om al je opgeslagen scenario’s te bekijken door naar “Mijn scenario’s” te gaan.

![](/assets/pages/whats_new/scenario_navigatie_bar_nl.png)

## Interactie met andere modellen uit de Mondaine Suite mogelijk

Om de complexe uitdaging van de energietransitie beheersbaar te maken, wordt er met verschillende energiemodellen aan de energietransitie gerekend. Om de sterktes van ieder model te benutten, is het noodzakelijk om modellen samen te laten werken. In het kader van het [Mondaine](https://www.mondaine-suite.nl) project is de Energy System Description Language ([ESDL](https://energytransition.github.io/)) ontwikkeld om modellen dezelfde taal te laten ‘spreken’. Het biedt de mogelijkheid om informatie over zowel ruimtelijke, technische, economische, sociale en tijdsaspecten van de energietransitie in relatie tot elkaar te beschrijven. Daarmee wordt het mogelijk dat het ene model verder rekent met informatie uit een ander model. Het ETM kan in ESDL beschreven energiesystemen inlezen en op basis hiervan een scenario starten. Jouw bestand wordt omgezet in schuifjesinstellingen - zo kun je in het ETM het toekomstige energiesysteem verkennen en verder werken aan het scenario.

Bekijk de ESDL-importfunctionaliteit [hier][esdl]!

![](/assets/pages/whats_new/mondaine.jpg)

---

# Juni 2020

## Meerdere elektrische interconnectoren

Veel landen importeren en exporteren elektriciteit met hun buren via verschillende interconnectoren, en het ETM modelleerde dit eerst met een enkele interconnector. Landen hebben echter vaak meerdere interconnectoren met verschillende buren, elk met hun eigen capaciteit, prijs en beschikbaarheid.

In het ETM is het nu mogelijk om tot wel zes verschillende elektrische interconnectoren te modelleren tussen landen. Per interconnector kan je de capaciteit, CO2 uitstoot en (uurlijkse) prijs instellen. De gebruiker kan met een knop beslissen of er alleen overschotten kunnen worden geëxporteerd of dat ook dispatchable centrales elektriciteit kunnen produceren voor export. Op deze manier kan je all elektriciteitsstromen tussen landen realistisch modelleren. Een overzicht van al deze stromen is te zien in een nieuwe grafiek.

Ontdek deze nieuwe functionaliteit bij **[Flexibiliteit → Import/Export][import export]**!

![](/assets/pages/whats_new/electricity_sankey_nl.png)

## Warmtevraagprofielen voor gebouwen en landbouw temperatuursafhankelijk

De uurlijkse vraagcurves in de gebouwensector en landbouw zijn temperatuursafhankelijk gemaakt. Hierdoor veranderen de curves mee als de gebruiker een ander weerjaar selecteert. Voorheen gebruikte het ETM een statisch grootverbruikersprofiel voor de gebouwensector en een vlak profiel voor de landbouw. Nu gebruiken beide sectoren hetzelfde grootverbruikersprofiel, dat dynamisch is gegenereerd aan de hand van weerdata. Dit profiel is hierdoor ook beschikbaar voor de historische weerjaren 1987, 1997 en 2004, waardoor de warmtevraag in gebouwen en landbouw, net als bij huishoudens, meebeweegt met de buitentemperatuur.

Bekijk de impact van het weerjaar op de vraagprofielen bij **[Flexibiliteit → Weersomstandigheden][weather years slide]**!

![](/assets/pages/whats_new/weather_years_buildings_heating_nl.png)

## Impact van buitentemperatuur op energievraag

De impact van een hogere of lagere gemiddelde buitentemperatuur is tegen het licht gehouden. Het veranderen van de buitentemperatuur heeft nu, naast huishoudens en gebouwen, ook invloed op de warmtevraag van landbouw. Daarnaast is de impact op de warmtevraag in deze drie sectoren een stuk groter dan voorheen. De impact van temperatuur op warmtevraag is afgeleid uit de ‘graaddagenformule’ die gehanteerd wordt door GTS. Bekijk onze [documentatiepagina](https://docs.energytransitionmodel.com/main/outdoor-temperature) voor meer informatie. Deze verbetering is relevant voor zowel de temperatuurschuif in de weerjarensectie van het ETM als het selecteren van een specifiek weerjaar.

Ga naar **[Flexibiliteit → Weersomstandigheden][weather years slide]** om de verbetering te bekijken!

![](/assets/pages/whats_new/outdoor_temperature_nl.png)

___

# Maart 2020

## Beperk de productie van zonnepanelen
Als er veel zonnepanelen geïnstalleerd zijn, kan dit resulteren in hoge pieken op het elektriciteitsnetwerk. Daarom is het wenselijk de productie te kunnen verlagen. In sommige gevallen is het slim om zonneparken aan te sluiten op slechts een bepaald percentage van het piekvermogen. In het ETM is het nu mogelijk om het percentage productiebeperking in te stellen voor verschillende types zonnepanelen.

Ontdek de productiebeperking van zonnepanelen bij **[Flexibiliteit → Netbelasting][solar pv curtailment slide]**!

![](/assets/pages/whats_new/curtailment_solar_pv_nl.png)

## Zet elektriciteitsoverschotten om in warmte voor warmtenetten
Het is nu mogelijk om elektriciteitsoverschotten van zon en wind om te zetten in warmte voor warmtenetten. Dit kan middels een power-to-heat (P2H) elektrische boiler en een P2H warmtepomp die alleen warmte produceren als er overschotten zijn. De geproduceerde warmte kan direct worden ingezet of worden opgeslagen voor een later moment. Zo kun je bijvoorbeeld overschotten van wind en zon gebruiken om 's winters huizen mee te verwarmen.

Bekijk de P2H schuifjes voor warmtenetten bij **[Flexibiliteit → Elektriciteitsoverschotten → Conversie][p2h district heating slide]**!

![](/assets/pages/whats_new/p2h_seasonal_storage_nl.png)

## Bekijk het schakelgedrag van hybride warmtepompen

De efficiëntie van (hybride) warmtepompen is afhankelijk van de buitentemperatuur en wordt aangegeven met de 'coefficient of performance' (COP). De COP wordt lager als de buitentemperatuur afneemt. In het ETM was het al mogelijk om in te stellen boven welke COP de hybride warmtepomp moet schakelen van gas naar elektriciteit; dit noemen we de omslag-COP. Je kunt deze instellen op de financieel meest aantrekkelijke waarde voor de consument, maar kunt ook een instelling kiezen die minder netwerkimpact oplevert. Er zijn twee grafieken toegevoegd die de gebruiker ondersteunen in het maken van deze keuze: een grafiek die inzicht geeft in de kostenoptimale omslag-COP en een grafiek die de gas en elektriciteitsvraag per uur toont.

Bekijk het gedrag van hybride warmtepompen in detail bij **[Flexibiliteit → Netbelasting][behavior hhp slide]**!

![](/assets/pages/whats_new/HHP_behaviour_nl.png)

## Verbeterde warmtevraagprofielen voor huishoudens

De warmtevraagprofielen in het ETM houden nu meer rekening met de gelijktijdigheid van de warmtevraag van huishoudens. De nieuwe profielen zijn gebasseerd op de gemiddelde vraag van 300 huizen. Voorheen waren de profielen afgeleid uit het stookgedrag van individuele huizen, wat leidde tot een overschatting van de piekvraag.

Let op: doordat de warmtevraagpieken voor huishoudens lager zijn, kunnen de uitkomsten van jouw scenario gaan veranderen. Wanneer bijvoorbeeld veel huizen aangesloten zijn op een warmtenet, kan het zijn dat er minder piekketels nodig zijn. Of wanneer veel huizen een warmtepomp hebben zal de netbelasting minder zijn. Als je moeite hebt met het duiden van de verschillen, schroom dan niet om <a href="mailto:info@energytransitionmodel.com">ons te mailen</a>.

## Data-export aangepast

In de data-export is het elektriciteitsprofiel voor ruimteverwarming in huishoudens uitgesplitst naar individuele warmtetechnologieën. Hierdoor is het nu bijvoorbeeld mogelijk om inzicht te krijgen in het elektriciteitsprofiel voor luchtwarmtepompen.

---

# Januari | Februari 2020

## Warmtenetten verbeterd en uitgebreid

De modellering van warmtenetten is verbeterd en uitgebreid! Hieronder vindt u de wijzigingen:

- Warmtenetten in huishoudens, gebouwen en landbouw zijn samengevoegd tot één net (‘**residentieel warmtenet**’). Er is geen uitwisseling van warmteoverschotten meer mogelijk tussen industriële (stoom)netten en residentiële netten

- De vraag en productie van warmte in residentiële warmtenetten wordt vanaf nu berekend op **uurbasis** in plaats van op jaarbasis

  -> ![](/assets/pages/whats_new/hourly_heat_nl.png) <-

- Er wordt onderscheid gemaakt tussen ‘**must-run**’-bronnen (niet-regelbare) en ‘**dispatchable**’-bronnen (regelbare). Dispatchables draaien alleen als de must-runs niet voldoende produceren om aan de vraag te voldoen. Hun draaiuren en profielen zijn daarmee variabel. Gebruikers kunnen instellen welke ketels als eerst aanspringen

  -> ![](/assets/pages/whats_new/heat_merit_order_nl.png) <-

- Het is nu mogelijk **grootschalige zonthermieparken** in te zetten voor residentiële warmtenetten

- Gebruikers kunnen ervoor kiezen om **seizoensopslag** van warmte ‘aan’ te zetten. In dat geval wordt overproductie van must-runbronnen opgeslagen voor later gebruik in plaats van gedumpt

  -> ![](/assets/pages/whats_new/seasonal_storage_heat_nl.png) <-

- **Restwarmte** uit de kunstmest-, chemie-, raffinage- en ICT-sector kan worden uitgekoppeld en worden ingevoed op residentiële warmtenetten. Bekijk onze documentatie op [GitHub][residual heat documentation] voor de methode en gebruikte bronnen

-	De **kostenberekening** voor warmte-infrastructuur is uitgebreid. In plaats van te rekenen met een vast bedrag per aansluiting, zijn de kosten nu onderverdeeld in inpandige kosten, distributiekosten (leidingen, onderstations) en primaire netkosten. De kostenberekening is afgestemd op het Vesta MAIS-model, waardoor vergelijking en uitwisseling van resultaten tussen de ETM en Vesta MAIS eenvoudiger is geworden. Bekijk onze documentatie op [GitHub][heat-infra costs documentation] voor meer informatie.

Ontdek [hier][district heating slide] de verbeterde modellering van warmtenetten en check onze [Github documentatie][heat network documentation] voor een uitgebreidere toelichting.

## WKK's anders gemodelleerd

Alle WKKs (m.u.v. biogas-WKK) draaien nu mee als dispatchable in de elektriciteitsmerit order, ook de industriële WKKs. WKKs draaien dus nu primair voor de elektriciteitsmarkt. Hun warmteproductie is daarmee een ‘gegeven’ (must-run) voor warmtenetten. Voorheen waren WKKs niet-regelbaar en draaiden ze met een vast vlak productieprofiel. Let op: deze wijziging kan mogelijk impact hebben op je scenariouitkomsten!

## Windprofielen verbeterd

De windprofielen voor de default dataset van Nederland zijn nu gegenereerd volgens dezelfde methode (gebaseerd op KNMI data) als gebruikt voor de [extreme weerjaren (1987, 1997, 2004)][weather years slide]. Dit waarborgt de  consistentie tussen de verschillende datasets voor Nederland. Check onze [Github documentatie][wind curves documentation] voor een uitgebreidere toelichting op deze methode.

-> ![](/assets/pages/whats_new/wind_curves_nl.png) <-

## Documentatie toegankelijker

Voor bepaalde schuifjes was het al mogelijk om de technische specificaties te bekijken, zodat je onze aannames kon zien. Nu gaan we nog een stapje verder en maken we voor veel schuifjes ook onze gehele achtergrond analyse (die al op GitHub staat) beschikbaar met één druk op de knop. Vanuit de technische specificaties tabel kan je deze analyse direct downloaden als Excel.

-> ![](/assets/pages/whats_new/documentation_download_nl.png) <-

## Download schuifjesinstellingen

Voor opgeslagen scenarios is het vanaf nu mogelijk om de waardes van je gezette schuifjes te downloaden als csv bestand. Dit kan handig zijn als je al jouw scenariowijzigingen op een rijtje wil hebben. Bekijk je opgeslagen scenarios via "Gebruiker > Mijn scenario's" (rechtsboven in het ETM) en klik op de titel van het gewenste scenario. Achter de url typ je nu '.csv' (je krijgt dus bijvoorbeeld pro.energytransitionmodel.com/saved_scenarios/0000.csv) en de download begint direct.

## Data-export aangepast

De bestandsindeling van de draaiprofielen en prijscurves van elektriciteit is veranderd. Per kolom uit de data-export wordt nu met "input" of "output" aangegeven of het om vraag of aanbod van elektriciteit gaat. Flexibiliteitsoplossingen hebben nu dus ook zowel een input als output kolom. Hiermee is de vorm van de data-export voor elektriciteit consistenter met de data-exports voor netwerkgas en waterstof.

[flexibility]: /scenario/flexibility/flexibility_overview/what-is-flexibility

[Hier vind je de aangepaste data-export voor elektriciteit!][data export slide]

[ccus slide]: scenario/supply/ccus/capture-of-co2

[esdl]: /import_esdl

[weather years slide]: /scenario/flexibility/flexibility_weather/extreme-weather-conditions

[import export]: /scenario/flexibility/electricity_import_export/electricity-interconnector-1

[solar pv curtailment slide]: /scenario/flexibility/flexibility_net_load/curtailment-solar-pv

[p2h district heating slide]: /scenario/flexibility/flexibility_conversion/conversion-to-heat-for-district-heating

[behavior hhp slide]: /scenario/flexibility/flexibility_net_load/demand-response-behavior-of-hybrid-heat-pumps

[district heating slide]: /scenario/supply/heat/heat-sources

[data export slide]: /scenario/data/data_export/merit-order-price

[weather years slide]: /scenario/flexibility/flexibility_weather/extreme-weather-conditions

[heat-infra costs documentation]: https://docs.energytransitionmodel.com/main/heat-infrastructure-costs

[heat network documentation]: https://docs.energytransitionmodel.com/main/heat-networks

[residual heat documentation]: https://docs.energytransitionmodel.com/main/residual-heat-industry

[wind curves documentation]: https://github.com/quintel/etdataset-public/tree/master/curves/supply/wind
