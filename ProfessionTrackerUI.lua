-- ########################################################
-- ## Profession Tracker: UI (Refactored)               ##
-- ########################################################

local ProfessionTrackerUI = CreateFrame("Frame", "ProfessionTrackerUIFrame", UIParent, "BackdropTemplate")

ProfessionTrackerUI:SetSize(500, 650)
ProfessionTrackerUI:SetPoint("CENTER")
ProfessionTrackerUI:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})

ProfessionTrackerUI:SetBackdropColor(0, 0, 0, 0.8)
ProfessionTrackerUI:Hide()

-- Make the frame movable
ProfessionTrackerUI:SetMovable(true)
ProfessionTrackerUI:EnableMouse(true)
ProfessionTrackerUI:RegisterForDrag("LeftButton")
ProfessionTrackerUI:SetScript("OnDragStart", ProfessionTrackerUI.StartMoving)
ProfessionTrackerUI:SetScript("OnDragStop", ProfessionTrackerUI.StopMovingOrSizing)

ProfessionTrackerUI.selectedCharacter = nil
ProfessionTrackerUI.selectedProfession = nil
ProfessionTrackerUI.currentExpansionIndex = 1
ProfessionTrackerUI.viewMode = "dashboard" -- "dashboard" or "detail"

--------------------------------------------------------
-- Close Button
--------------------------------------------------------
local closeButton = CreateFrame("Button", nil, ProfessionTrackerUI, "UIPanelCloseButton")
closeButton:SetPoint("TOPRIGHT", ProfessionTrackerUI, "TOPRIGHT", -5, -5)
closeButton:SetScript("OnClick", function() ProfessionTrackerUI:Hide() end)

--------------------------------------------------------
-- Title
--------------------------------------------------------
ProfessionTrackerUI.title = ProfessionTrackerUI:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
ProfessionTrackerUI.title:SetPoint("TOP", 0, -10)
ProfessionTrackerUI.title:SetText("Profession Tracker")

--------------------------------------------------------
-- View Toggle Buttons
--------------------------------------------------------
local viewButtonFrame = CreateFrame("Frame", nil, ProfessionTrackerUI)
viewButtonFrame:SetSize(300, 30)
viewButtonFrame:SetPoint("TOP", 0, -40)

local dashboardButton = CreateFrame("Button", nil, viewButtonFrame, "UIPanelButtonTemplate")
dashboardButton:SetSize(120, 25)
dashboardButton:SetPoint("LEFT", 0, 0)
dashboardButton:SetText("Dashboard")
dashboardButton:SetScript("OnClick", function()
    ProfessionTrackerUI.viewMode = "dashboard"
    ProfessionTrackerUI:Refresh()
end)

local detailButton = CreateFrame("Button", nil, viewButtonFrame, "UIPanelButtonTemplate")
detailButton:SetSize(120, 25)
detailButton:SetPoint("LEFT", dashboardButton, "RIGHT", 10, 0)
detailButton:SetText("Character Detail")
detailButton:SetScript("OnClick", function()
    ProfessionTrackerUI.viewMode = "detail"
    ProfessionTrackerUI:Refresh()
end)

ProfessionTrackerUI.dashboardButton = dashboardButton
ProfessionTrackerUI.detailButton = detailButton

--------------------------------------------------------
-- Scroll Frame for Content
--------------------------------------------------------
local scrollFrame = CreateFrame("ScrollFrame", "ProfessionTrackerScrollFrame", ProfessionTrackerUI, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 10, -80)
scrollFrame:SetPoint("BOTTOMRIGHT", -30, 10)

local scrollChild = CreateFrame("Frame")
scrollFrame:SetScrollChild(scrollChild)
scrollChild:SetWidth(scrollFrame:GetWidth())
scrollChild:SetHeight(1)

ProfessionTrackerUI.scrollFrame = scrollFrame
ProfessionTrackerUI.scrollChild = scrollChild

--------------------------------------------------------
-- Clears Scroller when navigating to different views
--------------------------------------------------------
function ProfessionTrackerUI:ClearScrollChild()
    if not self.scrollChild then return end
    
    -- Clear all child frames (buttons, frames, etc.)
    for _, child in pairs({self.scrollChild:GetChildren()}) do
        child:Hide()
        child:ClearAllPoints()
        child:SetParent(nil)
    end
    
    -- Clear fontstrings and textures attached directly to scrollChild
    for _, region in pairs({self.scrollChild:GetRegions()}) do
        if region and region.Hide then
            region:Hide()
        end
    end
end

-- ============================================================
-- Redraw character detail when data changes
-- ============================================================
function ProfessionTrackerUI:RedrawCharacterDetail()
    if self.currentCharacterKey then
        -- Rebuild the detail view entirely
        self:ShowCharacterDetail(self.currentCharacterKey)
    end
end

