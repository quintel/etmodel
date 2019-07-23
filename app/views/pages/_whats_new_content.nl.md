# Wat is er nieuw in het Energietransitiemodel?

## 1. Alle RES-regio’s beschikbaar!

Vanaf nu zijn alle 30 RES-regio’s beschikbaar in het Energietransitiemodel. Dit
betekent dat iedereen deze energiesystemen kan gaan verkennen en (professionele)
energiescenario's kan gaan maken. Bekijk bijvoorbeeld het effect van:

* Het plaatsen van een zonnepark in Drechtsteden,
* Het isoleren van alle rijtjeshuizen in Midden-Holland,
* Of het bouwen van tien windmolens in de Cleantechregio

Voor meer informatie: https://quintel.com/res

-> ![](/assets/pages/whats_new/resregions_nl.png) <-

## 2. Gebruiksvriendelijkheid verbeterd

Er is ook gewerkt aan de gebruiksvriendelijkheid van het Energietransitiemodel.
Een aantal voorbeelden:

* **Introductie**: Er is een heldere [landingspagina][Workflow slide], waar het
  proces voor het maken van scenario's op hoofdlijnen wordt uitgelegd.
* **Scenario's opslaan**: Je kunt eigen scenario's zowel "opslaan" als "opslaan
  als". Dit maakt versiebeheer veel makkelijker en intuitiever. Met "opslaan"
  overschrijf jij het scenario en blijft de naam en de link intact. Met "opslaan
  als" maak je een kopie, waar je een nieuwe naam aan moet geven (= gelijk aan
  de oude manier).
* **Aanbod**: Met de schuifjes voor aanbod geef je nu vermogen in MW aan in
  plaats van aantallen; dit maakt het voor veel mensen makkelijker om bekende
  plannen en doelstellingen om te zetten in schuifjes, zonder dat er zelf
  omrekeningen nodig zijn.
* **Huizenvoorraad**: Je hoeft niet meer per type woning in een scenario aan te
  geven hoeveel het er worden. Als je meer woningen bouwt, wordt de huidige mix
  gevolgd. Deze mix kun je wel veranderen. Bekijk de
  [nieuwe schuifjes voor de huizenvoorraad][Housing stock slide].

## 3. Imported electricity price curve

Het ETM veronderstelt standaard dat [de prijs van geïmporteerde
elektriciteit][Imported electricity cost slide] constant is gedurende het jaar.
Je kunt nu afwijken van deze aanname door een CSV-bestand te importeren met
daarin voor elk uur van het jaar een prijs voor import-stroom (in €/MWh).
Hierdoor zal de positie van geïmporteerde elektriciteit in de merit order per
uur verschillen.

-> ![](/assets/pages/whats_new/imported_electricity_price_nl.png) <-

[Onze documentatie][Import price docs] bevat meer informatie over deze nieuwe
feature, inclusief instructies over hoe het CSV-bestand geüpload moet worden.

## 4. Update van alle uurlijkse profielen

Het ETM modelleert vraag en aanbod van elektriciteit en waterstof op uurbasis.
We hebben in nauwe samenwerking met de energiemodellengemeenschap alle profielen
herzien en de bronnen en methodes duidelijk gedocumenteerd op Github. Dit
traject is afgesloten met een mini-symposium waar de resultaten zijn
gepresenteerd en we verbeterpunten hebben geïdentificeerd.
[Hier kun je de documentatie over de uurlijkse profielen vinden][Curve docs].

-> ![](/assets/pages/whats_new/hourlyprofiles_nl.png) <-

## 5. Transitiepaden

Met de inzet van de nieuwe transitiepaden module kunnen de mogelijke
transitiepaden naar een 2050 toekomstbeeld verkend worden. Het stelt de
gebruiker in staat om te ontdekken wat dit zou kunnen betekenen voor de
tussentijdse doelstellingen voor de belangrijkste zichtjaren (2023, 2030 en
2040). Met de transitiepaden krijgt de gebruiker inzicht in een drietal
grafieken waarmee het transitiepad van de belangrijkste aspecten van het
energiesysteem (eindgebruik energie, CO<sub>2</sub> uitstoot en hernieuwbare
opwek) per zichtjaar ingezien en aangepast kunnen worden.
[Ontdek de nieuwe transitiepaden module][Multi year charts].

-> ![](/assets/pages/whats_new/myc_nl.png) <-

## 6. Overige updates

Verder zijn er nog twee kleinere updates die ook interessant zijn om te noemen:

* **Grondstoffen chemische industrie**: Het is nu mogelijk om grondstoffen die
  gebruikt worden door de chemische industrie aan te passen. Je kunt nu
  bijvoorbeeld fossiele grondstoffen vervangen voor biomassa/waterstof [met de
  nieuwe schuifjes][Chemical slide].
* **Waterstofcentrale (STEG)**: Naast de pieklast waterstofcentrale kan nu ook
  een [basislast waterstofcentrale (STEG)][Hydrogen plants slide] ingezet worden
  in een scenario.

[Chemicals slide]: /scenario/demand/industry/chemicals
[Curve docs]: https://github.com/quintel/documentation/blob/master/general/curves.md
[Housing stock slide]: /scenario/demand/households/population-housing-stock
[Hydrogen plants slide]: /scenario/supply/electricity_renewable/hydrogen-plants
[Import price docs]: https://github.com/quintel/documentation/blob/master/general/costs_imported_electricity.md#uploaded-price-curves
[Imported electricity cost slide]: /scenario/costs/electricity_import_costs/costs-of-imported-electricity
[Multi year charts]: /multi_year_charts
[Workflow slide]: /scenario/overview/introduction/how-does-the-energy-transition-model-work
