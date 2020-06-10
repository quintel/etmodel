# Wat is er nieuw in het Energietransitiemodel?

---

# Juni 2020

## Meerdere elektrische interconnectoren

Het verschil tussen vraag en aanbod van elektriciteit kan worden geïmporteerd of geëxporteerd. Veel landen importeren en exporteren elektriciteit met hun buurlanden via verschillende interconnectoren. In het ETM is het mogelijk om tot wel zes verschillende elektrische interconnectoren te modelleren tussen landen. Per interconnector kan je de capaciteit, CO2 uitstoot en (uurlijkse) prijs instellen. De gebruiker kan met een knop beslissen of er alleen overschotten kunnen worden geëxporteerd of dat ook dispatchable centrales elektriciteit kunnen produceren voor export. Op deze manier kan je all elektriciteitsstromen tussen landen realistisch modelleren. Een overzicht van al deze stromen is te zien in een nieuwe grafiek.

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

[Hier vind je de aangepaste data-export voor elektriciteit!][data export slide]

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
