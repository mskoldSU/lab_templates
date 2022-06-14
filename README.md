# Bakgrund

Naturhistoriska riksmuseet skickar regelbundet stora mängder biologiska prover för kemisk analys, huvudsakligen mätning av halter av olika miljögifter, till olika labb. För att möjliggöra effektiv inmatning i museets databaser samt vidare rapporteing till s.k. datavärdar är det viktigt att labben rapporterar i ett standardiserat format. Museet har därför tagit fram ett antal standardmallar för olika typer av analyser. Ett exempel på en sådan mall ifylld av ett labb ges av filen [Metals_Marin_2020_7315.xlsm](Metals_Marin_2020_7315.xlsm).

Den typiska arbetsgången är att personal på museets labb först väljer en standardmall, t.ex. mallen för metallanalyser. Mallen är förberedd på så sätt att den har namngivna kolumner för de metaller som skall ingå i analysen. I mallen fyller de sedan i de kolumner som innehåller information om de prover som har beretts, väsentligen

- Accesionsnummer: Detta är ett id-nummer för den individ (den fisk, ägg, säl, mussla, ...) provet tagits från. (`NRM's sample code`)
- Provnummer labb: Ett id-nummer som labbet använder för att identifiera prover (fylls i av labbet) (`Sample code of analytical lab`)
- Provnummer NRM: Detta är ett lokalt id-nummer för provet man berett (flera prover kan tas från samma individ). (saknas i exempelmallen)

- Lokal: Den namngivna lokal där individen fångats (detta är egentligen inte intressant för den kemiska analysen utan finns där mest för kontrollsyfte). (`*samplingsite`)
- Art: Individens art (sill, sillgrissla, gråsäl, blåmussla, ...). (`*species`)
- Organ: Det organ som provtagits (muskel, lever, ...). (`sample tissue`)

Eftersom detta görs manuellt (och fälten saknar låsning) blir det inte likadant varje gång. Lokalen *Gotland Sydost* skrivs ibland som *Gotland SO*, eller *S.O. Gotland*, eller ... Detta gör det svårt att sedan läsa in ifyllda mallar automatiskt.


> [**_Projekt 1:_ Automatisk ifyllning av mall.**](https://github.com/mskoldSU/lab_templates/blob/master/projekt1.md)  Detta projekt har som mål att konstruera ett verktyg (en Shiny-app?) som delvis automatiserar förberedandet av rapportmallarna. Syftet är både att spara tid för labbets personal och att säkra att de blir maskinläsbara.

Mallen, uppdaterad med information om proverna, skickas nu till det labb som utför de kemiska analyserna. De fyller i resultaten och skickar mallen tillbaka till museet. På museet kan den ifyllda mallen sedan ligga oläst i flera månader. När det sedan blir dags att skriva rapport eller rapportera data vidare till datavärd upptäcker man ofta att något saknas eller har blivit fel inmatat. Detta leder ofta till en tidsödande korrespondens med labbet.

> **_Projekt 2:_ En valideringstjänst.** Detta projekt har som mål att konstruera ett verktyg (ytterligare en Shiny-app?) genom vilket labben kan validera och leverera ifyllda mallar. Syftet är båda att fel skall upptäckas direkt och att de levererade resultaten inte fastnar i någons mejlkorg.


