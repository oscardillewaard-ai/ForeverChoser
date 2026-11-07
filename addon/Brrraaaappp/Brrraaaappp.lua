-- Brrraaaappp: wanneer de natuur roept, roept ze luid.
-- Speelt heel af en toe een scheetgeluidje af. Het geluid is alleen voor jou
-- hoorbaar (addons kunnen geen geluid naar andere spelers sturen). Wil je dat
-- anderen het ook merken, zet dan de /fart-emote aan.

local ADDON, ns = ...
local SOUND_PATH = "Interface\\AddOns\\" .. ADDON .. "\\sounds\\"
local SOUNDS = { "scheet1", "scheet2", "scheet3", "scheet4", "scheet5" }

local DEFAULTS = {
  enabled   = true,
  minMinutes = 10,   -- kortste wachttijd tussen scheten
  maxMinutes = 30,   -- langste wachttijd tussen scheten
  emote     = false, -- ook de echte /fart-emote doen (zichtbaar voor anderen)
  inCombat  = true,  -- ook tijdens gevechten
  zin       = true,  -- smerige zin in je chat (alleen jij ziet die)
  channel   = "Master",
}

-- Kiest een smerige zin die past bij je race of class (zie Lines.lua).
local function pickLine()
  local pools = {}
  local _, raceFile = UnitRace("player")
  local _, classFile = UnitClass("player")
  local raceLines = raceFile and ns.RACE_LINES[raceFile]
  if not raceLines and raceFile and strfind(strlower(raceFile), "sky") then
    raceLines = ns.SKYBORNE_LINES
  end
  if raceLines then table.insert(pools, raceLines) end
  if classFile and ns.CLASS_LINES[classFile] then table.insert(pools, ns.CLASS_LINES[classFile]) end
  if #pools == 0 then table.insert(pools, ns.GENERIC_LINES) end
  local pool = pools[math.random(#pools)]
  return pool[math.random(#pool)], classFile
end

local function classColor(classFile)
  local c = classFile and RAID_CLASS_COLORS and RAID_CLASS_COLORS[classFile]
  if c then
    return string.format("|cff%02x%02x%02x", math.floor(c.r * 255), math.floor(c.g * 255), math.floor(c.b * 255))
  end
  return "|cffffd100"
end

local db
local timerGen = 0 -- verhoogt bij elke herplanning, zodat oude timers niets meer doen

local function msg(text)
  DEFAULT_CHAT_FRAME:AddMessage("|cff9acd32Brrraaaappp|r: " .. text)
end

local function playFart(force)
  if not force and not db.inCombat and InCombatLockdown() then
    return false
  end
  local file = SOUNDS[math.random(#SOUNDS)]
  PlaySoundFile(SOUND_PATH .. file .. ".ogg", db.channel)
  if db.emote then
    DoEmote("FART")
  end
  if db.zin then
    local line, classFile = pickLine()
    msg(classColor(classFile) .. line .. "|r")
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
  msg(string.format("%s | elke %d-%d min | emote: %s | zin: %s | in combat: %s",
    db.enabled and "|cff00ff00aan|r" or "|cffff0000uit|r",
    db.minMinutes, db.maxMinutes,
    db.emote and "aan" or "uit",
    db.zin and "aan" or "uit",
    db.inCombat and "ja" or "nee"))
end

local function help()
  msg("commando's:")
  msg("/brrraaaappp aan | uit - addon aan- of uitzetten")
  msg("/brrraaaappp nu - meteen een scheetje (testen)")
  msg("/brrraaaappp tijd <min> <max> - wachttijd in minuten, bv. /brrraaaappp tijd 5 20")
  msg("/brrraaaappp emote - /fart-emote aan/uit (anderen zien die!)")
  msg("/brrraaaappp zin - smerige race/class-zin aan/uit")
  msg("/brrraaaappp combat - wel/niet tijdens gevechten")
  msg("/brrraaaappp status - huidige instellingen")
end

SLASH_BRRRAAAAPPP1 = "/brrraaaappp"
SLASH_BRRRAAAAPPP2 = "/brap"
SlashCmdList.BRRRAAAAPPP = function(input)
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
      msg("gebruik: /brrraaaappp tijd <min> <max>, met min >= 1 en max >= min")
    end
  elseif cmd == "emote" then
    db.emote = not db.emote; status()
  elseif cmd == "zin" then
    db.zin = not db.zin; status()
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
  BrrraaaapppDB = BrrraaaapppDB or {}
  for k, v in pairs(DEFAULTS) do
    if BrrraaaapppDB[k] == nil then BrrraaaapppDB[k] = v end
  end
  db = BrrraaaapppDB
  schedule()
  self:UnregisterEvent("ADDON_LOADED")
end)
