# Brrraaaappp 💨

*When nature calls, it calls loudly.*

A World of Warcraft: Forever addon that makes your character fart every now and then, with brown smoke, gross race/class flavor text, optional `/e` emotes, and nearby characters joining in.

## Install

1. Copy the `Brrraaaappp` folder into `World of Warcraft\_forever_\Interface\AddOns\`.
2. Restart WoW completely (a `/reload` doesn't see new files) and enable **Brrraaaappp** in the AddOns list.
3. Type `/brap` to open the settings.

## Features

- **Your farts**: at a random moment, every 10-30 minutes by default (adjustable).
- **Brown smoke cloud** over your screen for a few seconds. It sits below the UI, so your bars and chat stay readable.
- **Gross fart text**, as an emote: "*Owa Tanka farts, and their tail swishes the stench around so nobody misses out.*" Almost 300 lines: for every race and class, for zones, cities and dungeons, and for what you're doing (mounted, flying, swimming, in combat, at the inn, as a ghost). Zone lines need an English client. A line doesn't come back within 15 farts.
- **Sent as a real `/e` emote**, so other players see it. Switch that off and only you see the text. At most one emote every 20 seconds. WoW only lets addons send chat right after you press a key or click, so the emote of an automatic fart goes out with your next move, jump or click (or shows only in your own chat if you stand still for 30 seconds).
- **Other characters fart too**: your group, your target, your pet and anyone who just did something near you (fighting, casting, `/say`, emotes). Sound gets quieter with distance, and group members sound from their direction (left/right). With nameplates on, characters on screen also get a small cloud attached to their nameplate. Only you hear and see this.
- **Meeting someone**: every new character you see or hear has a chance (5% by default, adjustable) to fart a few seconds later.
- **Your own fart sounds**: see below.
- Settings window with everything on/off, also reachable from the game's AddOns options.

## Commands

| Command | What it does |
|---|---|
| `/brap` | Open or close the settings window |
| `/brap now` | Fart right now |
| `/brap on` / `off` | Automatic farts on or off |
| `/brap status` | Show when the next fart comes |
| `/brap blame` | Make someone nearby fart |
| `/brap debug` | Show who the addon can find nearby |

`/brrraaaappp` works too.

## Your own fart sounds

1. Create the folder `Interface\AddOns\BrrraaaapppCustom\` (next to the `Brrraaaappp` folder, so addon updates don't delete your files).
2. Put your `.ogg` or `.mp3` files in it and restart WoW.
3. In `/brap`, type the file name (for example `myfart` or `myfart.mp3`) and click **Add**. Use **Play** to test.

A game sound ID (a number) also works. If a file can't be played, a built-in fart plays instead. Untick **Built-in farts** to hear only your own.

## Good to know

- Sounds play only on your computer. Addons can't send sound to other players; the `/e` emote is what others see.
- Directional sound uses pre-rendered left/right and volume variants, because addons can't pan or set the volume of a sound.
- Nameplates are optional. With them on (`V`) more characters are found and they get a small cloud. WoW Forever doesn't let addons measure where a nameplate is on screen, so only group members (outside instances) sound from a direction; everyone else sounds from the middle.
- Sound plays on the Master channel. With WoW in the background you only hear it if **Sound in Background** is on.
- The first automatic fart comes 10-30 minutes after login. Every `/reload` starts the wait again.

## Interface version

`Brrraaaappp.toc` targets interface `16001` (WoW Forever 1.60.1). After a patch, check the number in game with `/dump select(4, GetBuildInfo())`.

## Credits

The fart recordings come from [freesound.org](https://freesound.org). The smoke textures and icon were made for this addon.

| File | Original | Author |
|---|---|---|
| `timtube_fart3.ogg` | [fart-3](https://freesound.org/s/61055/) | timtube |
| `dual_fart.ogg` | [dual fart](https://freesound.org/s/80388/) | ifartinurgeneraldirection |
| `bad_chili_fart.ogg` | [bad chili fart](https://freesound.org/s/94989/) | (deleted user) |
| `zippi1_fart5.ogg` | [fart5](https://freesound.org/s/27138/) | zippi1 |
| `smokevhstapes_fart5.ogg` | [fart5](https://freesound.org/s/260961/) | smokevhstapes |
| `aetherzip_fart_long.ogg` | [fart long](https://freesound.org/s/691978/) | aetherzip |
| `teddyferguson_fart.ogg` | [fart](https://freesound.org/s/402569/) | teddyferguson |
| `breviceps_fart3.ogg` | [fart 3](https://freesound.org/s/446000/) | breviceps |
| `nasty_fart.ogg` | [nasty fart](https://freesound.org/s/645339/) | samsterbirdies |
| `frenkfurth_fart50.ogg` | [fart sound 50](https://freesound.org/s/663636/) | frenkfurth |
| `bassimat_fart005.ogg` | [fart 005](https://freesound.org/s/840755/) | bassimat |

The files in `sounds/others/` are left/right and volume variants of six of these.

Fan project, not affiliated with Blizzard Entertainment. World of Warcraft is a trademark of Blizzard Entertainment.
