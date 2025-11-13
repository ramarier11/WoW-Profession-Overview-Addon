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

-- ########################################################
-- ## Expansion Carousel for Detail View
-- ########################################################
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

    -- Build a sortable list of expansions using per-character expData.id (fallback to 0)
    local expansionsList = {}
    for expName, expData in pairs(profData.expansions or {}) do
        local id = expData and expData.id or 0
        table.insert(expansionsList, { name = expName, id = id, data = expData })
    end

    -- If id wasn't saved for some reason, try to prefer ones with any skillLevel > 0
    if #expansionsList == 0 then
        -- no expansion data
    end

    -- Sort descending by id (newest first). If ids are equal, put expansions with higher skillLevel first
    table.sort(expansionsList, function(a, b)
        if (a.id or 0) ~= (b.id or 0) then
            return (a.id or 0) > (b.id or 0)
        end
        local aSkill = (a.data and a.data.skillLevel) or 0
        local bSkill = (b.data and b.data.skillLevel) or 0
        return aSkill > bSkill
    end)

    -- Extract ordered names for the carousel logic
    local expansionNames = {}
    for _, item in ipairs(expansionsList) do
        table.insert(expansionNames, item.name)
    end

    local currentIndex = 1

    ----------------------------------------------------
    -- Profession Name
    ----------------------------------------------------
    local profTitle = card:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    profTitle:SetPoint("TOP", 0, -10)
    profTitle:SetText(profName)

    ----------------------------------------------------
    -- Expansion Header + Arrows
    ----------------------------------------------------
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

    ----------------------------------------------------
    -- Skill / Knowledge Info
    ----------------------------------------------------
    local skillText = card:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    skillText:SetPoint("TOP", expansionLabel, "BOTTOM", 0, -10)

    local knowledgeText = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    knowledgeText:SetPoint("TOP", skillText, "BOTTOM", 0, -5)

    ----------------------------------------------------
    -- Update Display
    ----------------------------------------------------
    local function UpdateDisplay()
        if #expansionNames == 0 then
            expansionLabel:SetText("No expansion data")
            skillText:SetText("")
            knowledgeText:SetText("")
            return
        end

        local expName = expansionNames[currentIndex]
        local expData = profData.expansions and profData.expansions[expName]
        if not expData then
            expansionLabel:SetText(expName or "Unknown")
            skillText:SetText("Skill: 0 / 0")
            knowledgeText:SetText("")
            return
        end

        expansionLabel:SetText(expName)
        skillText:SetText(string.format("Skill: %d / %d",
            expData.skillLevel or 0, expData.maxSkillLevel or 0))

        if expData.pointsUntilMaxKnowledge ~= nil then
            knowledgeText:SetText(string.format("Knowledge Points: %d remaining", expData.pointsUntilMaxKnowledge))
            knowledgeText:Show()
        else
            knowledgeText:Hide()
        end
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

--------------------------------------------------------
-- Concentration Calculation Helpers
--------------------------------------------------------
local CONCENTRATION_REGEN_RATE = 10.41667 -- 250 per 24 hours = 10.41667 per hour

local function CalculateCurrentConcentration(lastConcentration, lastUpdated, maxConcentration)
    if not lastConcentration or not lastUpdated then
        return lastConcentration or 0
    end
    
    maxConcentration = maxConcentration or 1000
    
    -- If already at max, no need to calculate
    if lastConcentration >= maxConcentration then
        return maxConcentration
    end
    
    local currentTime = time()
    local timeElapsed = currentTime - lastUpdated
    local hoursElapsed = timeElapsed / 3600
    local concentrationGained = hoursElapsed * CONCENTRATION_REGEN_RATE
    
    local currentConcentration = lastConcentration + concentrationGained
    
    -- Cap at max
    if currentConcentration > maxConcentration then
        return maxConcentration
    end
    
    return math.floor(currentConcentration)
end

