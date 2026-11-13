-- Brrraaaappp: brown smoke clouds.
-- A big cloud (with a brown screen edge) for your own farts, and small clouds
-- attached to other characters' nameplates. Smoke sits below the UI
-- (strata BACKGROUND): it covers the world, your bars and chat stay readable.
-- Nameplates can't be measured in WoW Forever ("restricted regions"), so a
-- small cloud is anchored to the nameplate instead, and every size comes
-- from UIParent, never from a frame anchored to a nameplate.
local ADDON, ns = ...

local MEDIA = "Interface\\AddOns\\" .. ADDON .. "\\media\\"
local PUFF_TEXTURES = { MEDIA .. "smoke1.tga", MEDIA .. "smoke2.tga", MEDIA .. "smoke3.tga" }
local VIGNETTE_TEXTURE = MEDIA .. "vignette.tga"
local VIGNETTE_MAX = 0.55

-- Brown shades, multiplied with the grey smoke texture.
local BROWNS = {
  { 0.55, 0.38, 0.18 },
  { 0.45, 0.30, 0.13 },
  { 0.62, 0.45, 0.24 },
  { 0.38, 0.25, 0.10 },
}

local function rand(lo, hi)
  return lo + math.random() * (hi - lo)
end

local function easeOut(u)
  return 1 - (1 - u) * (1 - u)
end

local Smoke = {}
Smoke.__index = Smoke

local function newSmoke(numPuffs, withVignette)
  local self = setmetatable({ puffs = {}, t = 0, duration = 0 }, Smoke)
  local f = CreateFrame("Frame", nil, UIParent)
  f:SetFrameStrata("BACKGROUND")
  f:Hide()
  self.frame = f
  if withVignette then
    local v = f:CreateTexture(nil, "BACKGROUND")
    v:SetAllPoints(f)
    v:SetTexture(VIGNETTE_TEXTURE)
    v:SetVertexColor(0.30, 0.19, 0.07)
    self.vignette = v
  end
  for i = 1, numPuffs do
    local tex = f:CreateTexture(nil, "ARTWORK")
    tex:Hide()
    self.puffs[i] = { tex = tex }
  end
  f:SetScript("OnUpdate", function(_, elapsed) self:Update(elapsed) end)
  return self
end

function Smoke:IsPlaying()
  return self.frame:IsShown()
end

-- opts.x, opts.y: origin as a fraction of screen width / height (from bottom left)
-- opts.anchor: optional region (a nameplate) to attach to instead; opts.drop is
--   how far below its bottom the cloud starts, as a fraction of screen height
-- opts.scale: 1 = full-size cloud; opts.life: lifetime multiplier
-- Returns false if the cloud couldn't be attached.
function Smoke:Play(opts)
  local n = #self.puffs
  local f = self.frame
  local W, H = UIParent:GetWidth(), UIParent:GetHeight()
  self.scale = opts.scale or 1
  self.t, self.duration = 0, 0
  f:ClearAllPoints()
  if opts.anchor then
    local size = H * self.scale * 2
    f:SetSize(size, size)
    local ok = pcall(f.SetPoint, f, "CENTER", opts.anchor, "BOTTOM", 0, -(opts.drop or 0) * H)
    if not ok then
      f:Hide()
      return false
    end
    self.ox, self.oy = 0, 0
  else
    f:SetAllPoints(UIParent)
    self.ox, self.oy = (opts.x - 0.5) * W, (opts.y - 0.5) * H -- offset from the screen centre
  end
  local lifeMul = opts.life or 1
  for i = 1, n do
    local p = self.puffs[i]
    local angle = math.rad(90 + rand(-80, 80))   -- up, with some going sideways
    local dist = rand(0.25, 0.70)
    p.delay = (i - 1) / n * 0.6 * lifeMul + rand(0, 0.08)
    p.life = rand(2.6, 3.8) * lifeMul
    p.jx = rand(-0.03, 0.03)
    p.jy = rand(-0.02, 0.02)
    p.dx = math.cos(angle) * dist
    p.dy = math.sin(angle) * dist * 0.8
    p.rise = rand(0.05, 0.15)                    -- smoke rises
    p.size0 = rand(0.10, 0.16)
    p.size1 = rand(0.60, 1.00)
    p.rot0 = rand(0, 2 * math.pi)
    p.spin = rand(-0.5, 0.5)
    p.maxAlpha = rand(0.65, 0.90)
    self.duration = math.max(self.duration, p.delay + p.life)
    local c = BROWNS[math.random(#BROWNS)]
    p.tex:SetTexture(PUFF_TEXTURES[math.random(#PUFF_TEXTURES)])
    p.tex:SetVertexColor(c[1], c[2], c[3])
    p.tex:Hide()
  end
  if self.vignette then self.vignette:SetAlpha(0) end
  f:Show()
  return true
end

function Smoke:Update(elapsed)
  self.t = self.t + elapsed
  local t = self.t
  if t >= self.duration then
    self.frame:Hide()
    return
  end
  local W, H = UIParent:GetWidth(), UIParent:GetHeight()
  local s = self.scale
  if self.vignette then
    local a
    if t < 0.6 then a = VIGNETTE_MAX * t / 0.6
    elseif t < 2.0 then a = VIGNETTE_MAX
    else a = math.max(0, VIGNETTE_MAX * (1 - (t - 2.0) / (self.duration - 2.0))) end
    self.vignette:SetAlpha(a)
  end
  for i = 1, #self.puffs do
    local p = self.puffs[i]
    local age = t - p.delay
    if age <= 0 or age >= p.life then
      p.tex:Hide()
    else
      local u = age / p.life
      local e = easeOut(u)
      local size = (p.size0 + (p.size1 - p.size0) * e) * s * H
      local x = self.ox + p.jx * s * W + p.dx * e * s * H
      local y = self.oy + (p.jy * s + (p.dy * e + p.rise * u) * s) * H
      local fadeIn = math.min(1, age / 0.25)
      local fadeOut = 1
      if u > 0.3 then fadeOut = (1 - (u - 0.3) / 0.7) ^ 1.4 end
      p.tex:ClearAllPoints()
      p.tex:SetPoint("CENTER", self.frame, "CENTER", x, y)
      p.tex:SetSize(size, size)
      if p.tex.SetRotation then p.tex:SetRotation(p.rot0 + p.spin * age) end
      p.tex:SetAlpha(p.maxAlpha * fadeIn * fadeOut)
      p.tex:Show()
    end
  end
end

local big
local small = {}

-- Your own fart: big cloud from the middle of the screen, where your character usually stands.
function ns.PlaySmoke()
  big = big or newSmoke(16, true)
  big:Play({ x = 0.5, y = 0.40, scale = 1 })
end

-- Another character's fart: small cloud attached to their nameplate.
-- Returns false if WoW didn't allow attaching to it.
function ns.PlaySmallSmoke(anchor, drop, scale)
  local pick
  for i = 1, #small do
    if not small[i]:IsPlaying() then pick = small[i]; break end
  end
  if not pick then
    if #small < 3 then
      pick = newSmoke(7, false)
      small[#small + 1] = pick
    else
      pick = small[1]
    end
  end
  return pick:Play({ anchor = anchor, drop = drop, scale = scale, life = 0.75 })
end
