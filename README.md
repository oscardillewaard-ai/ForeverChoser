# ForeverChoser

Een installeerbare web-app (PWA) die je helpt kiezen welk **ras** en welke **class** je gaat spelen in **World of Warcraft: Forever** (launch 4 november 2026). Volledig in het Nederlands, werkt offline en heeft geen account of server nodig.

## Wat zit erin

| Onderdeel | Wat het doet |
|---|---|
| 🔮 **Orakel-quiz** | 12 scenariovragen. Elk antwoord telt op bij speelstijl-eigenschappen (afstand, magie, metgezel, sluipen, genezen…). Je profiel wordt vergeleken met het profiel van elke class. |
| ⚖️ **Dit of Dat** | 15 blinde duels tussen class-fantasieën ("Je roept een demon op…" of "Je temt een beest…"). Pas aan het eind zie je welke classes je koos. |
| 🎮 **Rol-proefrit** | Drie mini-games van 30 seconden: **healer** (party frames heel houden), **tank** (vijanden terug-taunten) en **DPS** (rotatie, procs en uit het vuur stappen). Daarna geef je sterren: je plezier telt mee, niet je score. |
| 🧬 **Rassen-raad** | Faction, uiterlijk, verhaal, speelfocus (PvE/PvP/questen/RP) en hoe je tegenover nieuwe dingen staat, plus hoe goed de racials bij je class passen. |
| 🎡 **Rad van het Lot** | Draait eerst een class, dan een geldig ras. Te filteren op faction en op "alleen nieuw in Forever". |
| 📜 **Namen-smidse** | Naamgenerator per ras, met favorieten. |
| 📖 **Gids** | Alle 9 classes en 10 rassen (Skyborne per faction), racials, de volledige combinatie-matrix (56 combinaties), weetjes en bronnen. |
| 🏆 **Resultaat** | Combineert de tests (quiz 45%, duels 30%, proefrit 25%) tot een top 3 en een concrete combinatie, bijvoorbeeld "Troll Mage". Te delen via je telefoon. |

## Op je telefoon zetten

1. Open de app-URL in je browser.
2. **Android (Chrome):** tik op *Installeer* bovenin, of menu ⋮ → *App installeren*.
3. **iPhone (Safari):** deel-icoon → *Zet op beginscherm*.

Na de eerste keer laden werkt de app ook offline. Voortgang wordt alleen lokaal op je toestel bewaard (localStorage).

## Hosten met GitHub Pages

De app bestaat uit statische bestanden zonder build-stap.

1. Merge deze branch naar `main`.
2. Ga in GitHub naar **Settings → Pages**.
3. Kies bij *Source* **Deploy from a branch**, branch **`main`**, map **`/ (root)`**.
4. Na een minuut staat de app op `https://oscardillewaard-ai.github.io/ForeverChoser/`.

Alle paden zijn relatief, dus de app werkt ook in die submap.

### Lokaal draaien

```bash
npx http-server -p 8080 .
# of: python3 -m http.server 8080
```

Open daarna http://localhost:8080. Een service worker werkt alleen via `http://localhost` of `https`, niet via `file://`.

### Een nieuwe versie uitrollen

Verhoog `VERSION` in `sw.js` (bijvoorbeeld `v1` → `v2`) zodat geïnstalleerde apps de nieuwe bestanden ophalen. Voeg nieuwe bestanden ook toe aan de `ASSETS`-lijst.

## Structuur

```
index.html              App-shell en navigatie
manifest.webmanifest    PWA-manifest
sw.js                   Service worker (offline cache)
css/style.css           Alle styling
icons/                  App-iconen (SVG + PNG, ook maskable)
js/app.js               Router, installeerknop, service worker
js/data.js              Classes, rassen, racials, combinaties, weetjes, bronnen
js/games-data.js        Quizvragen, rassenvragen, namen-lettergrepen
js/scoring.js           Alle berekeningen (quiz, duels, proefrit, rassen)
js/store.js             Lokale opslag
js/ui.js                Kleine UI-hulpfuncties
js/views/*.js           Eén bestand per scherm
```

Inhoud aanpassen (bijvoorbeeld een racial-waarde na launch) gaat in `js/data.js`.

## Over de gegevens

Onderzoek gedaan op **9 oktober 2026**, tijdens de beta.

- **Betrouwbaar:** de race/class-combinaties (officieel aangekondigd en in alle bronnen gelijk), de lijst met racials per ras, de launchdatum en de rulesets.
- **Onder voorbehoud:** exacte getallen van racials en class-wijzigingen komen uit beta-data en fan-gidsen. Waar bronnen elkaar tegenspreken, noemt de app geen getal.
- **Indicatie, geen meting:** moeilijkheid, solo-sterkte en hoe goed racials bij een class passen. Die zijn gebaseerd op Classic-ervaring en de consensus van beta-gidsen.

De gebruikte bronnen staan in de app onder *Gids → Bronnen*.

Fan-project, niet verbonden aan Blizzard Entertainment. World of Warcraft is een handelsmerk van Blizzard Entertainment.
