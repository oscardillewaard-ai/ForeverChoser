-- Brrraaaappp: brown smoke clouds.
-- A big cloud (with a brown screen edge) for your own farts, and small clouds
-- that follow other characters' nameplates. Smoke sits below the UI
-- (strata BACKGROUND): it covers the world, your bars and chat stay readable.
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
  f:SetAllPoints(UIParent)
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
-- opts.scale: 1 = full-size cloud; opts.life: lifetime multiplier
-- opts.follow: optional function returning a new x, y each frame (or nil)
function Smoke:Play(opts)
  local n = #self.puffs
  self.ox, self.oy = opts.x, opts.y
  self.scale = opts.scale or 1
  self.follow = opts.follow
  self.t, self.duration = 0, 0
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
  self.frame:Show()
end

function Smoke:Update(elapsed)
  self.t = self.t + elapsed
  local t = self.t
  if t >= self.duration then
    self.frame:Hide()
    return
  end
  if self.follow then
    local fx, fy = self.follow()
    if fx then self.ox, self.oy = fx, fy end
  end
  local W, H = self.frame:GetWidth(), self.frame:GetHeight()
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
      local x = (self.ox + p.jx * s) * W + p.dx * e * s * H
      local y = (self.oy + p.jy * s + (p.dy * e + p.rise * u) * s) * H
      local fadeIn = math.min(1, age / 0.25)
      local fadeOut = 1
      if u > 0.3 then fadeOut = (1 - (u - 0.3) / 0.7) ^ 1.4 end
      p.tex:ClearAllPoints()
      p.tex:SetPoint("CENTER", self.frame, "BOTTOMLEFT", x, y)
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

-- Another character's fart: small cloud, optionally following their nameplate.
function ns.PlaySmallSmoke(x, y, scale, follow)
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
  pick:Play({ x = x, y = y, scale = scale, life = 0.75, follow = follow })
end
