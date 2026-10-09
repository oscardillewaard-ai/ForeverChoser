// Vragen en inhoud voor de spellen. Elk antwoord van de Orakel-quiz telt op bij
// eigenschappen (TRAITS); classes hebben een eigen eigenschappenprofiel.

export const QUIZ = [
  {
    q: 'Je loopt Elwynn Forest uit en ziet vier Defias-bandieten bij een kampvuur. Wat doe je?',
    a: [
      { t: 'Erop af! Ik spring er middenin.', w: { melee: 2, tank: 1, physical: 1 } },
      { t: 'Ik schakel ze één voor één uit vanaf een afstand.', w: { ranged: 2, control: 1 } },
      { t: 'Ik sluip eromheen en kies zelf mijn moment.', w: { stealth: 2, burst: 1 } },
      { t: 'Ik stuur mijn trouwe metgezel vooruit.', w: { pet: 2, solo: 1 } },
    ],
  },
  {
    q: 'Welke kracht trekt je het meest aan?',
    a: [
      { t: 'Arcane magie: vuur en ijs naar mijn hand zetten.', w: { magic: 2, ranged: 1, burst: 1 } },
      { t: 'Het heilige Licht, dat geneest én straft.', w: { light: 2, heal: 1 } },
      { t: 'De elementen en de geesten van de natuur.', w: { nature: 2, hybrid: 1 } },
      { t: 'Verboden schaduwmagie en demonen.', w: { dark: 2, magic: 1 } },
      { t: 'Geen magie. Staal, spieren en techniek.', w: { physical: 2, melee: 1 } },
    ],
  },
  {
    q: 'Je groep staat op het punt te sneuvelen in een dungeon. Wat doe jij?',
    a: [
      { t: 'Ik vang de klappen op zodat de rest kan ontsnappen.', w: { tank: 2 } },
      { t: 'Ik houd iedereen op de been met een laatste heal.', w: { heal: 2 } },
      { t: 'Ik sla de baas neer voordat het misgaat.', w: { burst: 2 } },
      { t: 'Ik bevries of stun alles en regel een uitweg.', w: { control: 2 } },
    ],
  },
  {
    q: 'Hoeveel knoppen wil je eigenlijk indrukken?',
    a: [
      { t: 'Hoe meer hoe beter: ik wil elke seconde iets doen.', w: { complex: 2 } },
      { t: 'Een paar sterke knoppen, precies op het goede moment.', w: { simple: 1, burst: 1 } },
      { t: 'Rustig aan, ik wil ook om me heen kunnen kijken.', w: { simple: 2 } },
    ],
  },
  {
    q: 'Hoe speel je het liefst?',
    a: [
      { t: 'Alleen, op mijn eigen tempo.', w: { solo: 2 } },
      { t: 'Met vrienden of een guild: dungeons en raids.', w: { heal: 1, tank: 1 } },
      { t: 'Een beetje van allebei.', w: { hybrid: 1, solo: 1 } },
      { t: 'Ik wil vooral andere spelers verslaan (PvP).', w: { burst: 1, control: 1, stealth: 1 } },
    ],
  },
  {
    q: 'Welk wapen hangt er aan je riem?',
    a: [
      { t: 'Een enorm tweehandig zwaard of bijl.', w: { melee: 2, physical: 1, burst: 1 } },
      { t: 'Twee vlijmscherpe dolken.', w: { stealth: 1, melee: 1, complex: 1 } },
      { t: 'Een boog of een geweer.', w: { ranged: 2, physical: 1 } },
      { t: 'Een staf vol gloeiende runen.', w: { magic: 2, ranged: 1 } },
      { t: 'Een schild en een strijdhamer.', w: { tank: 1, light: 1, melee: 1 } },
    ],
  },
  {
    q: 'Wat neem je mee als metgezel?',
    a: [
      { t: 'Een wolf, kat of beer die naast me vecht.', w: { pet: 2, nature: 1 } },
      { t: 'Een demon die ik aan mijn wil onderwerp.', w: { pet: 1, dark: 2 } },
      { t: 'Geen huisdier: ik wórd zelf het beest.', w: { shapeshift: 2, nature: 1 } },
      { t: 'Niemand. Ik vertrouw alleen op mezelf.', w: { solo: 1, physical: 1 } },
    ],
  },
  {
    q: 'Je gaat dood tegen een elite-monster. Wat nu?',
    a: [
      { t: 'Opnieuw, en harder erin!', w: { melee: 1, burst: 1 } },
      { t: 'Ik analyseer en optimaliseer mijn aanpak.', w: { complex: 1, control: 1 } },
      { t: 'Volgende keer zorg ik dat ik meer kan hebben.', w: { tank: 1, heal: 1 } },
      { t: 'Ik laat mijn pet het gevecht doen en kijk toe.', w: { pet: 1, simple: 1 } },
    ],
  },
  {
    q: 'Wat is het mooiste moment in een gevecht?',
    a: [
      { t: 'Een gigantische kritieke treffer zien verschijnen.', w: { burst: 2 } },
      { t: 'Een teamgenoot met nog 1 HP redden.', w: { heal: 2 } },
      { t: 'Alle vijanden netjes op mij gericht houden.', w: { tank: 2 } },
      { t: 'Een vijand vastzetten terwijl hij machteloos toekijkt.', w: { control: 2 } },
      { t: 'Toekijken hoe mijn vloeken langzaam hun werk doen.', w: { dark: 1, magic: 1, simple: 1 } },
      { t: 'Samen met mijn metgezel een prooi neerhalen.', w: { pet: 2, ranged: 1 } },
    ],
  },
  {
    q: 'Welke sfeer past bij jou?',
    a: [
      { t: 'Heldhaftig en nobel.', w: { light: 2 } },
      { t: 'Mysterieus en duister.', w: { dark: 2, stealth: 1 } },
      { t: 'Wild en natuurlijk.', w: { nature: 2, shapeshift: 1 } },
      { t: 'Geleerd en arcaan.', w: { magic: 2 } },
      { t: 'Rauw en strijdlustig.', w: { physical: 2, melee: 1 } },
      { t: 'Vrij en avontuurlijk, ver weg in de wildernis.', w: { solo: 1, nature: 1, ranged: 1 } },
    ],
  },
  {
    q: 'Je mag één bijzondere gave kiezen. Welke?',
    a: [
      { t: 'Onzichtbaar worden.', w: { stealth: 2 } },
      { t: 'Teleporteren en eten uit het niets toveren.', w: { magic: 2 } },
      { t: 'Iemand uit de dood terughalen.', w: { heal: 2, light: 1 } },
      { t: 'In een beer, kat of zeehond veranderen.', w: { shapeshift: 2 } },
      { t: 'Een vriend naar me toe roepen met een ritueel.', w: { dark: 1, magic: 1, pet: 1 } },
      { t: 'Totems neerzetten die mijn groep versterken.', w: { nature: 1, hybrid: 1 } },
    ],
  },
  {
    q: 'Welke speelstijl klinkt het best?',
    a: [
      { t: 'Specialist: één ding heel goed kunnen.', w: { hybrid: -1, burst: 1 } },
      { t: 'Hybride: kunnen wisselen tussen rollen.', w: { hybrid: 2 } },
      { t: 'Vooral makkelijk en snel levelen.', w: { solo: 2, simple: 1 } },
      { t: 'Een uitdaging: lastig, maar briljant als je het kunt.', w: { complex: 2 } },
    ],
  },
];