-- ========================================================
-- Opens or refreshes the standalone window showing missing one-time treasures
-- Automatically updates when treasure progress changes
-- ========================================================
function ProfessionTrackerUI:ShowMissingTreasureWindow(missingList, profName, expName)
    if not missingList or #missingList == 0 then
        if self.missingTreasureWindow then
            self.missingTreasureWindow:Hide()
        end
        return
    end

    -- Create the window if it doesn't exist
    local win = self.missingTreasureWindow
    if not win then
        win = CreateFrame("Frame", "ProfTracker_MissingTreasureWindow", UIParent, "BackdropTemplate")
        win:SetSize(360, 220)
        win:SetPoint("CENTER")
        win:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 16,
            insets = { left = 6, right = 6, top = 6, bottom = 6 }
        })
        win:SetBackdropColor(0, 0, 0, 0.9)
        win:EnableMouse(true)
        win:SetMovable(true)
        win:RegisterForDrag("LeftButton")
        win:SetScript("OnDragStart", win.StartMoving)
        win:SetScript("OnDragStop", win.StopMovingOrSizing)

        -- Title
        win.title = win:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
        win.title:SetPoint("TOP", 0, -8)

        -- Subtitle
        win.sub = win:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        win.sub:SetPoint("TOP", win.title, "BOTTOM", 0, -2)

        -- Close button (top right)
        local close = CreateFrame("Button", nil, win, "UIPanelCloseButton")
        close:SetPoint("TOPRIGHT", -6, -6)
        close:SetScript("OnClick", function() win:Hide() end)

        -- Scrollframe
        win.scroll = CreateFrame("ScrollFrame", nil, win, "UIPanelScrollFrameTemplate")
        win.scroll:SetPoint("TOPLEFT", 12, -48)
        win.scroll:SetPoint("BOTTOMRIGHT", -12, 40)

        win.content = CreateFrame("Frame", nil, win.scroll)
        win.content:SetSize(320, 1)
        win.scroll:SetScrollChild(win.content)

        -- Clear waypoint button
        win.clearBtn = CreateFrame("Button", nil, win, "UIPanelButtonTemplate")
        win.clearBtn:SetSize(120, 20)
        win.clearBtn:SetPoint("BOTTOMLEFT", 12, 8)
        win.clearBtn:SetText("Clear Waypoint")
        win.clearBtn:SetScript("OnClick", function()
            if C_Map and C_Map.ClearUserWaypoint then
                C_Map.ClearUserWaypoint()
            end
        end)

        -- Close window button
        win.closeBtn = CreateFrame("Button", nil, win, "UIPanelButtonTemplate")
        win.closeBtn:SetSize(120, 20)
        win.closeBtn:SetPoint("BOTTOMRIGHT", -12, 8)
        win.closeBtn:SetText("Close")
        win.closeBtn:SetScript("OnClick", function() win:Hide() end)

        self.missingTreasureWindow = win
    end

    -- Store state for auto-refresh logic
    win.profName = profName
    win.expName = expName
    win.isActive = true

    -- Update title/subtitle
    win.title:SetText(string.format("%s — Missing Treasures", profName or "Profession"))
    win.sub:SetText(expName or "")

    -- Helper: Attempt to place a waypoint
    local function PlaceWaypoint(mapID, x, y)
        mapID = tonumber(mapID)
        x = tonumber(x)
        y = tonumber(y)

        if not mapID or not x or not y then
            print("|cffffaa00[Profession Tracker]|r Invalid waypoint data.")
            return
        end

        local nx, ny = x / 100, y / 100

        if C_Map and C_Map.CanSetUserWaypointOnMap and C_Map.SetUserWaypoint then
            if C_Map.CanSetUserWaypointOnMap(mapID) then

                local point = UiMapPoint.CreateFromCoordinates(mapID, nx, ny)

                if C_Map.ClearUserWaypoint then
                    C_Map.ClearUserWaypoint()
                end

                local ok = pcall(function()
                    C_Map.SetUserWaypoint(point)
                end)

                if ok then
                    print(string.format("|cff00ff00[Profession Tracker]|r Waypoint set: (%.1f, %.1f) on map %d", x, y, mapID))
                    if WorldMapFrame and not WorldMapFrame:IsShown() then
                        ToggleWorldMap()
                    end
                    if WorldMapFrame and WorldMapFrame.SetMapID then
                        WorldMapFrame:SetMapID(mapID)
                    end
                else
                    print("|cffff0000[Profession Tracker]|r Failed to set waypoint.")
                end
                return
            else
                print("|cffffaa00[Profession Tracker]|r Cannot set waypoint on this map.")
            end
        end

        print(string.format("|cffffaa00[Profession Tracker]|r Coordinates: %.1f, %.1f (map %d)", x, y, mapID))
    end

    -- Clear old rows
    local content = win.content
    for _, child in ipairs({ content:GetChildren() }) do
        child:Hide()
        child:SetParent(nil)
    end

    -- Populate rows
    local yOffset = 0
    for i, t in ipairs(missingList) do
        local row = CreateFrame("Button", nil, content)
        row:SetSize(300, 18)
        row:SetPoint("TOPLEFT", 0, -yOffset)

        local label = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        label:SetPoint("LEFT", 2, 0)
        label:SetJustifyH("LEFT")
        label:SetText(string.format("%d) %s (%.1f, %.1f)", i, t.name or "Unknown", t.x or 0, t.y or 0))

        row:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:AddLine(t.name or "Unknown")
            if t.mapID then GameTooltip:AddLine("Map ID: " .. t.mapID) end
            if t.questID then GameTooltip:AddLine("Quest ID: " .. t.questID) end
            GameTooltip:AddLine("Click to place waypoint.", 0.8, 0.8, 0.8)
            GameTooltip:Show()
        end)
        row:SetScript("OnLeave", function() GameTooltip:Hide() end)

        row:SetScript("OnClick", function()
            if t.mapID and t.x and t.y then
                PlaceWaypoint(t.mapID, t.x, t.y)
            end
        end)

        yOffset = yOffset + 20
    end

    content:SetHeight(math.max(yOffset, 1))
    win:Show()
end



