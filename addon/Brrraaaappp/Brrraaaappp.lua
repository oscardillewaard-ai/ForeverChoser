-- Brrraaaappp: when nature calls, it calls loudly.
-- Core: settings, your own farts, the timer and slash commands.
-- Sounds play only on your own computer; addons can't send sound to other
-- players. The optional /e emote is what other players see.
local ADDON, ns = ...

local SOUND_DIR = "Interface\\AddOns\\" .. ADDON .. "\\sounds\\"
ns.CUSTOM_DIR = "Interface\\AddOns\\BrrraaaapppCustom\\"

-- Real recordings from freesound.org; see the README for authors and links.
ns.SOUNDS = {
  "timtube_fart3", "dual_fart", "bad_chili_fart", "zippi1_fart5",
  "smokevhstapes_fart5", "aetherzip_fart_long", "teddyferguson_fart",
  "breviceps_fart3", "nasty_fart", "frenkfurth_fart50", "bassimat_fart005",
}

local DEFAULTS = {
  enabled = true,      -- automatic farts
  minMinutes = 10,
  maxMinutes = 30,
  inCombat = true,
  chatLine = true,     -- gross race/class fart text in chat
  smoke = true,        -- brown smoke cloud (only you see it)
  emote = true,        -- send that text as a /e emote (other players see it!)
  others = true,       -- other characters fart too
  othersMin = 5,
  othersMax = 15,
  othersSmoke = true,
  othersChat = true,
  builtin = true,      -- use the built-in fart sounds
  custom = {},         -- your own sounds: file names or sound IDs
  channel = "Master",
}
local DB_VERSION = 2
local EMOTE_COOLDOWN = 20 -- seconds, so /brap now can't spam the chat

local db
local timerGen = 0 -- increases on every reschedule so old timers do nothing
local nextFartAt   -- GetTime() of the next automatic fart
local lastEmote = -math.huge

function ns.msg(text)
  DEFAULT_CHAT_FRAME:AddMessage("|cff9acd32Brrraaaappp|r: " .. text)
end
local msg = ns.msg

-- Sounds ------------------------------------------------------------------

