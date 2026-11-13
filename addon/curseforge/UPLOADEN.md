# Brrraaaappp op CurseForge zetten

## 1. Eerst controleren (belangrijk)

- [ ] **Licenties van de geluiden.** Open elke link uit de tabel in `Brrraaaappp/README.md` en kijk welke licentie er staat:
  - **Creative Commons 0**: prima.
  - **Attribution (CC-BY)**: prima, zolang de maker genoemd wordt. Dat staat al in de README en in de beschrijving.
  - **Attribution NonCommercial (CC-BY-NC)**: niet gebruiken als je CurseForge-beloningen (Rewards) aanzet. Gooi het geluid er anders uit of zet Rewards uit.
  - **Sampling+** of iets anders: liever weglaten.
  - `bad_chili_fart` komt van een verwijderde gebruiker. Lukt het niet de licentie te vinden, gooi hem er dan uit.
  Laat me weten welke eruit moeten, dan haal ik ze uit de addon en uit de lijst.
- [ ] **In het spel getest:** venster (`/brap`), rook, `/e`-emote, scheten van anderen (naamplaatjes aan met V), eigen geluid.
- [ ] **Screenshots** gemaakt in het spel: het instellingenvenster, de bruine rook, en de chat met een smerige zin. CurseForge-bezoekers willen echte plaatjes zien.

## 2. Project aanmaken

1. Log in op [curseforge.com](https://www.curseforge.com) en kies **Create Project** bij World of Warcraft.
2. **Name:** Brrraaaappp
3. **Summary** en **Description:** kopieer ze uit `DESCRIPTION.md`.
4. **Category:** bijvoorbeeld *Miscellaneous* of *Roleplay*.
5. **Avatar:** `logo_512.png`.
6. **License:** kies er zelf een, bijvoorbeeld *MIT License* voor de code.

## 3. Bestand uploaden

1. Upload `Brrraaaappp-2.1.0.zip` (die stuur ik je mee).
2. **Game version:** kies de WoW Forever-versie (1.60.1).
3. **Release type:** *Beta* voor de eerste keer, *Release* als het goed werkt.
4. **Changelog:** bijvoorbeeld "First release."

## 4. Daarna

- Zet het **Project ID** van CurseForge in de `.toc` als `## X-Curse-Project-ID: 123456`. Dat helpt de CurseForge-app met updates.
- Na een WoW-patch: controleer het interfacenummer met `/dump select(4, GetBuildInfo())`, pas `## Interface:` aan, verhoog `## Version:` en upload een nieuwe zip.
