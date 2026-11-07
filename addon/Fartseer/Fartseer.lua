-- Fartseer: "I have foreseen... a fart."
-- Speelt heel af en toe een scheetgeluidje af. Het geluid is alleen voor jou
-- hoorbaar (addons kunnen geen geluid naar andere spelers sturen). Wil je dat
-- anderen het ook merken, zet dan de /fart-emote aan.

local ADDON = ...
local SOUND_PATH = "Interface\\AddOns\\" .. ADDON .. "\\sounds\\"
local SOUNDS = { "scheet1", "scheet2", "scheet3", "scheet4", "scheet5" }

local DEFAULTS = {
  enabled   = true,
  minMinutes = 10,   -- kortste wachttijd tussen scheten
  maxMinutes = 30,   -- langste wachttijd tussen scheten
  emote     = false, -- ook de echte /fart-emote doen (zichtbaar voor anderen)
  inCombat  = true,  -- ook tijdens gevechten
  channel   = "Master",
}

local LINES = {
  "Je voelt een rommeling in je ingewanden...",
  "Er ontsnapt wat arcane energie.",
  "Dat was de wind. De wind van Durotar.",
  "Niemand heeft het gehoord. Toch?",
  "Je Hearthstone trilt ervan.",
  "Een kritieke treffer op de omgeving.",
}

local db
local timerGen = 0 -- verhoogt bij elke herplanning, zodat oude timers niets meer doen

local function msg(text)
  DEFAULT_CHAT_FRAME:AddMessage("|cff9acd32Fartseer|r: " .. text)
end

local function playFart(force)
  if not force and not db.inCombat and InCombatLockdown() then
    return false
  end
  local file = SOUNDS[math.random(#SOUNDS)]
  PlaySoundFile(SOUND_PATH .. file .. ".ogg", db.channel)
  if db.emote then
    DoEmote("FART")
  elseif math.random() < 0.3 then
    msg(LINES[math.random(#LINES)])
  end
  return true
end

local schedule
schedule = function()
  timerGen = timerGen + 1
  if not db.enabled then return end
  local myGen = timerGen
  local lo, hi = db.minMinutes * 60, db.maxMinutes * 60
  local delay = lo + math.random() * (hi - lo)
  C_Timer.After(delay, function()
    if myGen ~= timerGen or not db.enabled then return end
    if not playFart(false) then
      -- in combat en dat mag niet: probeer het over 20 seconden opnieuw
      C_Timer.After(20, function()
        if myGen == timerGen then playFart(false) end
        if myGen == timerGen then schedule() end
      end)
      return
    end
    schedule()
  end)
end

local function status()
  msg(string.format("%s | elke %d-%d min | emote: %s | in combat: %s",
    db.enabled and "|cff00ff00aan|r" or "|cffff0000uit|r",
    db.minMinutes, db.maxMinutes,
    db.emote and "aan" or "uit",
    db.inCombat and "ja" or "nee"))
end

local function help()
  msg("commando's:")
  msg("/fartseer aan | uit - addon aan- of uitzetten")
  msg("/fartseer nu - meteen een scheetje (testen)")
  msg("/fartseer tijd <min> <max> - wachttijd in minuten, bv. /fartseer tijd 5 20")
  msg("/fartseer emote - /fart-emote aan/uit (anderen zien die!)")
  msg("/fartseer combat - wel/niet tijdens gevechten")
  msg("/fartseer status - huidige instellingen")
end

SLASH_FARTSEER1 = "/fartseer"
SLASH_FARTSEER2 = "/fs"
SlashCmdList.FARTSEER = function(input)
  local cmd, a, b = strsplit(" ", strlower(strtrim(input or "")))
  if cmd == "aan" or cmd == "on" then
    db.enabled = true; schedule(); status()
  elseif cmd == "uit" or cmd == "off" then
    db.enabled = false; schedule(); status()
  elseif cmd == "nu" or cmd == "now" then
    playFart(true)
  elseif cmd == "tijd" or cmd == "time" then
    local lo, hi = tonumber(a), tonumber(b)
    if lo and hi and lo >= 1 and hi >= lo then
      db.minMinutes, db.maxMinutes = math.floor(lo), math.floor(hi)
      schedule(); status()
    else
      msg("gebruik: /fartseer tijd <min> <max>, met min >= 1 en max >= min")
    end
  elseif cmd == "emote" then
    db.emote = not db.emote; status()
  elseif cmd == "combat" then
    db.inCombat = not db.inCombat; status()
  elseif cmd == "status" then
    status()
  else
    help()
  end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, name)
  if name ~= ADDON then return end
  FartseerDB = FartseerDB or {}
  for k, v in pairs(DEFAULTS) do
    if FartseerDB[k] == nil then FartseerDB[k] = v end
  end
  db = FartseerDB
  schedule()
  self:UnregisterEvent("ADDON_LOADED")
end)