-- A custom entry is a sound ID (number), a full path, or a file name in
-- Interface\AddOns\BrrraaaapppCustom\ (".ogg" is added if there's no extension).
function ns.ResolveCustom(entry)
  local id = tonumber(entry)
  if id then return id end
  entry = entry:gsub("/", "\\")
  if not entry:find("%.%w+$") then entry = entry .. ".ogg" end
  if entry:find("\\") then return entry end
  return ns.CUSTOM_DIR .. entry
end

local function play(sound)
  local ok, willPlay = pcall(PlaySoundFile, sound, db.channel)
  return ok and willPlay and true or false
end
ns.PlaySound = play

function ns.TestCustom(entry)
  return play(ns.ResolveCustom(entry))
end

local function playOwnSound()
  local pool = {}
  if db.builtin then
    for _, name in ipairs(ns.SOUNDS) do pool[#pool + 1] = { builtin = name } end
  end
  for _, entry in ipairs(db.custom) do pool[#pool + 1] = { custom = entry } end
  if #pool == 0 then pool[1] = { builtin = ns.SOUNDS[math.random(#ns.SOUNDS)] } end
  local pick = pool[math.random(#pool)]
  if pick.custom and play(ns.ResolveCustom(pick.custom)) then return end
  -- built-in pick, or a custom file that couldn't play: use a built-in one
  play(SOUND_DIR .. (pick.builtin or ns.SOUNDS[math.random(#ns.SOUNDS)]) .. ".ogg")
end

-- Lines -------------------------------------------------------------------

local function pickLine()
  local pools = {}
  local _, raceFile = UnitRace("player")
  local _, classFile = UnitClass("player")
  local raceLines = raceFile and ns.RACE_LINES[raceFile]
  if not raceLines and raceFile and strfind(strlower(raceFile), "sky") then
    raceLines = ns.SKYBORNE_LINES
  end
  if raceLines then pools[#pools + 1] = raceLines end
  if classFile and ns.CLASS_LINES[classFile] then pools[#pools + 1] = ns.CLASS_LINES[classFile] end
  if #pools == 0 or math.random() < 0.15 then pools[#pools + 1] = ns.GENERIC_LINES end
  local pool = pools[math.random(#pools)]
  return pool[math.random(#pool)]
end

-- Shows the line like an emote, but only in your own chat.
local function localEmote(line)
  local name = UnitName("player") or "You"
  local info = ChatTypeInfo and ChatTypeInfo["EMOTE"]
  local r, g, b = 1, 0.5, 0.25
  if info then r, g, b = info.r, info.g, info.b end
  DEFAULT_CHAT_FRAME:AddMessage(name .. " " .. line, r, g, b)
end

-- One line per fart: as a real /e emote when that's on (and not on
-- cooldown), otherwise only in your own chat.
local function fartText()
  local line = pickLine()
  local now = GetTime()
  if db.emote and now - lastEmote >= EMOTE_COOLDOWN then
    lastEmote = now
    SendChatMessage(line, "EMOTE")
  else
    localEmote(line)
  end
end

-- Farting -----------------------------------------------------------------

local function playFart(force)
  if not force and not db.inCombat and InCombatLockdown() then
    return false
  end
  playOwnSound()
  if db.smoke and ns.PlaySmoke then ns.PlaySmoke() end
  if db.chatLine then fartText() end
  return true
end

function ns.FartNow()
  playFart(true)
end

local schedule
schedule = function()
  timerGen = timerGen + 1
  nextFartAt = nil
  if not db.enabled then return end
  local myGen = timerGen
  local lo, hi = db.minMinutes * 60, db.maxMinutes * 60
  local delay = lo + math.random() * (hi - lo)
  nextFartAt = GetTime() + delay
  C_Timer.After(delay, function()
    if myGen ~= timerGen or not db.enabled then return end
    if not playFart(false) then
      -- in combat and that's not allowed: try again in 20 seconds
      nextFartAt = GetTime() + 20
      C_Timer.After(20, function()
        if myGen == timerGen then playFart(false) end
        if myGen == timerGen then schedule() end
      end)
      return
    end
    schedule()
  end)
end
ns.Reschedule = function() schedule() end

function ns.NextText()
  if not db.enabled then return "Automatic farts are off" end
  if not nextFartAt then return "" end
  local left = math.max(0, nextFartAt - GetTime())
  if left < 60 then
    return string.format("Next fart in %d s", math.floor(left))
  end
  return string.format("Next fart in %d min", math.ceil(left / 60))
end

-- Slash commands ----------------------------------------------------------

local function status()
  msg(string.format("%s | every %d-%d min | %s | others: %s",
    db.enabled and "|cff00ff00on|r" or "|cffff0000off|r",
    db.minMinutes, db.maxMinutes, ns.NextText(),
    db.others and "on" or "off"))
end

local function help()
  msg("commands:")
  msg("/brap - open the settings window")
  msg("/brap now - fart right now")
  msg("/brap on | off - automatic farts on or off")
  msg("/brap status - show when the next fart comes")
  msg("/brap blame - make someone nearby fart")
  msg("/brap debug - show who the addon can find nearby")
end

SLASH_BRRRAAAAPPP1 = "/brap"
SLASH_BRRRAAAAPPP2 = "/brrraaaappp"
SlashCmdList.BRRRAAAAPPP = function(input)
  local cmd = strsplit(" ", strlower(strtrim(input or "")))
  if cmd == nil or cmd == "" or cmd == "options" or cmd == "config" then
    ns.ToggleOptions()
  elseif cmd == "now" then
    playFart(true)
  elseif cmd == "on" then
    db.enabled = true; schedule(); status()
  elseif cmd == "off" then
    db.enabled = false; schedule(); status()
  elseif cmd == "status" then
    status()
  elseif cmd == "blame" then
    local ok, found = pcall(ns.BlameSomeone)
    if not ok then msg("|cffff4040Error:|r " .. tostring(found)) elseif not found then msg("Nobody nearby to blame.") end
  elseif cmd == "debug" then
    local ok, err = pcall(ns.DebugOthers)
    if not ok then msg("|cffff4040Error:|r " .. tostring(err)) end
  else
    help()
  end
end

-- Loading -----------------------------------------------------------------

-- Settings from older (Dutch) versions.
local function migrate(saved)
  if (saved.version or 0) < 2 then
    if saved.zin ~= nil then saved.chatLine = saved.zin end
    if saved.rook ~= nil then saved.smoke = saved.rook end
    saved.zin, saved.rook = nil, nil
    saved.emote = nil -- used to mean the built-in /fart emote; now the /e emote (default on)
  end
  saved.version = DB_VERSION
end

-- When WoW blocks something of ours, remember what, for /brap debug.
local blockWatch = CreateFrame("Frame")
blockWatch:RegisterEvent("ADDON_ACTION_BLOCKED")
blockWatch:RegisterEvent("ADDON_ACTION_FORBIDDEN")
blockWatch:SetScript("OnEvent", function(_, event, addon, what)
  if (event ~= "ADDON_ACTION_BLOCKED" and event ~= "ADDON_ACTION_FORBIDDEN") or addon ~= ADDON then return end
  ns.lastBlocked = { what = tostring(what), t = GetTime() }
  if ns.OnActionBlocked then ns.OnActionBlocked() end
end)

local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:SetScript("OnEvent", function(self, event, name)
  if name ~= ADDON then return end
  BrrraaaapppDB = BrrraaaapppDB or {}
  migrate(BrrraaaapppDB)
  for k, v in pairs(DEFAULTS) do
    if BrrraaaapppDB[k] == nil then
      BrrraaaapppDB[k] = type(v) == "table" and {} or v
    end
  end
  db = BrrraaaapppDB
  ns.db = db
  schedule()
  if ns.ScheduleOthers then ns.ScheduleOthers() end
  self:UnregisterEvent("ADDON_LOADED")
end)