-- ########################################################
-- ## Expansion Carousel for Detail View
-- ########################################################
-- Replace the existing CreateProfessionExpansionCard function with this version
local function CreateProfessionExpansionCard(parent, profName, profData, yOffset)
    local card = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    card:SetSize(440, 150)
    card:SetPoint("TOP", 0, yOffset)
    card:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    card:SetBackdropColor(0, 0, 0, 0.6)

    -- build profName -> profID map on first use (card-local cache)
    card._profNameToID = card._profNameToID or {}
    if next(card._profNameToID) == nil then
        for _, p in ipairs(ProfessionData) do
            card._profNameToID[p.name] = p.id
        end
    end

    ----------------------------------------------------
    -- Build a sortable list of expansions using per-character expData.id (fallback to 0)
    ----------------------------------------------------
    local expansionsList = {}
    for expName, expData in pairs(profData.expansions or {}) do
        local id = expData and expData.id or 0
        table.insert(expansionsList, { name = expName, id = id, data = expData })
    end

    table.sort(expansionsList, function(a, b)
        if (a.id or 0) ~= (b.id or 0) then
            return (a.id or 0) > (b.id or 0)
        end
        local aSkill = (a.data and a.data.skillLevel) or 0
        local bSkill = (b.data and b.data.skillLevel) or 0
        return aSkill > bSkill
    end)

    local expansionNames = {}
    for _, item in ipairs(expansionsList) do
        table.insert(expansionNames, item.name)
    end

    local currentIndex = 1

    ----------------------------------------------------
    -- UI elements
    ----------------------------------------------------
    local profTitle = card:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    profTitle:SetPoint("TOP", 0, -10)
    profTitle:SetText(profName)

    local leftButton = CreateFrame("Button", nil, card, "UIPanelButtonTemplate")
    leftButton:SetSize(25, 25)
    leftButton:SetPoint("TOPLEFT", 10, -40)
    leftButton:SetText("<")

    local rightButton = CreateFrame("Button", nil, card, "UIPanelButtonTemplate")
    rightButton:SetSize(25, 25)
    rightButton:SetPoint("TOPRIGHT", -10, -40)
    rightButton:SetText(">")

    local expansionLabel = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    expansionLabel:SetPoint("TOP", 0, -45)

    local skillText = card:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    skillText:SetPoint("TOP", expansionLabel, "BOTTOM", 0, -10)

    local knowledgeText = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    knowledgeText:SetPoint("TOP", skillText, "BOTTOM", 0, -5)

    ------------------------------------------------------------
    -- WEEKLY container: parented to card (guaranteed to persist)
    ------------------------------------------------------------
    card.weeklySection = CreateFrame("Frame", nil, card)
    -- we'll position it relative to knowledgeText inside UpdateDisplay
    card.weeklySection:SetHeight(10)  -- will grow dynamically
    card.weeklySection.entries = card.weeklySection.entries or {}

    card.weeklyHeader = card.weeklySection:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    card.weeklyHeader:SetPoint("TOPLEFT", 0, 0)
    card.weeklyHeader:SetText("Weekly Knowledge")

    ----------------------------------------------------
    -- Reusable helper for weekly entries
    ----------------------------------------------------
    local function AddWeeklyEntry(section, labelText, done)
        local line = CreateFrame("Frame", nil, section)
        line:SetHeight(18)

        line.status = line:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        line.status:SetPoint("LEFT", 0, 0)
        line.status:SetText(done and "|TInterface\\RaidFrame\\ReadyCheck-Ready:14:14|t" or "|TInterface\\RaidFrame\\ReadyCheck-NotReady:14:14|t")

        line.label = line:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        line.label:SetPoint("LEFT", line.status, "RIGHT", 6, 0)
        line.label:SetText(labelText or "Entry")

        table.insert(section.entries, line)
        return line
    end

    local function ClearSection(section)
        if not section then return end
        for _, v in ipairs(section.entries or {}) do
            if v.Hide then v:Hide() end
            v:SetParent(nil)
        end
        section.entries = {}
    end

    ----------------------------------------------------
    -- Update Display (keeps weekly code here but PROF ID known first)
    ----------------------------------------------------
    local function UpdateDisplay()
        if #expansionNames == 0 then
            expansionLabel:SetText("No expansion data")
            skillText:SetText("")
            knowledgeText:SetText("")
            card.weeklySection:Hide()
            return
        end

        local expName = expansionNames[currentIndex]
        local expData = profData.expansions and profData.expansions[expName]
        if not expData then
            expansionLabel:SetText(expName or "Unknown")
            skillText:SetText("Skill: 0 / 0")
            knowledgeText:SetText("")
            card.weeklySection:Hide()
            return
        end

        -- ensure we have a profID to look up KPReference
        local expIndex = expData and expData.id
        local profID = card._profNameToID and card._profNameToID[profName]
        if not profID then
            for _, p in ipairs(ProfessionData) do
                if p.name == profName then profID = p.id break end
            end
        end

        expansionLabel:SetText(expName)
        skillText:SetText(string.format("Skill: %d / %d",
            expData.skillLevel or 0, expData.maxSkillLevel or 0))

        if expData.pointsUntilMaxKnowledge ~= nil then
            local remaining = math.max(0, expData.pointsUntilMaxKnowledge or 0)
            knowledgeText:SetText(string.format("Knowledge Points: %d remaining", remaining))
            knowledgeText:Show()
        else
            knowledgeText:Hide()
        end

        -- Determine whether this expansion actually has one-time treasures in KPReference
        local hasOneTimeRef = false
        if profID and expIndex and KPReference[profID] and KPReference[profID][expIndex] and KPReference[profID][expIndex].oneTime then
            local oneTime = KPReference[profID][expIndex].oneTime
            -- Guard: some of your KPReference entries use .treasures nested
            if (type(oneTime) == "table" and (oneTime.treasures or next(oneTime))) then
                hasOneTimeRef = true
            end
        end

        -- Create persistent widgets if not present (created once)
        if not card.treasureStatus then
            card.treasureStatus = card:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            card.treasureStatus:SetPoint("TOPLEFT", skillText, "BOTTOMLEFT", 0, -25)

            card.openTreasureBtn = CreateFrame("Button", nil, card, "UIPanelButtonTemplate")
            card.openTreasureBtn:SetSize(110, 20)
            card.openTreasureBtn:SetPoint("LEFT", card.treasureStatus, "RIGHT", 8, 0)
            card.openTreasureBtn:SetText("Show Missing")
        end

        -- If expansion doesn't have any one-time treasures defined, hide both widgets entirely
        if not hasOneTimeRef then
            card.treasureStatus:Hide()
            card.openTreasureBtn:Hide()
        else
            -- There is a one-time reference — update the text and button visibility according to data
            local tex = expData.oneTimeCollectedAll
                and "|TInterface\\RaidFrame\\ReadyCheck-Ready:14:14|t"
                or "|TInterface\\RaidFrame\\ReadyCheck-NotReady:14:14|t"

            card.treasureStatus:SetText(string.format("%s One-Time Treasures", tex))
            card.treasureStatus:Show()

            if not expData.oneTimeCollectedAll and expData.missingOneTimeTreasures and #expData.missingOneTimeTreasures > 0 then
                card.openTreasureBtn:Show()
                card.openTreasureBtn:SetScript("OnClick", function()
                    ProfessionTrackerUI:ShowMissingTreasureWindow(expData.missingOneTimeTreasures, profName, expName)
                end)
            else
                card.openTreasureBtn:Hide()
            end
        end

        -- Position weeklySection under knowledgeText
        card.weeklySection:ClearAllPoints()
        card.weeklySection:SetPoint("TOPLEFT", knowledgeText, "BOTTOMLEFT", 0, -12)
        card.weeklySection:SetPoint("TOPRIGHT", knowledgeText, "BOTTOMRIGHT", 0, -12)
        ClearSection(card.weeklySection)

        local ref = (profID and KPReference[profID]) and KPReference[profID][expData.id]
        local wk = expData.weeklyKnowledgePoints or {}

        -- if no weekly data, hide section
        if not ref or not ref.weekly then
            card.weeklySection:Hide()
            card:SetHeight(150)
            return
        end

        -- show header and build content
        card.weeklySection:Show()
        local y = 0
        
        -- Update header text but don't add it to entries (it's persistent)
        card.weeklyHeader:ClearAllPoints()
        card.weeklyHeader:SetPoint("TOPLEFT", 0, y)
        card.weeklyHeader:Show()
        y = y - 24

        -- GATHERING PROFESSIONS (Herbalism 182, Mining 186, Skinning 393)
        if profID == 182 or profID == 186 or profID == 393 then
            card.weeklyHeader:SetText("Weekly Treasures")

            -- Use the saved weekly status, not live quest checks
            local completed = wk.treasures or false

            if ref.weekly.treasures and type(ref.weekly.treasures) == "table" then
                for i, item in ipairs(ref.weekly.treasures) do
                    local entry = AddWeeklyEntry(card.weeklySection, item.label or item.name or ("Treasure " .. i), completed)
                    entry:SetPoint("TOPLEFT", 0, y)
                    entry:SetPoint("TOPRIGHT", 0, y)
                    y = y - 20
                end
            end

        -- ENCHANTING – DISENCHANTING (show each task separately)
        elseif profID == 333 and ref.weekly.disenchanting then
            card.weeklyHeader:SetText("Weekly Disenchanting")

            -- Use the saved weekly status
            local completed = wk.disenchanting or false

            for i, it in ipairs(ref.weekly.disenchanting) do
                local entry = AddWeeklyEntry(
                    card.weeklySection,
                    it.label or ("Disenchant " .. i),
                    completed
                )

                entry:SetPoint("TOPLEFT", 0, y)
                entry:SetPoint("TOPRIGHT", 0, y)
                y = y - 20
            end

        -- OTHER PROFESSIONS: stacked treasure list (shows each treasure)
        elseif ref.weekly.treasures and type(ref.weekly.treasures) == "table" then
            card.weeklyHeader:SetText("Weekly Treasures")
            
            -- Use the saved weekly status
            local completed = wk.treasures or false
            
            for i, it in ipairs(ref.weekly.treasures) do
                local entry = AddWeeklyEntry(card.weeklySection, it.label or it.name or ("Treasure " .. i), completed)
                entry:SetPoint("TOPLEFT", 0, y)
                entry:SetPoint("TOPRIGHT", 0, y)
                y = y - 20
            end
        end

        -- finalize height of weeklySection based on entries
        local rows = #card.weeklySection.entries
        local newHeight = math.max(18 * rows + 8, 10)
        card.weeklySection:SetHeight(newHeight)

        -- increase card height to fit content
        local baseHeight = 150
        card:SetHeight(baseHeight + newHeight)
    end

    ----------------------------------------------------
    -- Arrow Logic (with Looping)
    ----------------------------------------------------
    leftButton:SetScript("OnClick", function()
        if #expansionNames == 0 then return end
        currentIndex = currentIndex - 1
        if currentIndex < 1 then currentIndex = #expansionNames end -- loop to end
        UpdateDisplay()
    end)

    rightButton:SetScript("OnClick", function()
        if #expansionNames == 0 then return end
        currentIndex = currentIndex + 1
        if currentIndex > #expansionNames then currentIndex = 1 end -- loop to start
        UpdateDisplay()
    end)

    UpdateDisplay()
    return card
