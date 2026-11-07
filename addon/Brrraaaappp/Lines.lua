-- Brrraaaappp: walgelijke zinnen per race en per class.
-- Sleutels zijn de Engelse bestandsnamen die UnitRace/UnitClass teruggeven
-- (de tweede returnwaarde), dus ze werken in elke taal van de client.
local _, ns = ...

ns.RACE_LINES = {
  Human = {
    "Je laat er eentje vliegen die ruikt naar drie dagen oude Goldshire-stoofpot. De kok neemt ontslag.",
    "Elwynn Forest verliest spontaan al z'n bladeren. Je hebt de herfst uitgevonden.",
    "Een Stormwind-guard arresteert je wegens chemische oorlogvoering.",
    "Ruikt naar een riool onder Stormwind waar zelfs de Defias niet meer durven te komen.",
  },
  Dwarf = {
    "Twaalf pinten Thunderbrew komen er via de achterdeur uit. Ironforge's smeltovens doven uit schaamte.",
    "Je baard vat vlam. Je hebt hem niet aangestoken. De gassen deden het zelf.",
    "Dat was geen scheet, dat was een mijnexplosie. Er zijn drie kobolds bedolven.",
    "Een geur van gegiste geitenkaas en natte maliënkolder. Je bent er stiekem trots op.",
  },
  NightElf = {
    "Tienduizend jaar onsterfelijkheid, en dit is wat er al die tijd binnen heeft gezeten.",
    "Het ruikt naar een maanbron waar een Furbolg in is overleden.",
    "Teldrassil zakt een stukje scheef. Niemand zegt er iets van.",
    "Shadowmeld helpt niet meer. Ze kunnen je nu ruiken vanuit Darkshore.",
  },
  Gnome = {
    "Een klein scheetje, maar het bevat genoeg radioactiviteit om Gnomeregan nog eens te besmetten.",
    "Je broekje ontploft met een vrolijk 'piep' en een groene wolk.",
    "Ingenieursrapport: 140% rendement, 0% luchtkwaliteit.",
    "Het stinkt naar verbrande tandwielen, rotte kool en mislukte uitvindingen.",
  },
  Orc = {
    "LOK'TAR! Je anus brult mee. Een Kodo valt flauw.",
    "Ruikt naar rauw everzwijn dat je drie dagen geleden zonder kauwen hebt doorgeslikt.",
    "Thrall voelt een verstoring in de elementen. Het is jouw kont.",
    "De Horde marcheert op een lege maag. Behalve jij. Jij marcheert op een volle darm.",
  },
  Scourge = {
    "Er valt een stukje darm uit je broekspijp. Je raapt het op en stopt het terug.",
    "Ruikt naar een lijk dat al zeven jaar in een moeras ligt. Oh wacht, dat bén je.",
    "Je ontbinding gaat sneller. Een vlieg legt eieren in je oor.",
    "De Banshee Queen draait zich om in Undercity en mompelt: 'wie heeft dat gedaan?'",
  },
  Tauren = {
    "Vier magen, vier keer zoveel gas. De grond van Mulgore trilt.",
    "Een koeienvlaai-wolk zo groot dat de Earth Mother haar neus dichtknijpt.",
    "Het gras in een straal van twintig meter is dood. Je moet weer verder grazen.",
    "Je staart zwaait de stank netjes rond, zodat niemand iets mist.",
  },
  Troll = {
    "Ruikt naar rauwe vis die een week in de zon heeft gelegen in Echo Isles. Jullie zijn goed, mon.",
    "Regeneratie werkt ook op je darmen. Ze vullen zich meteen weer bij.",
    "Je voodoo-geesten verlaten je lichaam. Via de onderkant.",
    "Zelfs de raptors houden afstand, mon. Dat zegt genoeg.",
  },
}

-- Skyborne is nieuw in Forever; de exacte raceFile is niet bekend, dus deze
-- set wordt gebruikt als de racenaam "sky" bevat.
ns.SKYBORNE_LINES = {
  "De windgeesten van Skywall zijn eeuwen geleden vertrokken. Nu weet je waarom.",
  "Walk on Air werkt eindelijk naar behoren: je zweeft op je eigen gas.",
  "Zephras Isle hapert weer. Dat komt door die enorme stinkwolk eronder.",
  "Wind Blessed? Wind Cursed, zul je bedoelen.",
}

