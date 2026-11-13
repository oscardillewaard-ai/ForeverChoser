-- Brrraaaappp: more fart text. Race, class, zone and situation lines.
-- Same rules as Lines.lua: emote text that follows the character's name.
local _, ns = ...

local function extend(list, more)
  for _, line in ipairs(more) do list[#list + 1] = line end
end

-- Races ---------------------------------------------------------------------

extend(ns.RACE_LINES.Human, {
  "farts with the confidence of someone who has never had to explain themselves to a Stormwind noble.",
  "lets one rip that sounds suspiciously like the Stormwind city bells.",
  "farts. Somewhere in Goldshire, the bard stops playing.",
  "releases a cloud that smells like a farmhouse in Westfall after the harvest went wrong.",
  "farts and tries to blame it on the Defias Brotherhood.",
  "farts. Proud, noble, and thoroughly human.",
})
extend(ns.RACE_LINES.Dwarf, {
  "lets one rip that echoes through the deeprun tunnels.",
  "farts, and a nearby forge flares up blue.",
  "farts and blames it on the ram. The ram is offended.",
  "lets out a blast that could clear a cave-in.",
  "farts in perfect rhythm with the hammer strikes of Ironforge.",
  "farts. The Explorers' League marks it as a new discovery.",
})
extend(ns.RACE_LINES.NightElf, {
  "farts, and a wisp drifts away in disgust.",
  "lets out an ancient, elegant fart that has been aging for centuries.",
  "farts. The moon briefly hides behind a cloud.",
  "farts so gracefully it almost sounds like a lullaby. Almost.",
  "farts, and the trees whisper about it for a hundred years.",
  "releases a fart that smells faintly of moonpetals and regret.",
})
extend(ns.RACE_LINES.Gnome, {
  "farts and immediately takes notes for a patent.",
  "toots like a tiny steam whistle.",
  "farts. A mechanostrider nearby beeps in alarm.",
  "lets out a fart powered by questionable engineering.",
  "farts and blames a faulty gyro-whatsit.",
  "farts. Small body, unreasonably large cloud.",
})
extend(ns.RACE_LINES.Orc, {
  "farts with the honour of the Horde.",
  "lets out a war-drum of a fart. Somewhere, grunts start marching.",
  "farts, and their wolf howls along.",
  "farts and grunts: 'Zug zug.'",
  "farts like a catapult loosing a stone.",
  "farts. Blood and thunder! Mostly thunder.",
})
extend(ns.RACE_LINES.Scourge, {
  "farts, and something falls off. They don't check what.",
  "farts. The Forsaken have no shame left, and no working sphincter either.",
  "releases a gust that smells like an apothecary's failed experiment.",
  "farts, and a bat flies out of their ribcage.",
  "farts a little cloud of grave dust.",
  "farts. It's the only part of them that's still warm.",
})
extend(ns.RACE_LINES.Tauren, {
  "farts like a stampede of kodos.",
  "lets out a deep, earthy rumble. The plains answer.",
  "farts so hard the totem poles wobble.",
  "farts. The grass bows down, then doesn't get back up.",
  "farts with the patience and power of the Earth Mother herself.",
  "lets one go, then calmly continues grazing.",
})
extend(ns.RACE_LINES.Troll, {
  "farts and laughs: 'Stay away from da voodoo, mon!'",
  "farts so hard their tusks rattle.",
  "lets one rip, then does a little dance.",
  "farts. Da loa are not amused, mon.",
  "farts a cloud that smells like swamp, fish and bad decisions.",
  "farts, then blames it on a raptor. There is no raptor.",
})
extend(ns.SKYBORNE_LINES, {
  "farts and gently rises a few inches off the ground.",
  "lets out a breeze that the island's wind spirits refuse to claim.",
  "farts, and their hair blows dramatically in the wind.",
  "farts. It's not a storm, it's just them.",
})

-- Classes -------------------------------------------------------------------

extend(ns.CLASS_LINES.WARRIOR, {
  "farts with the force of a Thunder Clap.",
  "uses Intimidating Shout. From the wrong end.",
  "farts, and it counts as a taunt. Everything nearby now hates them.",
  "farts in Berserker Stance. No regrets.",
  "farts so hard they gain 15 rage.",
  "lets out a Demoralizing Shout. Everyone nearby loses the will to live.",
})
extend(ns.CLASS_LINES.PALADIN, {
  "farts in the name of the Light.",
  "casts Consecration, but brown. Nobody wants to stand in it.",
  "farts, and their aura becomes Aura of Stench.",
  "uses Lay on Hands on themselves after that one.",
  "farts with righteous fury.",
  "farts. Judgement has been passed.",
})
extend(ns.CLASS_LINES.HUNTER, {
  "farts and sets a Freezing Trap. Nobody can escape the smell.",
  "casts Volley. From behind.",
  "farts, and their pet tries to Mend Pet on itself.",
  "uses Scatter Shot, but with gas.",
  "farts and Tracks Humanoids by smell alone.",
  "lets one rip and blames the pet. The pet knows.",
})
extend(ns.CLASS_LINES.ROGUE, {
  "farts and Vanishes. The smell does not.",
  "uses Gouge on everyone's nostrils.",
  "farts from Stealth. Nobody knows who did it. Everyone suspects.",
  "farts and uses Sprint to get away from it.",
  "lets out a Blind. Literally. Eyes are watering.",
  "farts. Combo points: five.",
})
extend(ns.CLASS_LINES.PRIEST, {
  "farts and casts Fade. The smell keeps the threat.",
  "casts Psychic Scream from the back end. Everyone runs.",
  "farts, and their Renew ticks. And ticks. And ticks.",
  "farts and offers a quick prayer for everyone nearby.",
  "casts Mind Flay on the noses of everyone nearby.",
  "farts. Inner Fire, outer gas.",
})
extend(ns.CLASS_LINES.SHAMAN, {
  "drops a Stoneclaw Totem. It's the only thing brave enough to stand near them.",
  "farts and casts Chain Lightning. It jumps to three noses.",
  "farts and switches to Ghost Wolf to escape the scene.",
  "drops a Healing Stream Totem. It doesn't help.",
  "farts, and their Lightning Shield crackles brown.",
  "farts. The earth trembles, the fire flickers, the water ripples, the air gives up.",
})
extend(ns.CLASS_LINES.MAGE, {
  "casts Frost Nova. Everyone is rooted in the smell.",
  "farts and casts Slow Fall to drift away from it.",
  "casts Fireball. It came out the wrong end.",
  "farts and conjures some food to cover the smell. It doesn't work.",
  "farts and opens a portal. Nobody wants to go through.",
  "casts Arcane Intellect on everyone. Now they can all understand exactly what happened.",
})
extend(ns.CLASS_LINES.WARLOCK, {
  "casts Curse of Agony. It smells.",
  "farts, and their Imp laughs uncontrollably.",
  "casts Drain Life. On the fresh air.",
  "farts and summons a Succubus. She immediately leaves.",
  "farts and casts Howl of Terror. Same effect, honestly.",
  "farts a Corruption that ticks for 18 seconds.",
})
extend(ns.CLASS_LINES.DRUID, {
  "farts in Travel Form and leaves a brown trail behind.",
  "casts Entangling Roots. The victims can't escape the smell.",
  "farts in Moonkin Form. It's somehow worse.",
  "farts in Aquatic Form. Bubbles everywhere.",
  "casts Hurricane. Gas, not wind.",
  "farts, and nature takes its course.",
})

extend(ns.GENERIC_LINES, {
  "farts. The quest log updates: 'Survive the smell (0/1)'.",
  "lets out a fart that would make an abomination blush.",
  "farts and pretends to look at their map.",
  "farts. Achievement earned: Silent Is Not an Option.",
  "farts and blames lag.",
  "farts. Somewhere, a murloc goes 'Mrgggl?'",
})

-- Zones (English zone names, as GetRealZoneText returns on an English client) --

ns.ZONE_LINES = {
  ["Elwynn Forest"] = {
    "farts, and a Hogger-sized gnoll somewhere sniffs the air.",
    "farts. The Elwynn wolves stop chasing anyone for a moment.",
  },
  ["Westfall"] = {
    "farts in Westfall. The Harvest Watchers fall over.",
    "farts, and the dust devils of Westfall pick up a brown tint.",
  },
  ["Duskwood"] = {
    "farts in Duskwood. Even the worgen won't come closer.",
    "farts. The Night Watch reports a new threat to Darkshire.",
  },
  ["Redridge Mountains"] = {
    "farts, and the gnolls of Redridge raise a white flag.",
    "farts. Lakeshire's fishermen pull up their nets in silence.",
  },
  ["Stranglethorn Vale"] = {
    "farts in Stranglethorn. A tiger loses the will to hunt.",
    "farts. Somewhere in Booty Bay, a pirate says: 'Yarr, that be foul.'",
  },
  ["Dun Morogh"] = {
    "farts, and the snow of Dun Morogh melts in a small brown circle.",
    "farts. The troggs think it's one of theirs.",
  },
  ["Loch Modan"] = {
    "farts, and the Stonewrought Dam develops a new crack.",
  },
  ["Wetlands"] = {
    "farts in the Wetlands. Honestly, nobody notices the difference.",
    "farts, and the raptors of the Wetlands sink back into the mud.",
  },
  ["Teldrassil"] = {
    "farts on Teldrassil. The World Tree shudders.",
  },
  ["Darkshore"] = {
    "farts, and the waves of Darkshore roll back in disgust.",
  },
  ["Ashenvale"] = {
    "farts in Ashenvale. The ancients of the forest wake up and leave.",
  },
  ["Durotar"] = {
    "farts in Durotar. The scorpids go back under their rocks.",
    "farts. The dry Durotar air makes it travel for miles.",
  },
  ["Mulgore"] = {
    "farts across the open plains of Mulgore. The wind carries it to Thunder Bluff.",
    "farts, and the plainstriders of Mulgore stampede the other way.",
  },
  ["Tirisfal Glades"] = {
    "farts in Tirisfal. Brill smells about the same as before.",
    "farts, and the Scarlet Crusade calls it a plague.",
  },
  ["Silverpine Forest"] = {
    "farts in Silverpine. The worgen howl in protest.",
  },
  ["The Barrens"] = {
    "farts in the Barrens. General chat immediately starts arguing about it.",
    "farts. Somewhere, someone asks in chat where Mankrik's wife is. Nobody answers. Everyone smelled it.",
    "farts, and the zhevras of the Barrens run for the horizon.",
  },
  ["Stonetalon Mountains"] = {
    "farts, and the harpies of Stonetalon fly off screeching.",
  },
  ["Thousand Needles"] = {
    "farts in Thousand Needles. It echoes off every single needle.",
  },
  ["Desolace"] = {
    "farts in Desolace. It's the most interesting thing that's happened here in weeks.",
  },
  ["Tanaris"] = {
    "farts in Tanaris. The sand turns to glass.",
    "farts, and a goblin in Gadgetzan tries to sell bottled versions.",
  },
  ["Feralas"] = {
    "farts in Feralas. The giants step around them.",
  },
  ["Dustwallow Marsh"] = {
    "farts in Dustwallow Marsh. The bog bubbles back.",
  },
  ["Un'Goro Crater"] = {
    "farts in Un'Goro. A devilsaur stops, sniffs, and decides they're not worth eating.",
  },
  ["Silithus"] = {
    "farts in Silithus. The silithid hive goes quiet.",
  },
  ["Winterspring"] = {
    "farts in Winterspring. The cloud freezes in mid-air.",
  },
  ["Felwood"] = {
    "farts in Felwood. Fel or fart, nobody can tell anymore.",
  },
  ["Azshara"] = {
    "farts in Azshara. Ancient ruins collapse a little further.",
  },
  ["Moonglade"] = {
    "farts in sacred Moonglade. The druids hold an emergency council.",
  },
  ["Hillsbrad Foothills"] = {
    "farts in Hillsbrad. Southshore and Tarren Mill blame each other.",
  },
  ["Alterac Mountains"] = {
    "farts in the Alterac Mountains. An avalanche warning is issued.",
  },
  ["Arathi Highlands"] = {
    "farts in the Arathi Highlands. The ogres think it's a challenge.",
  },
  ["The Hinterlands"] = {
    "farts in the Hinterlands. The gryphons of Aerie Peak refuse to land.",
  },
  ["Badlands"] = {
    "farts in the Badlands. The landscape somehow gets worse.",
  },
  ["Searing Gorge"] = {
    "farts in the Searing Gorge. The lava cools down out of respect.",
  },
  ["Burning Steppes"] = {
    "farts in the Burning Steppes. The black dragonflight smells it from the mountain.",
  },
  ["Swamp of Sorrows"] = {
    "farts in the Swamp of Sorrows. It suddenly makes sense why it's called that.",
  },
  ["Blasted Lands"] = {
    "farts in the Blasted Lands. The Dark Portal trembles.",
  },
  ["Deadwind Pass"] = {
    "farts in Deadwind Pass. The name finally makes sense.",
  },
  ["Western Plaguelands"] = {
    "farts in the Western Plaguelands. A new plague has been released.",
  },
  ["Eastern Plaguelands"] = {
    "farts in the Eastern Plaguelands. The Scourge files a complaint.",
  },
  ["Zephras Isle"] = {
    "farts on Zephras Isle. The whole island dips a few feet.",
    "farts, and the floating island wobbles in the wind.",
  },
  -- Cities
  ["Stormwind City"] = {
    "farts in the Trade District. The auction house prices drop.",
    "farts in Stormwind. The canal water turns a darker shade.",
  },
  ["Ironforge"] = {
    "farts in Ironforge. It echoes off the Great Forge for a full minute.",
    "farts in front of the bank in Ironforge. Everyone suddenly remembers they have somewhere else to be.",
  },
  ["Darnassus"] = {
    "farts in Darnassus. The sentinels draw their glaives.",
  },
  ["Orgrimmar"] = {
    "farts in the Valley of Strength. The grunts salute.",
    "farts in Orgrimmar. The auction house goblin raises his prices to cover cleaning costs.",
  },
  ["Thunder Bluff"] = {
    "farts on Thunder Bluff. The elevators get a little lift.",
  },
  ["Undercity"] = {
    "farts in Undercity. Nobody can tell the difference.",
    "farts in Undercity. The green sludge in the canals ripples.",
  },
  -- Dungeons and raids
  ["The Deadmines"] = {
    "farts in the Deadmines. The cannon goes off by itself.",
  },
  ["Wailing Caverns"] = {
    "farts in the Wailing Caverns. The wailing gets louder.",
  },
  ["Ragefire Chasm"] = {
    "farts in Ragefire Chasm. Now there's rage AND fire.",
  },
  ["Shadowfang Keep"] = {
    "farts in Shadowfang Keep. Arugal regrets ever leaving his study.",
  },
  ["The Stockade"] = {
    "farts in the Stockade. The prisoners riot to get out.",
  },
  ["Blackfathom Deeps"] = {
    "farts in Blackfathom Deeps. Bubbles rise to the surface.",
  },
  ["Gnomeregan"] = {
    "farts in Gnomeregan. The radiation levels actually drop.",
  },
  ["Razorfen Kraul"] = {
    "farts in Razorfen Kraul. The quilboar feel right at home.",
  },
  ["Scarlet Monastery"] = {
    "farts in the Scarlet Monastery. The Crusade declares it heresy.",
  },
  ["Uldaman"] = {
    "farts in Uldaman. An ancient stone keeper wakes up just to leave.",
  },
  ["Zul'Farrak"] = {
    "farts in Zul'Farrak. The trolls on the stairs give up.",
  },
  ["Maraudon"] = {
    "farts in Maraudon. Princess Theradras feels right at home.",
  },
  ["Blackrock Depths"] = {
    "farts in Blackrock Depths. The Dark Iron dwarves raise their mugs.",
  },
  ["Stratholme"] = {
    "farts in Stratholme. The city was already lost anyway.",
  },
  ["Scholomance"] = {
    "farts in the Scholomance. The students take notes.",
  },
  ["Molten Core"] = {
    "farts in Molten Core. Ragnaros himself says: 'TOO SOON!'",
    "farts in Molten Core. The lava pools bubble in sympathy.",
  },
  ["Onyxia's Lair"] = {
    "farts in Onyxia's Lair. Onyxia takes a deep breath. Big mistake.",
  },
}

-- Situations ------------------------------------------------------------------

ns.SITUATION_LINES = {
  taxi = {
    "farts mid-flight. The flight master will hear about this.",
    "farts on the flight path. Everyone below looks up.",
    "farts while flying. The beast carrying them speeds up.",
  },
  mounted = {
    "farts in the saddle. Their mount turns around and gives them a look.",
    "farts while riding. The mount speeds up, trying to outrun it.",
    "farts on their mount. The saddle will never be the same.",
  },
  swimming = {
    "farts underwater. A trail of bubbles rises. The fish leave.",
    "farts while swimming. Nobody wants to swim behind them now.",
  },
  ghost = {
    "farts as a ghost. Even the Spirit Healer recoils.",
    "farts in spirit form. Death didn't fix it.",
  },
  combat = {
    "farts mid-fight. The enemy hesitates.",
    "farts in combat. A critical strike on everyone's nose.",
    "farts during the fight. It's super effective.",
  },
  resting = {
    "farts by the hearth. The innkeeper adds it to their tab.",
    "farts in the inn. Everyone suddenly finishes their drinks.",
    "farts while resting. The rested XP bar drops a little.",
  },
  instance = {
    "farts in the dungeon. The tank loses threat to the smell.",
    "farts during the pull. The healer considers letting them die.",
    "farts in the instance. Nobody can leave.",
  },
  indoors = {
    "farts indoors. There's nowhere for it to go.",
    "farts inside. The walls absorb it forever.",
  },
}

-- More lines when someone else farts --------------------------------------------

extend(ns.OTHER_LINES, {
  "%s farts and looks right at you. Bold.",
  "%s lets out a squeaky one and pretends it was their boots.",
  "%s farts. The local wildlife reconsiders its life choices.",
  "%s farts so loud you hear it over the music.",
  "%s farts and walks away like nothing happened. Classic.",
  "A suspicious brown haze drifts away from %s.",
})
extend(ns.DISTANT_LINES, {
  "From somewhere out of sight, %s lets out a long, sad fart.",
  "The wind changes. %s must have farted.",
})