end




--------------------------------------------------------
-- Helper Functions
--------------------------------------------------------

local function GetCharacterKey()
    local name, realm = UnitFullName("player")
    if not realm or realm == "" then
        realm = GetRealmName() or "UnknownRealm"
    end
    if not name then
        name = UnitName("player") or "UnknownPlayer"
    end
    return string.format("%s-%s", name, realm)
end

local function CreateWeeklyEntry(parent)
    local f = CreateFrame("Frame", nil, parent)
    f:SetHeight(20)

    f.icon = f:CreateTexture(nil, "ARTWORK")
    f.icon:SetSize(20, 20)
    f.icon:SetPoint("LEFT")

    f.status = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    f.status:SetPoint("LEFT", f.icon, "RIGHT", 4, 0)

    f.label = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    f.label:SetPoint("LEFT", f.status, "RIGHT", 4, 0)

    return f
end

function ProfessionTrackerUI:RefreshMissingTreasureWindow()
    
    local win = self.missingTreasureWindow
    if not win or not win:IsShown() then return end
    if not win.profName or not win.expName then return end

    -- Get current character key properly
    local function GetCharacterKey()
        local name, realm = UnitFullName("player")
        if not realm or realm == "" then
            realm = GetRealmName() or "UnknownRealm"
        end
        if not name then
            name = UnitName("player") or "UnknownPlayer"
        end
        return string.format("%s-%s", name, realm)
    end
    
    local charKey = GetCharacterKey()
    
    local charData = ProfessionTrackerDB.characters[charKey]
    if not charData then 
        return 
    end

    local profData = charData.professions[win.profName]
    if not profData then
        win:Hide()
        return
    end

    local expData = profData.expansions[win.expName]
    if not expData then
        win:Hide()
        return
    end


    -- If all treasures collected, close the window
    if expData.oneTimeCollectedAll then
        win:Hide()
        return
    end

    -- Rebuild using the updated missing treasures list
    local missing = expData.missingOneTimeTreasures or {}
    self:ShowMissingTreasureWindow(missing, win.profName, win.expName)
