-- Brrraaaappp: all the text.
-- Race/class keys are the English file names returned by UnitRace/UnitClass
-- (second return value), so they work in every client language.
local _, ns = ...

-- Private chat lines for your own farts (only you see these).
ns.RACE_LINES = {
  Human = {
    "You let one rip that smells like three-day-old Goldshire stew. The cook quits on the spot.",
    "Elwynn Forest drops all its leaves at once. Congratulations, you invented autumn.",
    "A Stormwind guard arrests you for chemical warfare.",
    "It smells like a sewer under Stormwind that even the Defias refuse to enter.",
  },
  Dwarf = {
    "Twelve pints of Thunderbrew leave through the back door. The forges of Ironforge go out in shame.",
    "Your beard catches fire. You didn't light it. The fumes did.",
    "That wasn't a fart, that was a mine collapse. Three kobolds are buried.",
    "A bouquet of fermented goat cheese and wet chainmail. You're secretly proud.",
  },
  NightElf = {
    "Ten thousand years of immortality, and this is what's been building up the whole time.",
    "It smells like a moonwell a furbolg died in.",
    "Teldrassil tilts slightly. Nobody says a word.",
    "Shadowmeld won't save you now. They can smell you from Darkshore.",
  },
  Gnome = {
    "A tiny toot, but radioactive enough to contaminate Gnomeregan all over again.",
    "Your pants pop with a cheerful 'peep' and a green cloud.",
    "Engineering report: 140% efficiency, 0% air quality.",
    "It reeks of burnt gears, rotten cabbage and failed inventions.",
  },
  Orc = {
    "LOK'TAR! Your backside roars along. A kodo faints.",
    "Smells like the raw boar you swallowed whole three days ago.",
    "The elements sense a disturbance. It's your butt.",
    "The Horde marches on an empty stomach. Except you. You march on a full colon.",
  },
  Scourge = {
    "A piece of intestine slides out of your trouser leg. You pick it up and put it back.",
    "Smells like a corpse that's been lying in a swamp for seven years. Oh wait, that's you.",
    "Your decay speeds up. A fly lays eggs in your ear.",
    "Deep in Undercity, someone turns around and mutters: 'who did that?'",
  },
  Tauren = {
    "Four stomachs, four times the gas. The ground of Mulgore trembles.",
    "A cow-pie cloud so big the Earth Mother pinches her nose.",
    "All grass within twenty yards is dead. Time to graze somewhere else.",
    "Your tail swishes the stench around so nobody misses out.",
  },
  Troll = {
    "Smells like raw fish left a week in the Echo Isles sun. Ya mon.",
    "Regeneration works on your bowels too. They refill instantly.",
    "Your voodoo spirits leave your body. Through the bottom.",
    "Even the raptors keep their distance, mon. That says enough.",
  },
}

-- Skyborne is new in Forever; its exact race file name is unknown, so this
-- set is used when the race file name contains "sky".
ns.SKYBORNE_LINES = {
  "The wind spirits of Skywall left centuries ago. Now you know why.",
  "Walk on Air finally works properly: you're floating on your own gas.",
  "Zephras Isle is wobbling again. That's the stink cloud underneath.",
  "Wind Blessed? Wind Cursed, more like.",
}

ns.CLASS_LINES = {
  WARRIOR = {
    "Battle Shout, but from the other end. Everyone nearby gets -10 Spirit.",
    "So much rage built up that it just had to come out. With chunks.",
    "Charge! Your pants split open and breakfast nearly follows.",
    "Not even your plate armor can contain this smell.",
  },
  PALADIN = {
    "Divine Shield only protects you. The rest of the raid dies to the fumes.",
    "Smells like holy water left fermenting for months in a forgotten chapel.",
    "The Light blesses you... then quickly looks away.",
    "Blessing of Wisdom? No. Blessing of Wind. Lasts five minutes.",
  },
  HUNTER = {
    "Your pet refuses to follow and walks back to the stable master.",
    "Your Feign Death is finally convincing: you smell exactly like a corpse.",
    "Aspect of the Skunk. It's not in your spellbook, but you have it anyway.",
    "You ate a rhino steak last week. It's back.",
  },
  ROGUE = {
    "Silent but deadly. Your guild's motto.",
    "Your Stealth breaks because everyone can smell you.",
    "A poison cocktail in your pants. Crippling Poison for the whole zone.",
    "Your Pick Pocket fails. There was something sticky in your own pocket.",
  },
  PRIEST = {
    "Holy Nova, but brown. Everyone within 10 yards gets a DoT.",
    "Power Word: Stench. Absorbs all fresh air in the area.",
    "You pray to the Light for forgiveness. The Light isn't picking up.",
    "Shadowform? No, that's just the color of the cloud behind you.",
  },
  SHAMAN = {
    "Windfury Totem placed. A very different kind of wind than your group hoped for.",
    "You summon an Earth Elemental. It arrives, sniffs, and leaves.",
    "Stormstrike, but from the rear. There's lightning in it too.",
    "The elements speak to you. They say: go find a toilet.",
  },
  MAGE = {
    "Arcane Explosion, but through your robe. Three mana gems melted.",
    "Your Conjured Water tastes a little... different today.",
    "Polymorph on yourself: you're now a piglet rolling in its own filth.",
    "Blink! You teleport, but the cloud stays exactly where you were.",
  },
  WARLOCK = {
    "Your Voidwalker hands in its resignation. Even the Twisting Nether smells fresher.",
    "Rain of Fire, but the flames come out of your pants.",
    "You swallowed a soul shard fragment. It comes out with a demonic shriek.",
    "Fear now has no cast time. People just run from your smell.",
  },
  DRUID = {
    "You let one go in Bear Form. The whole cave is uninhabitable now.",
    "In Cat Form you sit in the litter box you just filled yourself.",
    "Moonfire, but from the wrong moon.",
    "Your Rejuvenation makes the grass grow, but it grows brown.",
  },
}

ns.GENERIC_LINES = {
  "That wasn't a fart. That was a raid-wide debuff.",
  "A green cloud floats above your head with its own nameplate.",
  "Your Hearthstone refuses to take you home.",
}

-- /e emotes. Other players see these! The game puts your name in front.
ns.EMOTE_LINES = {
  "lets out a fart so loud the local wildlife flees.",
  "farts. The air around here will never be the same.",
  "releases a brown cloud and pretends nothing happened.",
  "lets one rip and blames the nearest gnome.",
  "breaks wind with the force of a Windfury Totem.",
  "farts so hard their armor rattles.",
  "squeezes out a squeaky little toot.",
  "unleashes a fart that could clear a dungeon.",
  "farts and casually looks at the sky.",
  "lets out a long, wet one. Nobody is safe.",
  "farts. A nearby critter faints.",
  "trumpets a mighty fart in your general direction.",
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
