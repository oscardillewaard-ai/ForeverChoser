-- Brrraaaappp: all the text.
-- Race/class keys are the English file names returned by UnitRace/UnitClass
-- (second return value), so they work in every client language.
local _, ns = ...

-- Fart text for your own farts, written as an emote: the game (or the addon,
-- when the emote is off) puts your name in front, e.g. "Owa Tanka farts, ...".
-- "their" is used because we don't know who's playing.
ns.RACE_LINES = {
  Human = {
    "lets one rip that smells like three-day-old Goldshire stew. The cook quits on the spot.",
    "farts, and Elwynn Forest drops all its leaves at once. Autumn has been invented.",
    "farts so hard a Stormwind guard reaches for the handcuffs. Chemical warfare.",
    "lets out a stench like a sewer under Stormwind that even the Defias refuse to enter.",
  },
  Dwarf = {
    "lets twelve pints of Thunderbrew out the back door. The forges of Ironforge go out in shame.",
    "farts and their beard catches fire. Nobody lit it. The fumes did.",
    "lets one go like a mine collapse. Three kobolds are buried.",
    "releases a bouquet of fermented goat cheese and wet chainmail, and looks secretly proud.",
  },
  NightElf = {
    "farts. Ten thousand years of immortality, and this is what's been building up the whole time.",
    "lets out a smell like a moonwell a furbolg died in.",
    "farts and Teldrassil tilts slightly. Nobody says a word.",
    "tries to Shadowmeld after farting. Useless. They can smell it from Darkshore.",
  },
  Gnome = {
    "squeaks out a tiny toot, radioactive enough to contaminate Gnomeregan all over again.",
    "farts with a cheerful 'peep' and a little green cloud.",
    "farts. Engineering report: 140% efficiency, 0% air quality.",
    "lets one rip that reeks of burnt gears, rotten cabbage and failed inventions.",
  },
  Orc = {
    "roars LOK'TAR! and their backside roars along. A kodo faints.",
    "farts. Smells like the raw boar they swallowed whole three days ago.",
    "farts, and the elements sense a disturbance.",
    "lets one rip. The Horde marches on an empty stomach; this one marches on a full colon.",
  },
  Scourge = {
    "farts and a piece of intestine slides out of their trouser leg. They pick it up and put it back.",
    "lets out the smell of a corpse that's been lying in a swamp for seven years. Which is fair, really.",
    "farts so hard their decay speeds up. A fly lays eggs in their ear.",
    "farts. Deep in Undercity, someone turns around and mutters: 'who did that?'",
  },
  Tauren = {
    "farts with four stomachs' worth of gas. The ground of Mulgore trembles.",
    "releases a cow-pie cloud so big the Earth Mother pinches her nose.",
    "farts, and all grass within twenty yards dies.",
    "farts, and their tail swishes the stench around so nobody misses out.",
  },
  Troll = {
    "lets one rip that smells like raw fish left a week in the Echo Isles sun. Ya mon.",
    "farts. Troll regeneration refills their bowels instantly.",
    "farts. Their voodoo spirits leave their body. Through the bottom.",
    "farts so badly even the raptors keep their distance, mon.",
  },
}

-- Skyborne is new in Forever; its exact race file name is unknown, so this
-- set is used when the race file name contains "sky".
ns.SKYBORNE_LINES = {
  "farts. The wind spirits of Skywall left centuries ago; now we know why.",
  "casts Walk on Air and floats away on their own gas.",
  "farts, and Zephras Isle starts wobbling again.",
  "farts. Wind Blessed? Wind Cursed, more like.",
}

ns.CLASS_LINES = {
  WARRIOR = {
    "does a Battle Shout from the other end. Everyone nearby gets -10 Spirit.",
    "farts. So much rage built up that it just had to come out.",
    "charges, and their pants split open with a thunderous fart.",
    "farts so hard not even plate armor can contain the smell.",
  },
  PALADIN = {
    "farts and casts Divine Shield. On themselves only. The rest of the group dies to the fumes.",
    "lets out the smell of holy water left fermenting for months in a forgotten chapel.",
    "farts. The Light blesses them, then quickly looks away.",
    "casts Blessing of Wind. It lasts five minutes.",
  },
  HUNTER = {
    "farts, and their pet walks back to the stable master in disgust.",
    "farts, and their Feign Death suddenly becomes very convincing.",
    "activates Aspect of the Skunk. It's not in the spellbook, but there it is.",
    "farts. That rhino steak from last week is back.",
  },
  ROGUE = {
    "lets out a silent but deadly one. The guild motto.",
    "farts and their Stealth breaks. Everyone can smell where they are.",
    "farts a poison cocktail. Crippling Poison for the whole zone.",
    "tries to Pick Pocket, but finds something sticky in their own pocket.",
  },
  PRIEST = {
    "casts Holy Nova, but brown. Everyone within 10 yards gets a DoT.",
    "casts Power Word: Stench. It absorbs all fresh air in the area.",
    "farts and prays to the Light for forgiveness. The Light isn't picking up.",
    "farts. That's not Shadowform, that's just the cloud behind them.",
  },
  SHAMAN = {
    "drops a Windfury Totem. A very different kind of wind than the group hoped for.",
    "farts. An Earth Elemental arrives, sniffs, and leaves.",
    "uses Stormstrike from the rear. There's lightning in it too.",
    "farts. The elements have spoken: go find a toilet.",
  },
  MAGE = {
    "casts Arcane Explosion through their robe. Three mana gems melted.",
    "farts. Their Conjured Water will taste a little different today.",
    "farts and Blinks away, but the cloud stays exactly where they were.",
    "farts so badly they Polymorph themselves into a pig, rolling in its own filth.",
  },
  WARLOCK = {
    "farts, and their Voidwalker hands in its resignation.",
    "casts Rain of Fire, but the flames come out of their pants.",
    "farts out a soul shard fragment with a demonic shriek.",
    "farts. Fear no longer needs a cast time: people just run.",
  },
  DRUID = {
    "farts in Bear Form. The whole cave is uninhabitable now.",
    "farts in Cat Form, then sits in the litter box they just filled.",
    "casts Moonfire, but from the wrong moon.",
    "farts, and their Rejuvenation makes the grass grow. Brown.",
  },
}

-- Mixed in now and then, and used for races/classes we don't know.
ns.GENERIC_LINES = {
  "farts. That was a raid-wide debuff.",
  "farts. A green cloud floats above their head with its own nameplate.",
  "farts, and their Hearthstone refuses to take them home.",
  "lets one rip and blames the nearest gnome.",
  "unleashes a fart that could clear a dungeon.",
  "farts and casually looks at the sky.",
}

-- Private chat lines when another character farts. %s = their name.
ns.OTHER_LINES = {
  "%s just let one rip. You can taste it.",
  "%s farts and acts like nothing happened. You know.",
  "A brown cloud rises behind %s.",
  "%s breaks wind. Your eyes water.",
  "Something died inside %s. It's coming out now.",
  "%s squeaks out a tiny toot. Adorable. Disgusting.",
  "%s farts. Somewhere, a druid weeps.",
  "The air around %s turns brown.",
}

-- Private chat lines when someone nearby farts but isn't on your screen. %s = their name.
ns.DISTANT_LINES = {
  "Somewhere nearby, %s lets one rip. The wind carries it to you.",
  "You hear %s fart in the distance. Then you smell it.",
  "A faint 'pfrrt' from %s's direction. Nature is healing.",
  "%s farts somewhere out of sight. The birds stop singing.",
}