end

--------------------------------------------------------
-- Concentration Calculation Helpers
--------------------------------------------------------
local CONCENTRATION_REGEN_RATE = 10.41667 -- 250 per 24 hours = 10.41667 per hour

local function GetCurrentConcentration(currentConcentration, maxConcentration, lastUpdated)
    if not currentConcentration or not lastUpdated then
        return currentConcentration or 0
    end
    
    maxConcentration = maxConcentration or 1000
    
    -- If already at max, no need to calculate
    if currentConcentration >= maxConcentration then
        return maxConcentration
    end
    
    local currentTime = time()
    local timeElapsed = currentTime - lastUpdated
    local hoursElapsed = timeElapsed / 3600
    local concentrationGained = hoursElapsed * CONCENTRATION_REGEN_RATE
    
    local currentConcentration = currentConcentration + concentrationGained
    
    -- Cap at max
    if currentConcentration > maxConcentration then
        return maxConcentration
    end
    
    return math.floor(currentConcentration)
end

local function GetTimeUntilMax(currentConcentration, maxConcentration)
    maxConcentration = maxConcentration or 1000
    
    if currentConcentration >= maxConcentration then
        return ""
    end
    
    local missingConc = maxConcentration - currentConcentration
    local hoursToMax = missingConc / CONCENTRATION_REGEN_RATE
    local secondsToMax = hoursToMax * 3600
    
    local days = math.floor(secondsToMax / 86400)
    local hours = math.floor((secondsToMax % 86400) / 3600)
    local minutes = math.floor((secondsToMax % 3600) / 60)
    
    if days > 0 then
        return string.format(" - Full in: %dd %dh", days, hours)
    elseif hours > 0 then
        return string.format(" - Full in: %dh %dm", hours, minutes)
    else
        return string.format(" - Full in: %dm", minutes)
    end
end

    --------------------------------------------------------
    -- Modular: Add Profession Objectives to Dashboard Card
    -- Texture-based KP indicators + auto height
    --------------------------------------------------------