export const RACE_QUIZ = [
  {
    key: 'faction',
    q: 'Bij welke kant hoor jij?',
    hint: 'Speel je met vrienden? Kies dezelfde faction. Op de PvP-ruleset kun je alleen characters van één faction maken.',
    a: [
      { t: '🦁 Alliance: koninkrijken, orde en glanzende harnassen', v: 'alliance' },
      { t: '🐺 Horde: eer, overleven en een bont gezelschap', v: 'horde' },
      { t: '🤷 Maakt me niet uit', v: 'any' },
    ],
  },
  {
    key: 'look',
    q: 'Welk silhouet past bij jou?',
    a: [
      { t: 'Groot en indrukwekkend', v: 'groot' },
      { t: 'Klein maar dapper', v: 'klein' },
      { t: 'Slank en elegant', v: 'elegant' },
      { t: 'Een klassieke held', v: 'klassiek' },
      { t: 'Ondood en een tikje griezelig', v: 'macaber' },
      { t: 'Wild en beestachtig', v: 'wild' },
    ],
  },
  {
    key: 'vibe',
    q: 'Welk verhaal spreekt je het meest aan?',
    a: [
      { t: 'Eer, trouw en ridderlijkheid', v: 'eer' },
      { t: 'Natuur, geesten en voorouders', v: 'natuur' },
      { t: 'Uitvinden en knutselen', v: 'techniek' },
      { t: 'Overleven tegen alle verwachtingen in', v: 'rebel' },
      { t: 'Magie en eeuwenoude geheimen', v: 'magie' },
      { t: 'Duistere krachten en voodoo', v: 'duister' },
      { t: 'Ontdekken en avontuur', v: 'avontuur' },
    ],
  },
  {
    key: 'focus',
    q: 'Wat ga je vooral doen in Forever?',
    a: [
      { t: '🏰 Dungeons en raids (PvE)', v: 'pve' },
      { t: '⚔️ Andere spelers verslaan (PvP)', v: 'pvp' },
      { t: '🗺️ Rustig questen en de wereld verkennen', v: 'quest' },
      { t: '🎭 Roleplay en een goed verhaal', v: 'rp' },
    ],
  },
  {
    key: 'novelty',
    q: 'Hoe sta je tegenover iets nieuws?',
    hint: 'Nieuw in Forever: de Skyborne en zes nieuwe combinaties, zoals Undead Paladin en Dwarf Shaman.',
    a: [
      { t: '✨ Juist iets nieuws!', v: 'new' },
      { t: '📜 Liever klassiek, zoals vroeger', v: 'classic' },
      { t: '🤷 Geen voorkeur', v: 'any' },
    ],
  },
];

