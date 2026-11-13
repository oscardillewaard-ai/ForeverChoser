-- Brrraaaappp: other characters fart too (only on your screen and speakers).
-- Who: units with a visible nameplate, your group members and your target.
-- Direction: where their nameplate is on your screen (left/right).
-- Volume: how far away they are (exact for group members, roughly otherwise).
-- Addons can't set volume or panning, so the sounds are pre-rendered in
-- 5 directions x 3 volumes in sounds\others\.
local ADDON, ns = ...

local OTHERS_DIR = "Interface\\AddOns\\" .. ADDON .. "\\sounds\\others\\"
local BASES = { "timtube_fart3", "breviceps_fart3", "nasty_fart", "bad_chili_fart", "zippi1_fart5", "bassimat_fart005" }
local PANS = 5                         -- p1 = far left ... p5 = far right
local CLOUD_SCALE = { 0.10, 0.16, 0.24 } -- by volume tier: far, medium, close
local CLOUD_DROP = { 0.03, 0.06, 0.10 }  -- from nameplate down to roughly the backside

local gen = 0

local function plateUnit(plate)
  return plate.namePlateUnitToken or (plate.UnitFrame and plate.UnitFrame.unit)
end

-- Bottom centre of a nameplate as a fraction of the screen.
local function platePos(plate)
  local x = plate:GetCenter()
  local bottom = plate:GetBottom()
  if not x or not bottom then return nil end
  local s = plate:GetEffectiveScale() / UIParent:GetEffectiveScale()
  return x * s / UIParent:GetWidth(), bottom * s / UIParent:GetHeight()
end

-- 3 = close, 2 = medium, 1 = far, nil = too far away to hear.
local function volumeTier(unit)
  local py, px, _, pInst = UnitPosition("player")
  local uy, ux, _, uInst = UnitPosition(unit)
  if py and uy and pInst == uInst then
    local d = math.sqrt((py - uy) ^ 2 + (px - ux) ^ 2)
    if d > 40 then return nil end
    if d < 10 then return 3 end
    if d < 25 then return 2 end
    return 1
  end
  if InCombatLockdown() then return 2 end
  local ok, near = pcall(CheckInteractDistance, unit, 3) -- about 10 yards
  if ok and near then return 3 end
  ok, near = pcall(CheckInteractDistance, unit, 4)       -- about 28 yards
  if ok and near then return 2 end
  return 1
end

local function candidates()
  local list, seen = {}, {}
  local function add(unit, plate)
    if not UnitExists(unit) or UnitIsUnit(unit, "player") or UnitIsDeadOrGhost(unit) then return end
    local guid = UnitGUID(unit)
    if not guid or seen[guid] then return end
    seen[guid] = true
    list[#list + 1] = { unit = unit, plate = plate, guid = guid }
  end
  if C_NamePlate and C_NamePlate.GetNamePlates then
    for _, plate in ipairs(C_NamePlate.GetNamePlates()) do
      local unit = plateUnit(plate)
      if unit then add(unit, plate) end
    end
  end
  local n = GetNumGroupMembers and GetNumGroupMembers() or 0
  if n > 0 then
    local raid = IsInRaid and IsInRaid()
    for i = 1, n do
      local unit = (raid and "raid" or "party") .. i
      if UnitIsVisible(unit) then add(unit, nil) end
    end
  end
  if UnitIsVisible("target") then add("target", nil) end
  return list
end

local function otherFart(c)
  local db = ns.db
  local tier = volumeTier(c.unit)
  if not tier then return false end
  local fx, fy, pan = nil, nil, 0
  if c.plate then
    fx, fy = platePos(c.plate)
    if fx then pan = math.max(-1, math.min(1, fx * 2 - 1)) end
  end
  local panIndex = math.floor((pan + 1) / 2 * (PANS - 1) + 0.5) + 1
  local base = BASES[math.random(#BASES)]
  ns.PlaySound(OTHERS_DIR .. base .. "_p" .. panIndex .. "_v" .. tier .. ".ogg")

  -- small cloud, only when we know where they are on screen
  if db.othersSmoke and fx and ns.PlaySmallSmoke then
    local plate, guid, drop = c.plate, c.guid, CLOUD_DROP[tier]
    ns.PlaySmallSmoke(fx, fy - drop, CLOUD_SCALE[tier], function()
      if not plate:IsShown() then return nil end
      local unit = plateUnit(plate)
      if not unit or UnitGUID(unit) ~= guid then return nil end
      local x, y = platePos(plate)
      if x then return x, y - drop end
    end)
  end
  if db.othersChat then
    local name = UnitName(c.unit) or "Someone"
    ns.msg("|cffd2b48c" .. string.format(ns.OTHER_LINES[math.random(#ns.OTHER_LINES)], name) .. "|r")
  end
  return true
end

-- Make a random nearby character fart now. Returns false if nobody is around.
function ns.BlameSomeone()
  local list = candidates()
  while #list > 0 do
    local i = math.random(#list)
    if otherFart(list[i]) then return true end
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