local function AddProfessionObjectives(parentFrame, profName, profData, yOffset)
    local container = CreateFrame("Frame", nil, parentFrame)
    container:SetWidth(parentFrame:GetWidth() - 20)
    container:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", 10, yOffset)

    local totalHeight = 0
    local padding = 6

    ----------------------------------------------------
    -- Find latest expansion
    ----------------------------------------------------
    local latestExp, latestData
    for expName, expData in pairs(profData.expansions or {}) do
        if not latestData or (expData.id or 0) > (latestData.id or 0) then
            latestExp, latestData = expName, expData
        end
    end

    if not latestData then
        local noData = container:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        noData:SetPoint("TOPLEFT", 0, 0)
        noData:SetText(profName .. " — no data")
        container:SetHeight(noData:GetStringHeight() + padding)
        return container, noData:GetStringHeight() + padding
    end

    ----------------------------------------------------
    -- Profession title + max-level checkmark
    ----------------------------------------------------
    local profText = container:CreateFontString(nil, "OVERLAY", "GameFontNormal")

    local isMaxed = (latestData.skillLevel == latestData.maxSkillLevel)
    local maxTex = isMaxed
        and "|TInterface\\RaidFrame\\ReadyCheck-Ready:16:16|t"
        or "|TInterface\\RaidFrame\\ReadyCheck-NotReady:16:16|t"

    profText:SetText(string.format("%s %s", maxTex, profName))
    profText:SetPoint("TOPLEFT", 0, 0)
    totalHeight = totalHeight + profText:GetStringHeight() + padding

    ----------------------------------------------------
    -- Weekly KP Indicators (using checkmark textures)
    ----------------------------------------------------
    local kpFrame = CreateFrame("Frame", nil, container)
    kpFrame:SetPoint("TOPLEFT", profText, "BOTTOMLEFT", 15, -padding)

    local objectives = {
        { key = "craftingOrderQuest", label = "KP Quest" },
        { key = "treasuresAllComplete", label = "KP Treasures" },
        { key = "treatise", label = "KP Treatise" },
    }

    local x = 0
    local kpRowHeight = 0

    for _, obj in ipairs(objectives) do
        local done = false
        if latestData.weeklyKnowledgePoints then
            done = latestData.weeklyKnowledgePoints[obj.key] == true
        end

        local tex = done
            and "|TInterface\\RaidFrame\\ReadyCheck-Ready:14:14|t"
            or "|TInterface\\RaidFrame\\ReadyCheck-NotReady:14:14|t"

        local fs = kpFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        fs:SetPoint("LEFT", x, 0)
        fs:SetText(string.format("%s %s", tex, obj.label))

        x = x + fs:GetStringWidth() + 20
        kpRowHeight = math.max(kpRowHeight, fs:GetStringHeight())
    end

    kpFrame:SetSize(x, kpRowHeight)
    totalHeight = totalHeight + kpRowHeight + padding

    ----------------------------------------------------
    -- Concentration
    ----------------------------------------------------
    local concText = container:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    concText:SetPoint("TOPLEFT", kpFrame, "BOTTOMLEFT", 0, -padding)

    local concValue = 0
    local maxConc = latestData.maxConcentration or 1000
    local timeRemaining = ""

    if latestData.concentration then
        if type(GetCurrentConcentration) == "function" then
            concValue = GetCurrentConcentration(latestData.concentration, maxConc, latestData.concentrationLastUpdated)
        else
            concValue = latestData.concentration
        end

        if concValue < maxConc and type(GetTimeUntilMax) == "function" then
            timeRemaining = GetTimeUntilMax(concValue, maxConc)
        end
        local pct = (concValue / maxConc) * 100
        local color = {1, 0, 0}
        if pct >= 75 then color = {0, 1, 0}
        elseif pct >= 40 then color = {1, 0.8, 0} end

        concText:SetTextColor(unpack(color))
        concText:SetText(string.format("Concentration: %d / %d (%.0f%%)%s",concValue, maxConc, pct, timeRemaining))
    end



    totalHeight = totalHeight + concText:GetStringHeight() + padding

    ----------------------------------------------------
    -- Finalize container
    ----------------------------------------------------
    container:SetHeight(totalHeight)
    return container, totalHeight
end


--------------------------------------------------------
-- Updated: CreateCharacterCard (Dynamic Height + Objectives)
-- expects AddProfessionObjectives to return positive height
--------------------------------------------------------
local function CreateCharacterCard(parent, charKey, charData, yOffset)
    local card = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    card:SetPoint("TOP", 0, yOffset)
    card:SetWidth(460)

    -- Background + subtle backdrop
    card.bg = card:CreateTexture(nil, "BACKGROUND")
    card.bg:SetAllPoints()
    card.bg:SetColorTexture(0.08, 0.08, 0.08, 0.85)

    ----------------------------------------------------
    -- Character Header
    ----------------------------------------------------
    local header = CreateFrame("Button", nil, card)
    header:SetSize(460, 40)
    header:SetPoint("TOP", 0, 0)

    local nameText = header:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    nameText:SetPoint("TOPLEFT", 10, -8)
    nameText:SetText(string.format("%s - Lv%d %s",
        charData.name or "Unknown",
        charData.level or 0,
        charData.class or ""))

    header:SetScript("OnClick", function()
        ProfessionTrackerUI.selectedCharacter = charKey
        ProfessionTrackerUI.viewMode = "detail"
        ProfessionTrackerUI:Refresh()
    end)

    ----------------------------------------------------
    -- Profession Info Section (stack professions vertically)
    ----------------------------------------------------
    local profInfoFrame = CreateFrame("Frame", nil, card)
    profInfoFrame:SetWidth(440)
    profInfoFrame:SetPoint("TOPLEFT", card, "TOPLEFT", 10, -48)

    local yPos = 0
    local profCount = 0
    local totalProfHeight = 0

    if charData.professions then
        for profName, profData in pairs(charData.professions) do
            profCount = profCount + 1
            if profCount <= 2 then -- show first two professions
                local _, profHeight = AddProfessionObjectives(profInfoFrame, profName, profData, yPos)
                -- AddProfessionObjectives returns positive height; stack downward
                yPos = yPos - profHeight - 12
                totalProfHeight = totalProfHeight + profHeight + 12
            end
        end
    else
        local noProfText = profInfoFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        noProfText:SetPoint("TOPLEFT", 10, 0)
        noProfText:SetText("No profession data found.")
        totalProfHeight = totalProfHeight + noProfText:GetStringHeight() + 8
    end

    profInfoFrame:SetHeight(totalProfHeight > 0 and totalProfHeight or 1)

    -- Total card height = header height (approx 50) + prof content + padding
    local totalHeight = 50 + profInfoFrame:GetHeight() + 12
    card:SetHeight(totalHeight)

    return card
end






-- local function CreateExpansionDisplay(parent, profData, expansionName, expansionData, yOffset)
--     local frame = CreateFrame("Frame", nil, parent)
--     frame:SetSize(440, 120)
--     frame:SetPoint("TOP", 0, yOffset)
    
--     -- Background
--     frame.bg = frame:CreateTexture(nil, "BACKGROUND")
--     frame.bg:SetAllPoints()
--     frame.bg:SetColorTexture(0.15, 0.15, 0.15, 0.5)
    
--     -- Expansion Name
--     local titleText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
--     titleText:SetPoint("TOPLEFT", 10, -10)
--     titleText:SetText(expansionName)
    
--     -- Skill Level
--     local skillText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
--     skillText:SetPoint("TOPLEFT", titleText, "BOTTOMLEFT", 0, -5)
    
