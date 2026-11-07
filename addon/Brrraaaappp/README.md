# Brrraaaappp 💨

*Wanneer de natuur roept, roept ze luid.*

Een addon voor **World of Warcraft: Forever** die je character heel af en toe een scheetje laat laten. Standaard één keer per 10 tot 30 minuten, op een willekeurig moment.

## Installeren

1. Kopieer de hele map `Brrraaaappp` (met alle `.lua`-bestanden, de `.toc` en de mappen `sounds/` en `media/`) naar
   `World of Warcraft\_forever_\Interface\AddOns\`.
   De map moet precies `Brrraaaappp` heten.
2. Start het spel en zet bij het character-scherm onder **AddOns** een vinkje bij Brrraaaappp.
   Heb je een update geïnstalleerd met nieuwe bestanden? Herstart WoW dan helemaal: een `/reload` ziet nieuwe bestanden niet.
3. Staat er "out of date"? Vink dan **Load out of date AddOns** aan, of zet het juiste getal in de TOC (zie hieronder).

## Commando's

| Commando | Wat het doet |
|---|---|
| `/brrraaaappp nu` | Meteen een scheetje (om te testen) |
| `/brrraaaappp aan` / `uit` | Addon aan- of uitzetten |
| `/brrraaaappp tijd 5 20` | Wachttijd tussen 5 en 20 minuten |
| `/brrraaaappp emote` | Doet ook de echte `/fart`-emote. **Andere spelers zien die!** |
| `/brrraaaappp zin` | Smerige zin bij elke scheet, passend bij je race en class (alleen jij ziet hem) |
| `/brrraaaappp rook` | Bruine rookwolk over je scherm bij elke scheet, aan/uit (alleen jij ziet hem) |
| `/brrraaaappp combat` | Wel of niet tijdens gevechten |
| `/brrraaaappp status` | Huidige instellingen |

`/brap` werkt ook als afkorting. Instellingen worden per account bewaard.

**Wanneer komt de eerste scheet?** De timer start bij het inloggen. De eerste automatische scheet komt dus pas na 10 tot 30 minuten, en bij elke `/reload` of nieuwe login begint de wachttijd opnieuw. Met `/brap status` zie je over hoeveel minuten de volgende komt. Snel testen? Zet `/brap tijd 1 2` en wacht een minuutje (zet hem daarna terug met `/brap tijd 10 30`).

## Goed om te weten

- **Alleen jij hoort het geluid.** Addons kunnen geen geluid naar andere spelers sturen. Wil je dat je groep het ook merkt, zet dan de emote aan.
- Het geluid loopt via het Master-kanaal, dus het speelt ook als je effectgeluiden uit hebt staan.
- Er zitten 11 echte scheetopnames in. Ze zijn bijgeknipt, omgezet naar mono-OGG en even hard gemaakt.
- **De rook** duurt ongeveer 4,5 seconden: 16 bruine wolkjes komen uit het midden van je scherm (waar je character meestal staat), drijven omhoog en vervagen, en de randen van je scherm kleuren even bruin. De rook ligt onder je interface, dus je actiebalken en chat blijven leesbaar. De rooktexturen in `media/` zijn zelf gegenereerd, dus daar zitten geen rechten van anderen op.

## Interface-versie

In `Brrraaaappp.toc` staat `## Interface: 16001` (WoW Forever 1.60.1, volgens addon-gidsen en CurseForge-bestandsnamen). Staat de addon na een patch op "Incompatible" of "out of date"? Typ dan in het spel:

```
/dump select(4, GetBuildInfo())
```

Zet het getal dat je ziet achter `## Interface:` in de TOC.

## Geluiden

Alle geluiden komen van [freesound.org](https://freesound.org). Controleer bij elk geluid de licentie op de pagina voordat je de addon publiek deelt. Staat er CC-BY, dan moet de maker hieronder genoemd blijven.

| Bestand | Origineel | Maker |
|---|---|---|
| `timtube_fart3.ogg` | [fart-3](https://freesound.org/s/61055/) | timtube |
| `dual_fart.ogg` | [dual fart](https://freesound.org/s/80388/) | ifartinurgeneraldirection |
| `bad_chili_fart.ogg` | [bad chili fart](https://freesound.org/s/94989/) | (verwijderde gebruiker) |
| `zippi1_fart5.ogg` | [fart5](https://freesound.org/s/27138/) | zippi1 |
| `smokevhstapes_fart5.ogg` | [fart5](https://freesound.org/s/260961/) | smokevhstapes |
| `aetherzip_fart_long.ogg` | [fart long](https://freesound.org/s/691978/) | aetherzip |
| `teddyferguson_fart.ogg` | [fart](https://freesound.org/s/402569/) | teddyferguson |
| `breviceps_fart3.ogg` | [fart 3](https://freesound.org/s/446000/) | breviceps |
| `nasty_fart.ogg` | [nasty fart](https://freesound.org/s/645339/) | samsterbirdies |
| `frenkfurth_fart50.ogg` | [fart sound 50](https://freesound.org/s/663636/) | frenkfurth |
| `bassimat_fart005.ogg` | [fart 005](https://freesound.org/s/840755/) | bassimat |
