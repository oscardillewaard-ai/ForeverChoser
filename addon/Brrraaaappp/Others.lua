-- Brrraaaappp: other characters fart too (only on your screen and speakers).
--
-- Where we find them, best first:
-- 1. Visible nameplates: rough distance, and a small cloud attached to the
--    nameplate. WoW Forever doesn't let addons measure nameplates ("restricted
--    regions"), so we never ask where they are, and they sound from the middle.
-- 2. Group members: direction and distance from their map position and the
--    way you're facing (outside instances, where the game allows it).
-- 3. Target, mouseover, target's target and your pet: rough distance, middle.
-- 4. Characters that just did something nearby (combat log, /say, /e):
--    we only know they're around, so a faint fart from the middle.
-- Addons can't set volume or panning, so the sounds are pre-rendered in
-- 5 directions x 3 volumes in sounds\others\.
local ADDON, ns = ...

local OTHERS_DIR = "Interface\\AddOns\\" .. ADDON .. "\\sounds\\others\\"
local BASES = { "timtube_fart3", "breviceps_fart3", "nasty_fart", "bad_chili_fart", "zippi1_fart5", "bassimat_fart005" }
local PANS = 5                           -- p1 = far left ... p5 = far right
local CLOUD_SCALE = { 0.10, 0.16, 0.24 } -- by volume tier: far, medium, close
local CLOUD_DROP = { 0.03, 0.06, 0.10 }  -- from nameplate down to roughly the backside
local EXTRA_UNITS = { "target", "mouseover", "targettarget", "pet" }
local RECENT_SECONDS = 60                -- how long someone from the log/chat counts as "nearby"
local RECENT_MAX = 40

local TYPE_PLAYER = COMBATLOG_OBJECT_TYPE_PLAYER or 0x400
local TYPE_NPC = COMBATLOG_OBJECT_TYPE_NPC or 0x800

local gen = 0
local recent = {} -- guid -> { name = ..., t = GetTime(), tier = 1 or 2 }

local function plateUnit(plate)
  return plate.namePlateUnitToken or (plate.UnitFrame and plate.UnitFrame.unit)
end

local cloudsBlocked = false -- set when WoW refuses attaching a cloud; stays off this session
local lastCloudAt = -math.huge

-- Called by the core when WoW blocks something of ours. If it happened right
-- after attaching a cloud, the cloud is the likely cause: stop doing that.
function ns.OnActionBlocked()
  if GetTime() - lastCloudAt < 1 then cloudsBlocked = true end
end

-- Distance and direction from map positions. UnitPosition returns the
-- north coordinate first and the west coordinate second; GetPlayerFacing is
-- 0 facing north and grows counter-clockwise (towards west).
-- Returns distance in yards and pan (-1 left .. 1 right), or nil.
local function mapInfo(unit)
  if not UnitPosition then return nil end
  local pn, pw, _, pInst = UnitPosition("player")
  local un, uw, _, uInst = UnitPosition(unit)
  if not pn or not un or pInst ~= uInst then return nil end
  local dn, dw = un - pn, uw - pw
  local dist = math.sqrt(dn * dn + dw * dw)
  local pan = 0
  local facing = GetPlayerFacing and GetPlayerFacing()
  if facing and dist > 0.5 then
    local rel = math.atan2(dw, dn) - facing
    pan = -math.sin(rel) -- positive rel = to your left
  end
  return dist, pan
end

-- 3 = close, 2 = medium, 1 = far. Outside your group WoW doesn't tell addons
-- how far away someone is (CheckInteractDistance is blocked for addons in
-- WoW Forever), so we guess: your pet is close, the rest close or medium.
local function roughTier(unit)
  if unit == "pet" then return 3 end
  return math.random() < 0.6 and 2 or 3
end

local function tierFromDistance(d)
  if d > 40 then return nil end
  if d < 10 then return 3 end
  if d < 25 then return 2 end
  return 1
end