local function FormatTimeUntilMax(currentConcentration, maxConcentration)
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
--------------------------------------------------------
local function AddProfessionObjectives(parentFrame, profName, profData, yOffset)
    local container = CreateFrame("Frame", nil, parentFrame)
    container:SetSize(440, 80)
    container:SetPoint("TOPLEFT", 10, yOffset)

    -- Find the most recent expansion (highest ID)
    local latestExp, latestData
    for expName, expData in pairs(profData.expansions or {}) do
        if not latestData or (expData.id or 0) > (latestData.id or 0) then
            latestExp, latestData = expName, expData
        end
    end

    ----------------------------------------------------
    -- Profession Name + Checkmark if Maxed
    ----------------------------------------------------
    local profText = container:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    profText:SetPoint("TOPLEFT", 0, 0)

    local isMaxed = latestData and latestData.skillLevel == latestData.maxSkillLevel
    local checkTexture = isMaxed
        and "|TInterface\\RaidFrame\\ReadyCheck-Ready:16:16|t"
        or "|TInterface\\RaidFrame\\ReadyCheck-NotReady:16:16|t"

    profText:SetText(string.format("%s %s", checkTexture, profName))


    ----------------------------------------------------
    -- Weekly Knowledge Checkboxes (Placeholders)
    ----------------------------------------------------
    local checkboxFrame = CreateFrame("Frame", nil, container)
    checkboxFrame:SetSize(300, 20)
    checkboxFrame:SetPoint("TOPLEFT", profText, "BOTTOMLEFT", 15, -3)

    local objectives = {
        { key = "quest", label = "KP Quest" },
        { key = "treasures", label = "KP Treasures" },
        { key = "treatise", label = "KP Treatise" },
    }

    local xOffset = 0
    for _, obj in ipairs(objectives) do
        local cb = CreateFrame("CheckButton", nil, checkboxFrame, "ChatConfigCheckButtonTemplate")
        cb:SetPoint("LEFT", xOffset, 0)
        cb:SetChecked(false) -- placeholder
        cb.Text:SetText(obj.label)
        xOffset = xOffset + 100
    end

    ----------------------------------------------------
    -- Concentration Display
    ----------------------------------------------------
    local concText = container:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    concText:SetPoint("TOPLEFT", checkboxFrame, "BOTTOMLEFT", 0, -5)

    -- Get actual concentration value from latest expansion data
    local concValue = 0
    local maxConc = 1000
    local timeRemaining = ""
    
    if latestData and latestData.concentration then
        -- Calculate current concentration with regeneration
        concValue = ProfessionTracker:GetCurrentConcentration(
            latestData.concentration,
            latestData.concentrationLastUpdated,
            latestData.maxConcentration
        )
        maxConc = latestData.maxConcentration or 1000
        
        -- Get time until max if not already at max
        if concValue < maxConc then
            timeRemaining = " - Full in: " .. ProfessionTracker:GetTimeUntilMax(concValue, maxConc)
        end
    end
    
    -- Color coding based on percentage
    local concPercent = (concValue / maxConc) * 100
    local color = {1, 0, 0} -- default red
    if concPercent >= 75 then 
        color = {0, 1, 0}      -- green
    elseif concPercent >= 40 then 
        color = {1, 0.8, 0}    -- yellow
    end

    concText:SetTextColor(unpack(color))
    concText:SetText(string.format("Concentration: %d / %d (%.0f%%)%s", concValue, maxConc, concPercent, timeRemaining))

    -- Return the container height so parent can calculate properly
    return container, 45
end

--------------------------------------------------------
-- Updated: CreateCharacterCard (Dynamic Height + Objectives)
--------------------------------------------------------

