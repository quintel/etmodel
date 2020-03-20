# Wat is er nieuw in het Energietransitiemodel?

---

# Maart 2020

## Beperk de productie van zonnepanelen
Als er veel zonnepanelen geïnstalleerd zijn, kan dit resulteren in hoge pieken op het elektriciteitsnetwerk. Daarom is het wenselijk de productie te kunnen verlagen. In sommige gevallen is het slim om zonneparken aan te sluiten op slechts een bepaald percentage van het piekvermogen. In het ETM is het nu mogelijk om het percentage productiebeperking in te stellen voor verschillende types zonnepanelen.

![](/assets/pages/whats_new/curtailment_solar_pv_nl.png)

## Zet elektriciteitsoverschotten om in warmte voor warmtenetten
Het is nu mogelijk om elektriciteitsoverschotten van zon en wind om te zetten in warmte voor warmtenetten. Dit kan middels een power-to-heat (P2H) elektrische boiler en een P2H warmtepomp die alleen warmte produceren als er overschotten zijn. De geproduceerde warmte kan direct worden ingezet of worden opgeslagen voor een later moment. Zo kun je bijvoorbeeld overschotten van wind en zon gebruiken om 's winters huizen mee te verwarmen.

![](/assets/pages/whats_new/p2h_seasonal_storage_nl.png)

## Bekijk het schakelgedrag van hybride warmtepompen

De efficiëntie van (hybride) warmtepompen is afhankelijk van de buitentemperatuur en wordt aangegeven met de 'coefficient of performance' (COP). De COP wordt lager als de buitentemperatuur afneemt. In het ETM was het al mogelijk om in te stellen boven welke COP de hybride warmtepomp moet schakelen van gas naar elektriciteit; dit noemen we de omslag-COP. Je kunt deze instellen op de financieel meest aantrekkelijke waarde voor de consument, maar kunt ook een instelling kiezen die minder netwerkimpact oplevert. Er zijn twee grafieken toegevoegd die de gebruiker ondersteunen in het maken van deze keuze: een grafiek die inzicht geeft in de kostenoptimale omslag-COP en een grafiek die de gas en elektriciteitsvraag per uur toont.

![](/assets/pages/whats_new/HHP_behaviour_nl.png)

## Verbeterde warmtevraagprofielen voor huishoudens

De warmtevraagprofielen in het ETM houden nu meer rekening met de gelijktijdigheid van de warmtevraag van huishoudens. De nieuwe profielen zijn gebasseerd op de gemiddelde vraag van 300 huizen. Voorheen waren de profielen afgeleid uit het stookgedrag van individuele huizen, wat leidde tot een overschatting van de piekvraag.

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

[district heating slide]: /scenario/supply/heat/heat-sources

[data export slide]: /scenario/data/data_export/merit-order-price

[weather years slide]: /scenario/flexibility/flexibility_weather/extreme-weather-conditions

[heat-infra costs documentation]: https://github.com/quintel/documentation/blob/master/general/heat_infrastructure_costs.md

[heat network documentation]: https://github.com/quintel/documentation/blob/master/general/heat_networks.md

[residual heat documentation]: https://github.com/quintel/documentation/blob/master/general/residual_heat_industry.md

[wind curves documentation]: https://github.com/quintel/etdataset-public/tree/master/curves/supply/wind