local function candidates()
  local list, seen = {}, {}
  local playerGUID = UnitGUID("player")
  local function add(c)
    if not c.guid or c.guid == playerGUID or seen[c.guid] then return end
    seen[c.guid] = true
    list[#list + 1] = c
  end
  local function addUnit(unit, plate, source)
    if not UnitExists(unit) or UnitIsUnit(unit, "player") or UnitIsDeadOrGhost(unit) then return end
    add({ unit = unit, plate = plate, guid = UnitGUID(unit), source = source or unit })
  end
  if C_NamePlate and C_NamePlate.GetNamePlates then
    for _, plate in ipairs(C_NamePlate.GetNamePlates()) do
      local unit = plateUnit(plate)
      if unit then addUnit(unit, plate, "nameplate") end
    end
  end
  -- and by token, in case the nameplate frames don't carry their unit (other nameplate addons)
  local getPlate = C_NamePlate and C_NamePlate.GetNamePlateForUnit
  for i = 1, 40 do
    local unit = "nameplate" .. i
    if UnitExists(unit) then addUnit(unit, getPlate and getPlate(unit), "nameplate") end
  end
  local n = GetNumGroupMembers and GetNumGroupMembers() or 0
  if n > 0 then
    local raid = IsInRaid and IsInRaid()
    for i = 1, n do
      local unit = (raid and "raid" or "party") .. i
      if UnitIsVisible(unit) then addUnit(unit, nil, "group") end
    end
  end
  for _, unit in ipairs(EXTRA_UNITS) do
    if UnitIsVisible(unit) then addUnit(unit) end
  end
  local now = GetTime()
  for guid, r in pairs(recent) do
    if now - r.t > RECENT_SECONDS then
      recent[guid] = nil
    else
      add({ guid = guid, name = r.name, tier = r.tier, source = "heard" })
    end
  end
  return list
end

-- Automatic farts of others (timer and meeting) are always at least this far
-- apart, whatever happens. Blame someone now (manual) ignores it.
local MIN_GAP = 20
local lastAutoFart = -math.huge

local function otherFart(c, manual)
  if not manual then
    if GetTime() - lastAutoFart < MIN_GAP then return false end
  end
  local db = ns.db
  local tier, pan = c.tier or 1, 0
  if c.unit then
    local dist, mapPan
    if c.source == "group" then dist, mapPan = mapInfo(c.unit) end
    if dist then
      tier = tierFromDistance(dist)
      if not tier then return false end
      pan = mapPan
    else
      tier = roughTier(c.unit)
    end
  end
  local panIndex = math.floor((pan + 1) / 2 * (PANS - 1) + 0.5) + 1
  local base = BASES[math.random(#BASES)]
  ns.PlaySound(OTHERS_DIR .. base .. "_p" .. panIndex .. "_v" .. tier .. ".ogg")

  -- small cloud attached to their nameplate (never measured)
  if db.othersSmoke and c.plate and not cloudsBlocked and ns.PlaySmallSmoke then
    lastCloudAt = GetTime()
    local ok, attached = pcall(ns.PlaySmallSmoke, c.plate, CLOUD_DROP[tier], CLOUD_SCALE[tier])
    if not ok or not attached then cloudsBlocked = true end
  end
  if db.othersChat then
    local name = (c.unit and UnitName(c.unit)) or c.name or "Someone"
    local line
    if c.unit then
      line = string.format(ns.PickFresh(ns.OTHER_LINES), name)
    else
      line = string.format(ns.PickFresh(ns.DISTANT_LINES), name)
    end
    ns.msg("|cffd2b48c" .. line .. "|r")
  end
  return true
end

-- What the addon can see right now, for /brap debug.
function ns.DebugOthers()
  local list = candidates()
  local counts = {}
  for _, c in ipairs(list) do counts[c.source] = (counts[c.source] or 0) + 1 end
  ns.msg(string.format("found %d nearby: %d by nameplate, %d in group, %d heard nearby, %d other (target, mouseover, pet)",
    #list, counts.nameplate or 0, counts.group or 0, counts.heard or 0,
    #list - (counts.nameplate or 0) - (counts.group or 0) - (counts.heard or 0)))
  local plates = C_NamePlate and C_NamePlate.GetNamePlates and #C_NamePlate.GetNamePlates() or -1
  ns.msg(string.format("nameplate frames: %d, others on: %s, clouds on others: %s", plates, tostring(ns.db.others),
    cloudsBlocked and "blocked by WoW this session" or "ok"))
  if ns.lastBlocked then
    ns.msg(string.format("last blocked by WoW: %s (%d s ago)", ns.lastBlocked.what, math.floor(GetTime() - ns.lastBlocked.t)))
  else
    ns.msg("nothing of ours has been blocked by WoW this session")
  end
  for i = 1, math.min(#list, 5) do
    local c = list[i]
    local name = (c.unit and UnitName(c.unit)) or c.name or "?"
    local where = c.plate and "has nameplate" or "no nameplate"
    ns.msg(string.format("- %s (%s, %s)", name, c.source, where))
  end
end

-- Make a random nearby character fart now. Returns false if nobody is around.
function ns.BlameSomeone(manual)
  local list = candidates()
  while #list > 0 do
    local i = math.random(#list)
    if otherFart(list[i], manual) then
      if not manual then lastAutoFart = GetTime() end
      return true
    end
    if not manual and GetTime() - lastAutoFart < MIN_GAP then return false end
    table.remove(list, i)
  end
  return false
end

function ns.ScheduleOthers(delay)
  gen = gen + 1
  local myGen = gen
  local db = ns.db
  if not db.others then return end
  delay = delay or (db.othersMin * 60 + math.random() * (db.othersMax - db.othersMin) * 60)
  C_Timer.After(delay, function()
    if myGen ~= gen or not ns.db.others then return end
    if InCombatLockdown() and not ns.db.inCombat then
      ns.ScheduleOthers(30)
    elseif not ns.BlameSomeone() then
      ns.ScheduleOthers(45) -- nobody around: look again soon
    else
      ns.ScheduleOthers()
    end
  end)
end

-- Remember who's around from the combat log and nearby chat.
local function remember(guid, name, tier)
  if not guid or not name or guid == UnitGUID("player") then return end
  local r = recent[guid]
  local now = GetTime()
  if r then
    r.t = now
    if tier > r.tier then r.tier = tier end
    return
  end
  local count, oldestGuid, oldestT = 0, nil, math.huge
  for g, e in pairs(recent) do
    count = count + 1
    if e.t < oldestT then oldestGuid, oldestT = g, e.t end
  end
  if count >= RECENT_MAX and oldestGuid then recent[oldestGuid] = nil end
  recent[guid] = { name = name, t = now, tier = tier }
  if ns.Meet then
    ns.Meet(guid, function()
      local r = recent[guid]
      if r then return { guid = guid, name = r.name, tier = r.tier, source = "heard" } end
    end)
  end
end

local watcher = CreateFrame("Frame")
watcher:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
watcher:RegisterEvent("CHAT_MSG_SAY")
watcher:RegisterEvent("CHAT_MSG_EMOTE")
watcher:RegisterEvent("CHAT_MSG_TEXT_EMOTE")
watcher:SetScript("OnEvent", function(_, event, ...)
  if not ns.db or not ns.db.others then return end
  if event == "COMBAT_LOG_EVENT_UNFILTERED" then
    local _, sub, _, srcGUID, srcName, srcFlags, _, dstGUID = CombatLogGetCurrentEventInfo()
    if sub == "UNIT_DIED" then
      if dstGUID then recent[dstGUID] = nil end
      return
    end
    if srcFlags and (bit.band(srcFlags, TYPE_PLAYER) ~= 0 or bit.band(srcFlags, TYPE_NPC) ~= 0) then
      local r = recent[srcGUID]
      if r and GetTime() - r.t < 5 then return end -- cheap: don't update on every hit
      remember(srcGUID, srcName, 1)
    end
  else
    -- /say and emotes only reach about 25-60 yards: medium volume
    local _, sender = ...
    local guid = select(12, ...)
    if sender and guid then remember(guid, Ambiguate and Ambiguate(sender, "short") or sender, 2) end
  end
end)

-- Meeting someone: each new character you see or hear has a chance to fart
-- a few seconds later. Same person: once per 10 minutes. Between two such
-- farts: at least 45 seconds, so a busy city doesn't turn into an orchestra.
local MEET_DELAY_MIN, MEET_DELAY_MAX = 2, 8
local MEET_COOLDOWN = 45
local MEET_AGAIN_AFTER = 600
local met = {}             -- guid -> GetTime() of the last roll
local lastMeetFart = -math.huge

local function meet(guid, makeCandidate)
  local db = ns.db
  if not db or not db.others or (db.othersMeet or 0) <= 0 or not guid then return end
  if guid == UnitGUID("player") then return end
  local now = GetTime()
  if met[guid] and now - met[guid] < MEET_AGAIN_AFTER then return end
  met[guid] = now
  if math.random(100) > db.othersMeet or now - lastMeetFart < MEET_COOLDOWN then return end
  lastMeetFart = now
  C_Timer.After(MEET_DELAY_MIN + math.random() * (MEET_DELAY_MAX - MEET_DELAY_MIN), function()
    if not ns.db.others or (InCombatLockdown() and not ns.db.inCombat) then return end
    local c = makeCandidate()
    if c and otherFart(c) then lastAutoFart = GetTime() end
  end)
end
ns.Meet = meet

local meetWatch = CreateFrame("Frame")
meetWatch:RegisterEvent("NAME_PLATE_UNIT_ADDED")
meetWatch:SetScript("OnEvent", function(_, event, unit)
  if event ~= "NAME_PLATE_UNIT_ADDED" or not unit then return end
  if UnitIsUnit(unit, "player") or UnitIsDeadOrGhost(unit) then return end
  local guid = UnitGUID(unit)
  meet(guid, function()
    if UnitGUID(unit) ~= guid or UnitIsDeadOrGhost(unit) then return nil end -- gone, or the plate is someone else now
    local plate = C_NamePlate and C_NamePlate.GetNamePlateForUnit and C_NamePlate.GetNamePlateForUnit(unit)
    return { unit = unit, plate = plate, guid = guid, source = "nameplate" }
  end)
end)