local function CreateCharacterCard(parent, charKey, charData, yOffset)
    local card = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    card:SetPoint("TOP", 0, yOffset)
    card:SetWidth(460)
    
    -- Background
    card.bg = card:CreateTexture(nil, "BACKGROUND")
    card.bg:SetAllPoints()
    card.bg:SetColorTexture(0.1, 0.1, 0.1, 0.5)

    ----------------------------------------------------
    -- Character Header
    ----------------------------------------------------
    local header = CreateFrame("Button", nil, card)
    header:SetSize(460, 40)
    header:SetPoint("TOP", 0, 0)
    
    local nameText = header:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    nameText:SetPoint("TOPLEFT", 10, -10)
    nameText:SetText(string.format("%s - Lv%d %s",
        charData.name or "Unknown",
        charData.level or 0,
        charData.class or ""))

    -- Placeholder for task counts (optional)
    local statusText = header:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    statusText:SetPoint("TOPLEFT", nameText, "BOTTOMLEFT", 0, -5)
    statusText:SetTextColor(0, 1, 0)
    statusText:SetText("Professions:")

    -- Click header to open detail view
    header:SetScript("OnClick", function()
        ProfessionTrackerUI.selectedCharacter = charKey
        ProfessionTrackerUI.viewMode = "detail"
        ProfessionTrackerUI:Refresh()
    end)

    ----------------------------------------------------
    -- Profession Info Section (Dynamic Height)
    ----------------------------------------------------
    local profInfoFrame = CreateFrame("Frame", nil, card)
    profInfoFrame:SetWidth(440)
    profInfoFrame:SetPoint("TOP", 0, -50)

    local yPos = 0
    local profCount = 0

    if charData.professions then
        for profName, profData in pairs(charData.professions) do
            profCount = profCount + 1
            if profCount <= 2 then -- Show first 2 professions
                local _, profHeight = AddProfessionObjectives(profInfoFrame, profName, profData, yPos)
                yPos = yPos - profHeight - 15 -- Add spacing between professions
            end
        end
    else
        local noProfText = profInfoFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        noProfText:SetPoint("TOPLEFT", 10, yPos)
        noProfText:SetText("No profession data found.")
        yPos = yPos - 20
    end

    ----------------------------------------------------
    -- Adjust Card + Prof Frame Height
    ----------------------------------------------------
    local profFrameHeight = math.abs(yPos)
    profInfoFrame:SetHeight(profFrameHeight)
    
    -- Total card height = header (50) + profession content + bottom padding (20)
    local totalHeight = 50 + profFrameHeight + 10
    card:SetHeight(totalHeight)

    return card
end





local function CreateExpansionDisplay(parent, profData, expansionName, expansionData, yOffset)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetSize(440, 120)
    frame:SetPoint("TOP", 0, yOffset)
    
    -- Background
    frame.bg = frame:CreateTexture(nil, "BACKGROUND")
    frame.bg:SetAllPoints()
    frame.bg:SetColorTexture(0.15, 0.15, 0.15, 0.5)
    
    -- Expansion Name
    local titleText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    titleText:SetPoint("TOPLEFT", 10, -10)
    titleText:SetText(expansionName)
    
    -- Skill Level
    local skillText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    skillText:SetPoint("TOPLEFT", titleText, "BOTTOMLEFT", 0, -5)
    
    local skillColor = (expansionData.skillLevel == expansionData.maxSkillLevel) and {0, 1, 0} or {1, 0.5, 0}
    skillText:SetTextColor(unpack(skillColor))
    skillText:SetText(string.format("Skill: %d / %d", expansionData.skillLevel or 0, expansionData.maxSkillLevel or 0))
    
    -- Knowledge Points (if exists)
    if expansionData.knowledgePoints or expansionData.pointsUntilMaxKnowledge then
        local knowledgeText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        knowledgeText:SetPoint("TOPLEFT", skillText, "BOTTOMLEFT", 0, -5)
        knowledgeText:SetTextColor(0.3, 0.7, 1)
        -- knowledgeText:SetText(string.format("Knowledge: %d, 
        --     (expansionData.knowledgePoints or 0)
        --))
    
        local missing = expansionData.pointsUntilMaxKnowledge or 0
        if missing > 0 then
            local missingText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            missingText:SetPoint("TOPLEFT", knowledgeText, "BOTTOMLEFT", 0, -3)
            missingText:SetTextColor(1, 0.2, 0.2)
            missingText:SetText(string.format("📚 %d KP remaining to collect", missing))
        end
    end
    
    
    return frame
end

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

    local yOffset = -50

    -- Professions
    if charData.professions then
        for profName, profData in pairs(charData.professions) do
            local profHeader = self.scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
            profHeader:SetPoint("TOPLEFT", 20, yOffset)
            profHeader:SetTextColor(1, 0.8, 0)
            profHeader:SetText(profName or "Unknown Profession")
            yOffset = yOffset - 30

            if profData.expansions then
                -- Convert expansions table into a sortable list
                local expansionsList = {}
                for expName, expData in pairs(profData.expansions) do
                    table.insert(expansionsList, { name = expName, data = expData })
                end

                -- Sort in descending order by expansion ID (higher = newer)
                table.sort(expansionsList, function(a, b)
                    return (a.data.id or 0) > (b.data.id or 0)
                end)

                local card = CreateProfessionExpansionCard(self.scrollChild, profName, profData, yOffset)
                yOffset = yOffset - 170

            end


            yOffset = yOffset - 20
        end
    else
        local noProfText = self.scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        noProfText:SetPoint("TOP", 0, -80)
        noProfText:SetText("No profession data available")
    end

    self.scrollChild:SetHeight(math.abs(yOffset))
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