--     local skillColor = (expansionData.skillLevel == expansionData.maxSkillLevel) and {0, 1, 0} or {1, 0.5, 0}
--     skillText:SetTextColor(unpack(skillColor))
--     skillText:SetText(string.format("Skill: %d / %d", expansionData.skillLevel or 0, expansionData.maxSkillLevel or 0))
    
--     -- Knowledge Points (if exists)
--     if expansionData.knowledgePoints or expansionData.pointsUntilMaxKnowledge then
--         local knowledgeText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
--         knowledgeText:SetPoint("TOPLEFT", skillText, "BOTTOMLEFT", 0, -5)
--         knowledgeText:SetTextColor(0.3, 0.7, 1)
--         -- knowledgeText:SetText(string.format("Knowledge: %d, 
--         --     (expansionData.knowledgePoints or 0)
--         --))
    
--         local missing = expansionData.pointsUntilMaxKnowledge or 0
--         if missing > 0 then
--             local missingText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
--             missingText:SetPoint("TOPLEFT", knowledgeText, "BOTTOMLEFT", 0, -3)
--             missingText:SetTextColor(1, 0.2, 0.2)
--             missingText:SetText(string.format("📚 %d KP remaining to collect", missing))
--         end
--     end


    
--     return frame
-- end

--------------------------------------------------------
-- Dashboard View
--------------------------------------------------------
function ProfessionTrackerUI:ShowDashboard()
    self:ClearScrollChild()

    local allChars = ProfessionTracker:GetAllCharacters()
    -- Clear existing content
    for _, child in pairs({self.scrollChild:GetChildren()}) do
        child:Hide()
        child:SetParent(nil)
    end
    
    local yOffset = 0
    
    if not ProfessionTrackerDB then
        print("|cffff0000[Profession Tracker]|r ProfessionTrackerDB is nil in ShowDashboard")
        local noDataText = self.scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        noDataText:SetPoint("TOP", 0, -20)
        noDataText:SetText("Database not initialized. Try reloading UI (/reload)")
        return
    end
    
    if not allChars then
        print("|cffff0000[Profession Tracker]|r No characters table found")
        local noDataText = self.scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        noDataText:SetPoint("TOP", 0, -20)
        noDataText:SetText("No character data found. Open your professions to scan.")
        return
    end
    
    -- Debug: Print character count
    local charCount = 0
    
    for charKey, charData in pairs(allChars) do
        if charKey ~= "version" and type(charData) == "table" then
            charCount = charCount + 1
            print("|cff00ff00[Profession Tracker]|r Found character:", charKey)
        end
    end
    
    if charCount == 0 then
        local noDataText = self.scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        noDataText:SetPoint("TOP", 0, -20)
        noDataText:SetText("No character data found. Open your professions to scan.")
        return
    end
    
    -- Sort characters so current player is first
local currentKey = UnitFullName("player")
if currentKey then
    local realm = GetRealmName()
    currentKey = string.format("%s-%s", currentKey, realm)
end

-- Build a sorted list
local sortedKeys = {}
for charKey, charData in pairs(allChars) do
    if charKey ~= "version" and type(charData) == "table" then
        table.insert(sortedKeys, charKey)
    end
end

table.sort(sortedKeys, function(a, b)
    -- Put current character first, others sorted by last login
    if a == currentKey then return true end
    if b == currentKey then return false end
    local aData = allChars[a]
    local bData = allChars[b]
    return (aData.lastLogin or 0) > (bData.lastLogin or 0)
end)

-- Create cards in sorted order
for _, charKey in ipairs(sortedKeys) do
    local charData = allChars[charKey]
    local card = CreateCharacterCard(self.scrollChild, charKey, charData, yOffset)
    -- Use the actual card height + spacing for next card
    yOffset = yOffset - card:GetHeight() - 15
end

    
    self.scrollChild:SetHeight(math.abs(yOffset))
    self.scrollFrame:SetVerticalScroll(0)

    print("|cff00ff00[Profession Tracker]|r Created", charCount, "character cards")
end

----------------------------------------------------------
-- NEW: Dynamic 1–2 card grid layout for detail view
----------------------------------------------------------
local function LayoutProfessionCards(scrollChild, cards)
    if #cards == 0 then return end

    local availableWidth = scrollChild:GetWidth() - 20
    local cardWidth = cards[1]:GetWidth()  -- 440 from your CreateProfessionExpansionCard
    local spacingX = 10
    local spacingY = 14

    -- Determine how many cards fit per row.
    -- If 2 fit → 2 per row. Otherwise 1.
    local cardsPerRow = (cardWidth * 2 + spacingX) <= availableWidth and 2 or 1

    local x = 0
    local y = -10
    local rowHeight = 0
    local col = 1

    for i, card in ipairs(cards) do
        card:ClearAllPoints()

        -- If this card is the first in its row
        if col == 1 then
            card:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 10, y)
            rowHeight = card:GetHeight()
        else
            -- Place next card to the right
            card:SetPoint("TOPLEFT", cards[i-1], "TOPRIGHT", spacingX, 0)
            rowHeight = math.max(rowHeight, card:GetHeight())
        end

        -- Move to next column
        col = col + 1

        -- If row is full OR last card → advance to next row
        if col > cardsPerRow then
            y = y - (rowHeight + spacingY)
            col = 1
        end
    end

    -- Adjust scrollChild height so the frame scrolls correctly
    scrollChild:SetHeight(math.abs(y) + rowHeight + 20)
end


