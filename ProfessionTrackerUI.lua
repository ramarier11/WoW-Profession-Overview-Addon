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

local function CreateCharacterCard(parent, charKey, charData, yOffset)
    local card = CreateFrame("Frame", nil, parent)
    card:SetSize(460, 120)
    card:SetPoint("TOP", 0, yOffset)
    
    -- Background
    card.bg = card:CreateTexture(nil, "BACKGROUND")
    card.bg:SetAllPoints()
    card.bg:SetColorTexture(0.1, 0.1, 0.1, 0.5)
    
    -- Character Header (clickable for detail view)
    local header = CreateFrame("Button", nil, card)
    header:SetSize(460, 40)
    header:SetPoint("TOP", 0, 0)
    
    local nameText = header:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    nameText:SetPoint("TOPLEFT", 10, -10)
    nameText:SetText(string.format("%s - Lv%d %s", charData.name or "Unknown", charData.level or 0, charData.class or ""))
    
    local readyCount = 0
    local cooldownCount = 0
    
    -- Count ready/cooldown tasks (simplified for now)
    if charData.professions then
        for _, prof in pairs(charData.professions) do
            readyCount = readyCount + 1 -- Placeholder
            cooldownCount = cooldownCount + 1 -- Placeholder
        end
    end
    
    local statusText = header:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    statusText:SetPoint("TOPLEFT", nameText, "BOTTOMLEFT", 0, -5)
    statusText:SetTextColor(0, 1, 0)
    statusText:SetText(string.format("✓ %d Ready  ", readyCount))
    
    local cooldownText = header:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    cooldownText:SetPoint("LEFT", statusText, "RIGHT", 5, 0)
    cooldownText:SetTextColor(1, 0.5, 0)
    cooldownText:SetText(string.format("⏱ %d On Cooldown", cooldownCount))
    
    header:SetScript("OnClick", function()
        ProfessionTrackerUI.selectedCharacter = charKey
        ProfessionTrackerUI.viewMode = "detail"
        ProfessionTrackerUI:Refresh()
    end)
    
    -- Profession Info Section
    local profInfoFrame = CreateFrame("Frame", nil, card)
    profInfoFrame:SetSize(460, 80)
    profInfoFrame:SetPoint("TOP", 0, -40)
    
    local yPos = -5
    if charData.professions then
        local count = 0
        for profName, prof in pairs(charData.professions) do
            count = count + 1
            if count <= 2 then -- Show first 2 professions
                local profText = profInfoFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                profText:SetPoint("TOPLEFT", 10, yPos)
                profText:SetText(string.format("⚒ %s", prof.name or "Unknown"))
                
                -- Show expansion summary
                if prof.expansions then
                    local expCount = 0
                    local maxedCount = 0
                    for expName, expData in pairs(prof.expansions) do
                        expCount = expCount + 1
                        if expData.skillLevel == expData.maxSkillLevel then
                            maxedCount = maxedCount + 1
                        end
                    end
                    
                    local summaryText = profInfoFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                    summaryText:SetPoint("TOPLEFT", profText, "BOTTOMLEFT", 15, -3)
                    summaryText:SetTextColor(0.7, 0.7, 0.7)
                    summaryText:SetText(string.format("%d/%d expansions maxed", maxedCount, expCount))
                end
                
                yPos = yPos - 35
            end
        end
    end
    
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
    if expansionData.knowledgePoints or expansionData.maxKnowledgePoints then
        local knowledgeText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        knowledgeText:SetPoint("TOPLEFT", skillText, "BOTTOMLEFT", 0, -5)
        knowledgeText:SetTextColor(0.3, 0.7, 1)
        knowledgeText:SetText(string.format("Knowledge: %d / %d", 
            (expansionData.knowledgePoints or 0),
            (expansionData.maxKnowledgePoints or 0)
        ))
    
        local missing = expansionData.maxKnowledgePoints or 0
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
    
    if not ProfessionTrackerDB.characters then
        print("|cffff0000[Profession Tracker]|r No characters table found")
        local noDataText = self.scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        noDataText:SetPoint("TOP", 0, -20)
        noDataText:SetText("No character data found. Open your professions to scan.")
        return
    end
    
    -- Debug: Print character count
    local charCount = 0
    for charKey, charData in pairs(ProfessionTrackerDB.characters) do
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
    
    -- Create character cards
    for charKey, charData in pairs(ProfessionTrackerDB.characters) do
        if charKey ~= "version" and type(charData) == "table" then
            CreateCharacterCard(self.scrollChild, charKey, charData, yOffset)
            yOffset = yOffset - 130
        end
    end
    
    self.scrollChild:SetHeight(math.abs(yOffset))
    print("|cff00ff00[Profession Tracker]|r Created", charCount, "character cards")
end

--------------------------------------------------------
-- Detail View
--------------------------------------------------------
function ProfessionTrackerUI:ShowDetailView()
    -- Clear existing content
    for _, child in pairs({self.scrollChild:GetChildren()}) do
        child:Hide()
        child:SetParent(nil)
    end
    
    if not self.selectedCharacter then
        -- Show character selection if none selected
        local selectText = self.scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        selectText:SetPoint("TOP", 0, -20)
        selectText:SetText("Select a character from the dashboard")
        return
    end
    
    local charData = ProfessionTrackerDB.characters[self.selectedCharacter]
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
    
    -- Character header
    local headerText = self.scrollChild:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    headerText:SetPoint("TOP", 0, -15)
    headerText:SetText(string.format("%s - %s", charData.name or "Unknown", charData.realm or ""))
    
    local yOffset = -50
    
    -- Display each profession and its expansions
    if charData.professions then
        for profIndex, profData in pairs(charData.professions) do
            -- Profession header
            local profHeader = self.scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
            profHeader:SetPoint("TOPLEFT", 20, yOffset)
            profHeader:SetTextColor(1, 0.8, 0)
            profHeader:SetText(profData.name or "Unknown Profession")
            
            yOffset = yOffset - 30
            
            -- Display expansions
            if profData.expansions then
                for expName, expData in pairs(profData.expansions) do
                    CreateExpansionDisplay(self.scrollChild, profData, expName, expData, yOffset)
                    yOffset = yOffset - 130
                end
            end
            
            yOffset = yOffset - 20 -- Space between professions
        end
    else
        local noProfText = self.scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        noProfText:SetPoint("TOP", 0, -80)
        noProfText:SetText("No profession data available")
    end
    
    self.scrollChild:SetHeight(math.abs(yOffset))
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
        
        print("Database exists:", ProfessionTrackerDB ~= nil)
        print("Characters table:", ProfessionTrackerDB.characters ~= nil)
        
        if ProfessionTrackerDB.characters then
            local count = 0
            for charKey, charData in pairs(ProfessionTrackerDB.characters) do
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