// Lettergrepen per ras. WoW-namen bestaan uit één woord met alleen letters, max. 12 tekens.
export const NAME_PARTS = {
  human: {
    a: ['Al', 'Bran', 'Ced', 'Ed', 'Gar', 'Hal', 'Jor', 'Mar', 'Ros', 'Tor', 'Wil', 'El', 'Ar', 'Gwen', 'Is', 'Lu', 'Bea', 'Ren'],
    b: ['ric', 'win', 'den', 'mund', 'eth', 'wyn', 'ard', 'ona', 'elle', 'ia', 'ton', 'ias', 'ford', 'ara'],
  },
  dwarf: {
    a: ['Bal', 'Bor', 'Dur', 'Grun', 'Mag', 'Thor', 'Brom', 'Kaz', 'Hil', 'Dag', 'Bru', 'Mur', 'Fen', 'Ola'],
    b: ['din', 'grim', 'dan', 'gar', 'rek', 'li', 'ra', 'hild', 'dra', 'nar', 'bek', 'gund', 'dek'],
  },
  nightelf: {
    a: ['Ae', 'Ara', 'Ely', 'Fan', 'Ilt', 'Lyr', 'Sha', 'Tyr', 'Ny', 'Mal', 'Ash', 'Shan', 'Tel', 'Ira'],
    b: ['dris', 'thas', 'lara', 'dor', 'wyn', 'andris', 'iel', 'anar', 'ra', 'thalas', 'nia', 'dira', 'loth'],
  },
  gnome: {
    a: ['Fiz', 'Gim', 'Tink', 'Wiz', 'Bin', 'Sprock', 'Nix', 'Pip', 'Mek', 'Glim', 'Zap', 'Tob', 'Kix', 'Bix'],
    b: ['zle', 'bolt', 'wick', 'ket', 'nik', 'bit', 'cog', 'gle', 'ny', 'spark', 'fuse', 'pin', 'wiz'],
  },
  'skyborne-ho': {
    a: ['Ae', 'Zeph', 'Cael', 'Ven', 'Sil', 'Aur', 'Ely', 'Ser', 'Tem', 'Ny', 'Sor', 'Iri', 'Lae'],
    b: ['ris', 'yra', 'wind', 'thas', 'iel', 'ara', 'vane', 'lis', 'ion', 'ael', 'drel', 'nor', 'esse'],
  },
  orc: {
    a: ['Gro', 'Thra', 'Dur', 'Gar', 'Kro', 'Mog', 'Nag', 'Rok', 'Zug', 'Gor', 'Ur', 'Ka', 'Dra', 'Sha'],
    b: ['mash', 'gar', 'thak', 'gul', 'rok', 'ka', 'dra', 'zog', 'nash', 'gash', 'grim', 'tar', 'ruk'],
  },
  undead: {
    a: ['Mor', 'Vex', 'Sil', 'Mal', 'Cor', 'Gris', 'Nec', 'Ves', 'Fen', 'Lor', 'Ash', 'Vel', 'Rot', 'Hol'],
    b: ['wick', 'ris', 'thorn', 'grave', 'mire', 'ion', 'ane', 'ix', 'ross', 'dred', 'mort', 'gaunt', 'ell'],
  },
  tauren: {
    a: ['Ha', 'Kai', 'Mak', 'Tah', 'Una', 'Huln', 'Mul', 'Ska', 'Ow', 'Ta', 'Hamu', 'Nala', 'Ruu'],
    b: ['wa', 'mu', 'ra', 'hoof', 'horn', 'tor', 'na', 'ka', 'totem', 'kan', 'hawk', 'run', 'mane'],
  },
  troll: {
    a: ['Zul', 'Vol', 'Sen', 'Jin', 'Raj', 'Zal', 'Tal', 'Ra', 'Vor', 'Ki', 'Zan', 'Ma', 'Ya', 'Ji'],
    b: ['jin', 'zal', 'kai', 'ji', 'ra', 'tar', 'zek', 'ani', 'juk', 'rok', 'mbo', 'tu', 'zi'],
  },
  'skyborne-ws': {
    a: ['Ae', 'Zeph', 'Cael', 'Ven', 'Sil', 'Aur', 'Ely', 'Ser', 'Tem', 'Ny', 'Sor', 'Gale', 'Whi'],
    b: ['ris', 'yra', 'wind', 'thas', 'iel', 'ara', 'vane', 'lis', 'ion', 'ael', 'storm', 'rin', 'ash'],
  },
};

export const NAME_MIDDLES = ['', '', '', 'a', 'e', 'i', 'o', 'ra', 'li', 'na', 'th'];