--------------------------------------------------------
-- Detail View
--------------------------------------------------------
function ProfessionTrackerUI:ShowDetailView()
    self:ClearScrollChild()

    -- Clear existing content
    for _, child in pairs({self.scrollChild:GetChildren()}) do
        child:Hide()
        child:ClearAllPoints()
    end

    if not self.selectedCharacter then
        local selectText = self.scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        selectText:SetPoint("TOP", 0, -20)
        selectText:SetText("Select a character from the dashboard")
        return
    end

    -- ✅ Correct: get full data directly
    local charData = ProfessionTrackerDB.characters and ProfessionTrackerDB.characters[self.selectedCharacter]
    if not charData then
        local errorText = self.scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        errorText:SetPoint("TOP", 0, -20)
        errorText:SetText("Character data not found")
        return
    end

    -- Back button
    local backButton = CreateFrame("Button", nil, self.scrollChild, "UIPanelButtonTemplate")
    backButton:SetSize(100, 25)
    backButton:SetPoint("TOPLEFT", 10, -10)
    backButton:SetText("← Dashboard")
    backButton:SetScript("OnClick", function()
        self.viewMode = "dashboard"
        self:Refresh()
    end)

    -- Header
    local headerText = self.scrollChild:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    headerText:SetPoint("TOP", 0, -15)
    headerText:SetText(string.format("%s - %s", charData.name or "Unknown", charData.realm or ""))


    --------------------------------------------------------
    -- NEW: Gather all profession cards first
    --------------------------------------------------------
    local cards = {}
    local headers = {}
    local yOffset = -50

    if charData.professions then
        for profName, profData in pairs(charData.professions) do

            -- Create header label (stays above card)
            local profHeader = self.scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
            profHeader:SetTextColor(1, 0.8, 0)
            profHeader:SetText(profName or "Unknown Profession")
            profHeader:SetPoint("TOPLEFT", 20, yOffset)
            table.insert(headers, profHeader)

            -- Create card WITH NO POSITION (grid handles it)
            local card = CreateProfessionExpansionCard(self.scrollChild, profName, profData, 0)
            table.insert(cards, card)

            yOffset = yOffset - 40
        end
    end

    --------------------------------------------------------
    -- Apply new horizontal layout: 1 or 2 cards per row
    --------------------------------------------------------
    LayoutProfessionCards(self.scrollChild, cards)

    -- Update scroll height
    self.scrollChild:SetHeight(self.scrollChild:GetHeight() + 80)
    self.scrollFrame:SetVerticalScroll(0)


end



--------------------------------------------------------
-- Main Refresh Function
--------------------------------------------------------
function ProfessionTrackerUI:Refresh()
    -- Debug: Check if database exists
    if not ProfessionTrackerDB then
        print("|cffff0000[Profession Tracker]|r ProfessionTrackerDB is nil!")
        return
    end
    
    print("|cff00ff00[Profession Tracker]|r Refreshing UI in", self.viewMode, "mode")
    
    -- Update button states
    if self.viewMode == "dashboard" then
        self.dashboardButton:Disable()
        self.detailButton:Enable()
        self:ShowDashboard()
    else
        self.dashboardButton:Enable()
        self.detailButton:Disable()
        self:ShowDetailView()
    end
end

--------------------------------------------------------
-- Slash Command
--------------------------------------------------------
SLASH_PROFTRACKER1 = "/proftrack"
SLASH_PROFTRACKER2 = "/pt"
SlashCmdList["PROFTRACKER"] = function(msg)
    if msg == "debug" then
        -- Debug command to check database
        print("|cff00ff00[Profession Tracker]|r === DEBUG INFO ===")
        if not ProfessionTrackerDB then
            print("ProfessionTrackerDB is NIL!")
            return
        end
        local allChars = ProfessionTracker:GetAllCharacters()
        print("Database exists:", ProfessionTrackerDB ~= nil)
        print("Characters table:", allChars ~= nil)
        
        if allChars then
            local count = 0
            for charKey, charData in pairs(allChars) do
                if charKey ~= "version" and type(charData) == "table" then
                    count = count + 1
                    print(string.format("  Character %d: %s", count, charKey))
                    print(string.format("    Name: %s, Class: %s, Level: %s", 
                        tostring(charData.name), 
                        tostring(charData.class), 
                        tostring(charData.level)))
                    
                    if charData.professions then
                        print(string.format("    Professions: %d", #charData.professions))
                        for i, prof in pairs(charData.professions) do
                            print(string.format("      %d. %s", i, prof.name or "Unknown"))
                            if prof.expansions then
                                local expCount = 0
                                for expName, _ in pairs(prof.expansions) do
                                    expCount = expCount + 1
                                end
                                print(string.format("         Expansions: %d", expCount))
                            end
                        end
                    else
                        print("    No professions table")
                    end
                end
            end
            print(string.format("Total characters: %d", count))
        end
        print("|cff00ff00[Profession Tracker]|r === END DEBUG ===")
        
    elseif msg == "reload" then
        -- Force refresh
        print("|cff00ff00[Profession Tracker]|r Forcing UI refresh...")
        ProfessionTrackerUI.viewMode = "dashboard"
        ProfessionTrackerUI:Refresh()
        if not ProfessionTrackerUI:IsShown() then
            ProfessionTrackerUI:Show()
        end
        
    else
        -- Normal toggle
        if ProfessionTrackerUI:IsShown() then
            ProfessionTrackerUI:Hide()
        else
            ProfessionTrackerUI.viewMode = "dashboard"
            ProfessionTrackerUI:Refresh()
            ProfessionTrackerUI:Show()
        end
    end
end

--------------------------------------------------------
-- Register this UI with the core addon
--------------------------------------------------------
if ProfessionTracker and ProfessionTracker.RegisterUI then
    ProfessionTracker:RegisterUI(ProfessionTrackerUI)
end

print("|cff00ff00[Profession Tracker]|r UI loaded. Use /proftrack or /pt to open.")