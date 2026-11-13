-- Brrraaaappp: settings window. Open with /brap, or via the game's AddOns options.
local ADDON, ns = ...

local panel
local refreshers = {}
local BACKDROP_TEMPLATE = BackdropTemplateMixin and "BackdropTemplate" or nil
local ROWS = 5

local function tooltip(widget, title, text)
  widget:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText(title, 1, 1, 1)
    GameTooltip:AddLine(text, 1, 0.82, 0, true)
    GameTooltip:Show()
  end)
  widget:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

local function header(parent, text, y)
  local fs = parent:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  fs:SetPoint("TOPLEFT", 20, y)
  fs:SetText(text)
  local line = parent:CreateTexture(nil, "ARTWORK")
  line:SetHeight(1)
  line:SetPoint("LEFT", fs, "RIGHT", 8, 0)
  line:SetPoint("RIGHT", parent, "RIGHT", -20, 0)
  line:SetColorTexture(1, 0.82, 0, 0.3)
  return fs
end

local function check(parent, label, tip, key, x, y, onChange)
  local cb = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
  cb:SetSize(26, 26)
  cb:SetPoint("TOPLEFT", x, y)
  local fs = parent:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
  fs:SetPoint("LEFT", cb, "RIGHT", 2, 1)
  fs:SetText(label)
  cb:SetScript("OnClick", function(self)
    ns.db[key] = self:GetChecked() and true or false
    if onChange then onChange() end
  end)
  if tip then tooltip(cb, label, tip) end
  refreshers[#refreshers + 1] = function() cb:SetChecked(ns.db[key]) end
  return cb
end

local function slider(parent, label, key, minV, maxV, x, y, onChange)
  local s = CreateFrame("Slider", nil, parent, BACKDROP_TEMPLATE)
  s:SetOrientation("HORIZONTAL")
  s:SetSize(150, 15)
  s:SetPoint("TOPLEFT", x, y)
  if s.SetBackdrop then
    s:SetBackdrop({
      bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
      edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
      tile = true, tileSize = 8, edgeSize = 8,
      insets = { left = 3, right = 3, top = 6, bottom = 6 },
    })
  end
  s:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
  s:SetMinMaxValues(minV, maxV)
  s:SetValueStep(1)
  if s.SetObeyStepOnDrag then s:SetObeyStepOnDrag(true) end
  local title = s:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
  title:SetPoint("BOTTOMLEFT", s, "TOPLEFT", 0, 3)
  title:SetText(label)
  local value = s:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
  value:SetPoint("LEFT", s, "RIGHT", 8, 0)
  s:SetScript("OnValueChanged", function(self, v)
    v = math.floor(v + 0.5)
    value:SetText(v .. " min")
    if self.updating or ns.db[key] == v then return end
    ns.db[key] = v
    if onChange then onChange(key, v) end
  end)
  local function refresh()
    s.updating = true
    s:SetValue(ns.db[key])
    value:SetText(ns.db[key] .. " min")
    s.updating = false
  end
  refreshers[#refreshers + 1] = refresh
  s.refresh = refresh
  return s
end

local function button(parent, text, width, x, y, onClick)
  local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  b:SetSize(width, 22)
  b:SetPoint("TOPLEFT", x, y)
  b:SetText(text)
  b:SetScript("OnClick", onClick)
  return b
end

local function refreshAll()
  for _, r in ipairs(refreshers) do r() end
end

-- keeps min <= max for a pair of sliders; sliders.min/.max are filled in later
local function pairFix(minKey, maxKey, sliders, after)
  return function(key)
    local db = ns.db
    if db[minKey] > db[maxKey] then
      if key == minKey then db[maxKey] = db[minKey]; sliders.max.refresh()
      else db[minKey] = db[maxKey]; sliders.min.refresh() end
    end
    after()
  end
end

local function createPanel()
  local f = CreateFrame("Frame", "BrrraaaapppOptions", UIParent, BACKDROP_TEMPLATE)
  f:SetSize(470, 660)
  f:SetPoint("CENTER")
  f:SetFrameStrata("DIALOG")
  f:SetClampedToScreen(true)
  if f.SetBackdrop then
    f:SetBackdrop({
      bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
      edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
      tile = true, tileSize = 32, edgeSize = 32,
      insets = { left = 11, right = 12, top = 12, bottom = 11 },
    })
  end
  f:EnableMouse(true)
  f:SetMovable(true)
  f:RegisterForDrag("LeftButton")
  f:SetScript("OnDragStart", f.StartMoving)
  f:SetScript("OnDragStop", f.StopMovingOrSizing)
  tinsert(UISpecialFrames, "BrrraaaapppOptions") -- Escape closes it
  f:Hide()

  local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
  close:SetPoint("TOPRIGHT", -6, -6)

  local title = f:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
  title:SetPoint("TOP", 0, -20)
  title:SetText("Brrraaaappp")
  local sub = f:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
  sub:SetPoint("TOP", title, "BOTTOM", 0, -4)
  sub:SetText("When nature calls, it calls loudly.")

  local reschedule = function() ns.Reschedule() end
  local rescheduleOthers = function() ns.ScheduleOthers() end

  -- Your farts
  header(f, "Your farts", -64)
  check(f, "Automatic farts", "Fart every now and then, at a random moment.", "enabled", 20, -84, reschedule)
  check(f, "Also during combat", "Allow farts (yours and others') while you're in combat.", "inCombat", 240, -84)
  check(f, "Fart text", "A disgusting line based on your race and class, shown like an emote: \"<you> farts, and ...\".", "chatLine", 20, -110)
  check(f, "Brown smoke cloud", "A brown cloud over your screen. Only you see it.", "smoke", 240, -110)
  check(f, "Send it as /e emote", "Sends the fart text as a real /e emote, so OTHER PLAYERS SEE IT. Off: only you see it. At most one emote every 20 seconds.", "emote", 20, -136)
  local own = {}
  local fixOwn = pairFix("minMinutes", "maxMinutes", own, reschedule)
  own.min = slider(f, "Shortest wait", "minMinutes", 1, 60, 26, -184, fixOwn)
  own.max = slider(f, "Longest wait", "maxMinutes", 1, 120, 246, -184, fixOwn)
  button(f, "Fart now!", 120, 20, -212, function() ns.FartNow() end)
  local nextText = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
  nextText:SetPoint("TOPLEFT", 150, -217)

  -- Other characters
  header(f, "Other characters", -252)
  check(f, "Others fart too", "Nearby characters fart sometimes: your group, your target, your pet and anyone who just did something near you. Sound comes from their direction when the game tells us where they are, quieter further away. With nameplates on (V) you also get the direction and a small cloud for everyone on screen. Only you hear and see this.", "others", 20, -272, rescheduleOthers)
  check(f, "Small smoke cloud", "A small cloud at their nameplate (only for characters with a visible nameplate).", "othersSmoke", 240, -272)
  check(f, "Chat line", "Tells you who it was. Only you see it.", "othersChat", 20, -298)
  local oth = {}
  local fixOthers = pairFix("othersMin", "othersMax", oth, rescheduleOthers)
  oth.min = slider(f, "Shortest wait", "othersMin", 1, 60, 26, -346, fixOthers)
  oth.max = slider(f, "Longest wait", "othersMax", 1, 120, 246, -346, fixOthers)
  button(f, "Blame someone now", 150, 20, -374, function()
    local ok, found = pcall(ns.BlameSomeone)
    if not ok then
      ns.msg("|cffff4040Error:|r " .. tostring(found) .. " (please report this)")
    elseif not found then
      ns.msg("Nobody nearby to blame. Find some company, or turn on nameplates (V). Type /brap debug to see who I can find.")
    end
  end)

  -- Sounds
  header(f, "Sounds", -412)
  check(f, "Built-in farts", "The 11 fart recordings that come with the addon.", "builtin", 20, -432)
  local help = f:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
  help:SetPoint("TOPLEFT", 24, -464)
  help:SetWidth(420)
  help:SetJustifyH("LEFT")
  help:SetText("Add your own: put .ogg or .mp3 files in Interface\\AddOns\\BrrraaaapppCustom\\, restart WoW, then type the file name below. A game sound ID (number) also works.")

  local input = CreateFrame("EditBox", "BrrraaaapppCustomInput", f, "InputBoxTemplate")
  input:SetSize(270, 20)
  input:SetPoint("TOPLEFT", 30, -500)
  input:SetAutoFocus(false)
  input:SetMaxLetters(200)

  local list = CreateFrame("Frame", nil, f)
  list:SetPoint("TOPLEFT", 20, -530)
  list:SetSize(430, ROWS * 22)
  list:EnableMouseWheel(true)
  list.offset = 0
  local more = f:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
  more:SetPoint("TOPLEFT", list, "BOTTOMLEFT", 4, -2)

  local rows = {}
  local function refreshList()
    local custom = ns.db.custom
    list.offset = math.max(0, math.min(list.offset, #custom - ROWS))
    for i = 1, ROWS do
      local row, entry = rows[i], custom[i + list.offset]
      if entry then
        row.name:SetText(entry)
        row.index = i + list.offset
        row:Show()
      else
        row:Hide()
      end
    end
    if #custom == 0 then
      more:SetText("No custom farts yet.")
    elseif #custom > ROWS then
      more:SetText(string.format("%d custom farts. Scroll for more.", #custom))
    else
      more:SetText("")
    end
  end
  for i = 1, ROWS do
    local row = CreateFrame("Frame", nil, list)
    row:SetSize(430, 22)
    row:SetPoint("TOPLEFT", 0, -(i - 1) * 22)
    row.name = row:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    row.name:SetPoint("LEFT", 8, 0)
    row.name:SetWidth(290)
    row.name:SetJustifyH("LEFT")
    local playB = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
    playB:SetSize(56, 20)
    playB:SetPoint("RIGHT", -36, 0)
    playB:SetText("Play")
    playB:SetScript("OnClick", function()
      local entry = ns.db.custom[row.index]
      if entry and not ns.TestCustom(entry) then
        ns.msg("Couldn't play '" .. entry .. "'. Is it in Interface\\AddOns\\BrrraaaapppCustom\\ and did you restart WoW?")
      end
    end)
    local delB = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
    delB:SetSize(30, 20)
    delB:SetPoint("RIGHT", -2, 0)
    delB:SetText("X")
    delB:SetScript("OnClick", function()
      table.remove(ns.db.custom, row.index)
      refreshList()
    end)
    rows[i] = row
  end
  list:SetScript("OnMouseWheel", function(self, delta)
    self.offset = self.offset - delta
    refreshList()
  end)

  local function addEntry()
    local entry = strtrim(input:GetText() or "")
    input:SetText("")
    input:ClearFocus()
    if entry == "" then return end
    for _, e in ipairs(ns.db.custom) do
      if strlower(e) == strlower(entry) then return end
    end
    table.insert(ns.db.custom, entry)
    list.offset = #ns.db.custom
    refreshList()
    if ns.TestCustom(entry) then
      ns.msg("Added '" .. entry .. "'.")
    else
      ns.msg("Added '" .. entry .. "', but it didn't play. Put the file in Interface\\AddOns\\BrrraaaapppCustom\\ and restart WoW. Until then a built-in fart plays instead.")
    end
  end
  input:SetScript("OnEnterPressed", addEntry)
  input:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
  button(f, "Add", 70, 312, -499, addEntry)
  refreshers[#refreshers + 1] = refreshList

  local footer = f:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
  footer:SetPoint("BOTTOM", 0, 18)
  footer:SetText("/brap now  -  /brap on | off  -  /brap status")

  local elapsedSince = 1
  f:SetScript("OnUpdate", function(_, elapsed)
    elapsedSince = elapsedSince + elapsed
    if elapsedSince < 1 then return end
    elapsedSince = 0
    nextText:SetText(ns.NextText())
  end)
  f:SetScript("OnShow", refreshAll)
  return f
end

function ns.ShowOptions()
  panel = panel or createPanel()
  panel:Show()
end

function ns.ToggleOptions()
  panel = panel or createPanel()
  if panel:IsShown() then panel:Hide() else panel:Show() end
end

-- A small page in the game's own AddOns options with a button to our window.
local function registerBlizzardOptions()
  local p = CreateFrame("Frame")
  p.name = "Brrraaaappp"
  local t = p:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
  t:SetPoint("TOPLEFT", 16, -16)
  t:SetText("Brrraaaappp")
  local b = CreateFrame("Button", nil, p, "UIPanelButtonTemplate")
  b:SetSize(180, 24)
  b:SetPoint("TOPLEFT", 16, -50)
  b:SetText("Open settings")
  b:SetScript("OnClick", function()
    if SettingsPanel and SettingsPanel:IsShown() then HideUIPanel(SettingsPanel) end
    if InterfaceOptionsFrame and InterfaceOptionsFrame:IsShown() then InterfaceOptionsFrame:Hide() end
    ns.ShowOptions()
  end)
  if Settings and Settings.RegisterCanvasLayoutCategory then
    local category = Settings.RegisterCanvasLayoutCategory(p, "Brrraaaappp")
    Settings.RegisterAddOnCategory(category)
  elseif InterfaceOptions_AddCategory then
    InterfaceOptions_AddCategory(p)
  end
end
pcall(registerBlizzardOptions)
