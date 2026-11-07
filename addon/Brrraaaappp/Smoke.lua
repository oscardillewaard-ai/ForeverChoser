-- Brrraaaappp: bruine rookwolk over het scherm bij elke scheet.
-- De wolkjes komen uit het midden van je scherm (ongeveer waar je character
-- staat), zetten uit, drijven omhoog en naar opzij en vervagen weer.
-- De rook ligt onder de interface (strata BACKGROUND): hij bedekt de wereld,
-- maar je actiebalken en chat blijven leesbaar.
local ADDON, ns = ...

local MEDIA = "Interface\\AddOns\\" .. ADDON .. "\\media\\"
local PUFF_TEXTURES = { MEDIA .. "smoke1.tga", MEDIA .. "smoke2.tga", MEDIA .. "smoke3.tga" }
local VIGNETTE_TEXTURE = MEDIA .. "vignette.tga"

local NUM_PUFFS = 16
local DURATION = 4.5      -- seconden, hele effect
local ORIGIN_Y = 0.40     -- hoogte van de bron, als deel van de schermhoogte (vanaf onder)
local VIGNETTE_MAX = 0.55 -- hoe bruin de randen van het scherm worden

-- Bruintinten; ze worden vermenigvuldigd met de grijze rooktextuur.
local BROWNS = {
  { 0.55, 0.38, 0.18 },
  { 0.45, 0.30, 0.13 },
  { 0.62, 0.45, 0.24 },
  { 0.38, 0.25, 0.10 },
}

local frame, vignette
local puffs = {}
local t = 0

local function rand(lo, hi)
  return lo + math.random() * (hi - lo)
end

local function easeOut(u)
  return 1 - (1 - u) * (1 - u)
end

local function vignetteAlpha(time)
  if time < 0.6 then return VIGNETTE_MAX * time / 0.6 end
  if time < 2.0 then return VIGNETTE_MAX end
  return math.max(0, VIGNETTE_MAX * (1 - (time - 2.0) / (DURATION - 2.0)))
end

local function puffAlpha(p, age, u)
  local fadeIn = math.min(1, age / 0.25)
  local fadeOut = 1
  if u > 0.3 then fadeOut = (1 - (u - 0.3) / 0.7) ^ 1.4 end
  return p.maxAlpha * fadeIn * fadeOut
end

local function onUpdate(self, elapsed)
  t = t + elapsed
  if t >= DURATION then
    self:Hide()
    return
  end
  local W, H = self:GetWidth(), self:GetHeight()
  vignette:SetAlpha(vignetteAlpha(t))
  for i = 1, NUM_PUFFS do
    local p = puffs[i]
    local age = t - p.delay
    if age <= 0 or age >= p.life then
      p.tex:Hide()
    else
      local u = age / p.life
      local e = easeOut(u)
      local size = (p.size0 + (p.size1 - p.size0) * e) * H
      local x = p.x0 * W + p.dx * H * e
      local y = (p.y0 + p.dy * e + p.rise * u) * H
      p.tex:ClearAllPoints()
      p.tex:SetPoint("CENTER", self, "BOTTOMLEFT", x, y)
      p.tex:SetSize(size, size)
      if p.tex.SetRotation then p.tex:SetRotation(p.rot0 + p.spin * age) end
      p.tex:SetAlpha(puffAlpha(p, age, u))
      p.tex:Show()
    end
  end
end

local function setup()
  frame = CreateFrame("Frame", nil, UIParent)
  frame:SetAllPoints(UIParent)
  frame:SetFrameStrata("BACKGROUND")
  frame:Hide()

  vignette = frame:CreateTexture(nil, "BACKGROUND")
  vignette:SetAllPoints(frame)
  vignette:SetTexture(VIGNETTE_TEXTURE)
  vignette:SetVertexColor(0.30, 0.19, 0.07)

  for i = 1, NUM_PUFFS do
    local tex = frame:CreateTexture(nil, "ARTWORK")
    tex:Hide()
    puffs[i] = { tex = tex }
  end
  frame:SetScript("OnUpdate", onUpdate)
end

-- Alle afstanden en maten zijn in delen van de schermhoogte, zodat het
-- er op elke resolutie en UI-schaal hetzelfde uitziet.
local function randomize()
  for i = 1, NUM_PUFFS do
    local p = puffs[i]
    local angle = math.rad(90 + rand(-80, 80))   -- omhoog, met uitschieters naar opzij
    local dist = rand(0.25, 0.70)
    p.delay = (i - 1) / NUM_PUFFS * 0.6 + rand(0, 0.08)
    p.life = rand(2.6, 3.8)
    p.x0 = 0.5 + rand(-0.03, 0.03)               -- deel van de schermbreedte
    p.y0 = ORIGIN_Y + rand(-0.02, 0.02)
    p.dx = math.cos(angle) * dist
    p.dy = math.sin(angle) * dist * 0.8
    p.rise = rand(0.05, 0.15)                    -- rook stijgt op
    p.size0 = rand(0.10, 0.16)
    p.size1 = rand(0.60, 1.00)
    p.rot0 = rand(0, 2 * math.pi)
    p.spin = rand(-0.5, 0.5)
    p.maxAlpha = rand(0.65, 0.90)
    local c = BROWNS[math.random(#BROWNS)]
    p.tex:SetTexture(PUFF_TEXTURES[math.random(#PUFF_TEXTURES)])
    p.tex:SetVertexColor(c[1], c[2], c[3])
    p.tex:Hide()
  end
end

function ns.PlaySmoke()
  if not frame then setup() end
  randomize()
  t = 0
  vignette:SetAlpha(0)
  frame:Show()
end
