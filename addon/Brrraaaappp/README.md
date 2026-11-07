# Brrraaaappp 💨

*Wanneer de natuur roept, roept ze luid.*

Een addon voor **World of Warcraft: Forever** die je character heel af en toe een scheetje laat laten. Standaard één keer per 10 tot 30 minuten, op een willekeurig moment.

## Installeren

1. Kopieer de map `Brrraaaappp` (met `Brrraaaappp.toc`, `Brrraaaappp.lua` en `sounds/`) naar
   `World of Warcraft\_<versie>_\Interface\AddOns\`.
   De map moet precies `Brrraaaappp` heten.
2. Start het spel en zet bij het character-scherm onder **AddOns** een vinkje bij Brrraaaappp.
3. Staat er "out of date"? Vink dan **Load out of date AddOns** aan, of zet het juiste getal in de TOC (zie hieronder).

## Commando's

| Commando | Wat het doet |
|---|---|
| `/brrraaaappp nu` | Meteen een scheetje (om te testen) |
| `/brrraaaappp aan` / `uit` | Addon aan- of uitzetten |
| `/brrraaaappp tijd 5 20` | Wachttijd tussen 5 en 20 minuten |
| `/brrraaaappp emote` | Doet ook de echte `/fart`-emote. **Andere spelers zien die!** |
| `/brrraaaappp combat` | Wel of niet tijdens gevechten |
| `/brrraaaappp status` | Huidige instellingen |

`/brap` werkt ook als afkorting. Instellingen worden per account bewaard.

## Goed om te weten

- **Alleen jij hoort het geluid.** Addons kunnen geen geluid naar andere spelers sturen. Wil je dat je groep het ook merkt, zet dan de emote aan.
- Het geluid loopt via het Master-kanaal, dus het speelt ook als je effectgeluiden uit hebt staan.
- De vijf geluidjes zijn zelf gesynthetiseerd: geen opnames, geen rechtenproblemen.

## Interface-versie

In `Brrraaaappp.toc` staat `## Interface: 16001` (WoW Forever 1.60.1, volgens addon-gidsen en CurseForge-bestandsnamen). Staat de addon na een patch op "Incompatible" of "out of date"? Typ dan in het spel:

```
/dump select(4, GetBuildInfo())
```

Zet het getal dat je ziet achter `## Interface:` in de TOC.