ns.CLASS_LINES = {
  WARRIOR = {
    "Je gebruikt Battle Shout, maar dan van achteren. Iedereen in de buurt krijgt -10 Spirit.",
    "Zo veel rage opgebouwd dat het er nu gewoon uit moet. Met brokken.",
    "Charge! Je broek scheurt open en je ex-ontbijt komt er bijna achteraan.",
    "Zelfs je plate armor kan deze geur niet tegenhouden.",
  },
  PALADIN = {
    "Divine Shield beschermt alleen jezelf. De rest van de raid sterft aan de dampen.",
    "Ruikt naar heilig water dat al maanden in een vergeten kerk staat te gisten.",
    "Het Licht zegent je... en draait zich daarna snel om.",
    "Blessing of Wisdom? Nee. Blessing of Wind. Vijf minuten lang.",
  },
  HUNTER = {
    "Je pet weigert te volgen en loopt terug naar de stable.",
    "Je Feign Death is eindelijk overtuigend: je ruikt precies als een lijk.",
    "Aspect of the Skunk. Hij staat niet in je spellbook, maar je hebt hem toch.",
    "Je hebt een Rhino-steak van vorige week gegeten. Die is er nu weer.",
  },
  ROGUE = {
    "Stilletjes, onzichtbaar, maar dodelijk. Silent but deadly, het motto van je guild.",
    "Je Stealth wordt verbroken omdat iedereen je kan ruiken.",
    "Een gifcocktail in je broek. Crippling Poison voor de hele regio.",
    "Je Pick Pocket mislukt. Er zat iets kleverigs in je eigen zak.",
  },
  PRIEST = {
    "Holy Nova, maar dan bruin. Iedereen in 10 meter krijgt een DoT.",
    "Power Word: Stank. Absorbeert alle frisse lucht in de omgeving.",
    "Je bidt tot het Licht om vergeving. Het Licht neemt niet op.",
    "Shadow Form? Nee, dat is gewoon de kleur van de wolk achter je.",
  },
  SHAMAN = {
    "Windfury Totem gezet. Een heel ander soort wind dan je groep had gehoopt.",
    "Je roept een Earth Elemental op. Hij komt, ruikt, en vertrekt weer.",
    "Stormstrike, maar dan uit je onderkant. Er zit nog bliksem in ook.",
    "De elementen spreken tot je. Ze zeggen: ga even naar de wc.",
  },
  MAGE = {
    "Arcane Explosion, maar via je broek. Drie mana-gems gesmolten.",
    "Je Conjure Water ruikt sinds vandaag een beetje... anders.",
    "Polymorph op jezelf: je bent nu een biggetje dat in z'n eigen viezigheid ligt.",
    "Blink! Je teleporteert, maar de wolk blijft gewoon staan waar je was.",
  },
  WARLOCK = {
    "Je Voidwalker vraagt om ontslag. Zelfs de Twisting Nether ruikt frisser.",
    "Rain of Fire, maar de vlammen komen uit je broek.",
    "Je hebt een stukje soul shard ingeslikt. Het komt er nu met een demonisch gekrijs uit.",
    "Fear werkt nu zonder cast time. Mensen rennen gewoon weg van je geur.",
  },
  DRUID = {
    "Je laat er eentje in Bear Form. De hele grot is onbewoonbaar.",
    "In Cat Form ga je in de kattenbak zitten die je zelf net hebt vol gemaakt.",
    "Moonfire, maar dan vanuit de verkeerde maan.",
    "Je Rejuvenation laat het gras groeien, maar het is bruin.",
  },
}

ns.GENERIC_LINES = {
  "Dat was geen scheet. Dat was een raid-wide debuff.",
  "Er drijft een groene wolk boven je hoofd met een eigen nameplate.",
  "Je Hearthstone wil je niet meer naar huis brengen.",
}
