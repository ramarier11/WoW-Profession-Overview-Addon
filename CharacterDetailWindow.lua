-- ########################################################
-- ## Character Detail Window
-- ########################################################

-- Create the detail window frame
local CharacterDetailWindow = CreateFrame("Frame", "ProfessionTrackerCharacterDetail", UIParent, "BackdropTemplate")
CharacterDetailWindow:SetSize(700, 500)
CharacterDetailWindow:SetPoint("CENTER")
CharacterDetailWindow:Hide()
CharacterDetailWindow:SetFrameStrata("DIALOG")
CharacterDetailWindow:SetMovable(true)
CharacterDetailWindow:EnableMouse(true)
CharacterDetailWindow:RegisterForDrag("LeftButton")
CharacterDetailWindow:SetScript("OnDragStart", function(self) self:StartMoving() end)
CharacterDetailWindow:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

-- Apply backdrop
local DETAIL_BACKDROP = {
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 32,
    edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
}
CharacterDetailWindow:SetBackdrop(DETAIL_BACKDROP)
CharacterDetailWindow:SetBackdropColor(0, 0, 0, 0.9)
CharacterDetailWindow:SetBackdropBorderColor(0.6, 0.6, 0.6, 1)

-- Title
CharacterDetailWindow.Title = CharacterDetailWindow:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
CharacterDetailWindow.Title:SetPoint("TOP", 0, -20)

-- Close Button
CharacterDetailWindow.CloseButton = CreateFrame("Button", nil, CharacterDetailWindow, "UIPanelCloseButton")
CharacterDetailWindow.CloseButton:SetPoint("TOPRIGHT", -5, -5)

-- Scroll Frame
CharacterDetailWindow.ScrollFrame = CreateFrame("ScrollFrame", nil, CharacterDetailWindow, "UIPanelScrollFrameTemplate")
CharacterDetailWindow.ScrollFrame:SetPoint("TOPLEFT", 20, -60)
CharacterDetailWindow.ScrollFrame:SetPoint("BOTTOMRIGHT", -30, 20)

CharacterDetailWindow.ScrollChild = CreateFrame("Frame", nil, CharacterDetailWindow.ScrollFrame)
CharacterDetailWindow.ScrollChild:SetSize(640, 1)
CharacterDetailWindow.ScrollFrame:SetScrollChild(CharacterDetailWindow.ScrollChild)

-- Store reference to current character
CharacterDetailWindow.currentCharKey = nil

-- Class colors
local CLASS_COLORS = {
    WARRIOR = {0.78, 0.61, 0.43},
    PALADIN = {0.96, 0.55, 0.73},
    HUNTER = {0.67, 0.83, 0.45},
    ROGUE = {1.00, 0.96, 0.41},
    PRIEST = {1.00, 1.00, 1.00},
    DEATHKNIGHT = {0.77, 0.12, 0.23},
    SHAMAN = {0.00, 0.44, 0.87},
    MAGE = {0.25, 0.78, 0.92},
    WARLOCK = {0.53, 0.53, 0.93},
    MONK = {0.00, 1.00, 0.59},
    DRUID = {1.00, 0.49, 0.04},
    DEMONHUNTER = {0.64, 0.19, 0.79},
    EVOKER = {0.20, 0.58, 0.50},
}

local GATHERING_PROFESSIONS = {
    ["Herbalism"] = true,
    ["Mining"] = true,
    ["Skinning"] = true,
}

-- Helper to get current concentration with regen
local function GetCurrentConcentration(expData)
    if not expData.concentration or not expData.concentrationLastUpdated then
        return expData.concentration, expData.maxConcentration
    end
    
    local savedConc = expData.concentration
    local maxConc = expData.maxConcentration or 1000
    
    if savedConc >= maxConc then
        return maxConc, maxConc
    end
    
    local currentTime = time()
    local elapsedSeconds = currentTime - expData.concentrationLastUpdated
    local elapsedHours = elapsedSeconds / 3600
    local regenAmount = elapsedHours * 10
    local currentConc = math.min(savedConc + regenAmount, maxConc)
    
    return math.floor(currentConc), maxConc
end

-- Show character details
function CharacterDetailWindow:ShowCharacter(charKey, charData)
    self.currentCharKey = charKey
    
    -- Set title with class color
    local classColor = CLASS_COLORS[charData.class] or {1, 1, 1}
    self.Title:SetText(string.format("|cff%02x%02x%02x%s-%s|r",
        classColor[1] * 255,
        classColor[2] * 255,
        classColor[3] * 255,
        charData.name or "Unknown",
        charData.realm or "Unknown"))
    
    -- Clear existing content
    for _, child in ipairs({self.ScrollChild:GetChildren()}) do
        child:Hide()
        child:SetParent(nil)
    end
    
    -- Build detailed profession display
    local yOffset = -10
    
    if charData.professions then
        for profName, profData in pairs(charData.professions) do
            -- Create profession header
            local profHeader = self.ScrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
            profHeader:SetPoint("TOPLEFT", 10, yOffset)
            profHeader:SetText(profName)
            profHeader:SetTextColor(1, 0.82, 0, 1)
            yOffset = yOffset - 30
            
            if profData.expansions then
                -- Sort expansions by ID (most recent first)
                local sortedExps = {}
                for expName, expData in pairs(profData.expansions) do
                    if expData.id and expData.id >= 10 then
                        table.insert(sortedExps, {name = expName, data = expData})
                    end
                end
                table.sort(sortedExps, function(a, b) return a.data.id > b.data.id end)
                
                -- Display each expansion
                for _, exp in ipairs(sortedExps) do
                    yOffset = self:CreateExpansionSection(exp.name, exp.data, profName, yOffset)
                end
            end
            
            yOffset = yOffset - 20 -- Space between professions
        end
    end
    
    -- Update scroll child height
    self.ScrollChild:SetHeight(math.abs(yOffset) + 50)
    
    self:Show()
end

function CharacterDetailWindow:CreateExpansionSection(expName, expData, profName, yOffset)
    local weekly = expData.weeklyKnowledgePoints or {}
    local isGathering = GATHERING_PROFESSIONS[profName]
    local isEnchanting = (profName == "Enchanting")
    
    -- Expansion name
    local expHeader = self.ScrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    expHeader:SetPoint("TOPLEFT", 20, yOffset)
    expHeader:SetText(expName)
    expHeader:SetTextColor(0.8, 0.8, 1, 1)
    yOffset = yOffset - 20
    
    -- Skill level
    local skillText = self.ScrollChild:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    skillText:SetPoint("TOPLEFT", 30, yOffset)
    skillText:SetText(string.format("Skill: %d / %d", 
        expData.skillLevel or 0,
        expData.maxSkillLevel or 0))
    yOffset = yOffset - 18
    
    -- Knowledge points
    if expData.pointsUntilMaxKnowledge then
        local kpText = self.ScrollChild:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        kpText:SetPoint("TOPLEFT", 30, yOffset)
        kpText:SetText(string.format("Knowledge Remaining: %d", expData.pointsUntilMaxKnowledge))
        if expData.pointsUntilMaxKnowledge == 0 then
            kpText:SetTextColor(0, 1, 0, 1)
        end
        yOffset = yOffset - 18
    end
    
    -- Concentration (exclude for gathering)
    if not isGathering and expData.concentration then
        local currentConc, maxConc = GetCurrentConcentration(expData)
        local concPct = (currentConc / maxConc) * 100
        
        local concText = self.ScrollChild:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        concText:SetPoint("TOPLEFT", 30, yOffset)
        concText:SetText(string.format("Concentration: %d / %d (%.0f%%)", 
            currentConc, maxConc, concPct))
        
        if concPct >= 75 then
            concText:SetTextColor(0, 1, 0, 1)
        elseif concPct >= 50 then
            concText:SetTextColor(1, 1, 0, 1)
        elseif concPct >= 25 then
            concText:SetTextColor(1, 0.53, 0, 1)
        else
            concText:SetTextColor(1, 0, 0, 1)
        end
        yOffset = yOffset - 18
    end
    
    -- Weekly activities header
    local weeklyHeader = self.ScrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    weeklyHeader:SetPoint("TOPLEFT", 30, yOffset)
    weeklyHeader:SetText("Weekly Activities:")
    yOffset = yOffset - 20
    
    -- Helper for status display
    local function CreateStatusLine(label, completed, indent)
        indent = indent or 40
        local statusText = self.ScrollChild:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        statusText:SetPoint("TOPLEFT", indent, yOffset)
        
        local icon = completed 
            and "|TInterface\\RaidFrame\\ReadyCheck-Ready:14:14|t" 
            or "|TInterface\\RaidFrame\\ReadyCheck-NotReady:14:14|t"
        
        statusText:SetText(string.format("%s %s", icon, label))
        yOffset = yOffset - 18
        return statusText
    end
    
    -- Treatise
    CreateStatusLine("Treatise", weekly.treatise == true)
    
    -- Crafting Order
    CreateStatusLine("Crafting Order", weekly.craftingOrderQuest == true)
    
    -- Treasures (detailed breakdown, exclude for gathering)
    if not isGathering then
        if weekly.treasures and type(weekly.treasures) == "table" then
            CreateStatusLine("Treasures:", weekly.treasuresAllComplete == true)
            for i, treasure in ipairs(weekly.treasures) do
                CreateStatusLine(treasure.label or ("Treasure " .. i), treasure.completed, 50)
            end
        else
            CreateStatusLine("Treasures", weekly.treasuresAllComplete == true)
        end
    end
    
    -- Gather Nodes (detailed breakdown)
    if isGathering or isEnchanting then
        if weekly.gatherNodes and type(weekly.gatherNodes) == "table" then
            CreateStatusLine("Gather Nodes:", weekly.gatherNodesAllComplete == true)
            for i, node in ipairs(weekly.gatherNodes) do
                CreateStatusLine(
                    string.format("%s (%d)", node.name or ("Node " .. i), node.count or 0),
                    node.completed,
                    50
                )
            end
        else
            CreateStatusLine("Gather Nodes", weekly.gatherNodesAllComplete == true)
        end
    end
    
    -- One-time treasures section
    if expData.missingOneTimeTreasures and #expData.missingOneTimeTreasures > 0 then
        yOffset = yOffset - 5
        local treasureHeader = self.ScrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        treasureHeader:SetPoint("TOPLEFT", 30, yOffset)
        treasureHeader:SetText(string.format("Missing One-Time Treasures: %d", 
            #expData.missingOneTimeTreasures))
        treasureHeader:SetTextColor(1, 0.5, 0, 1)
        yOffset = yOffset - 20
        
        -- Create clickable button to show treasure locations
        local showTreasuresBtn = CreateFrame("Button", nil, self.ScrollChild, "UIPanelButtonTemplate")
        showTreasuresBtn:SetSize(150, 25)
        showTreasuresBtn:SetPoint("TOPLEFT", 40, yOffset)
        showTreasuresBtn:SetText("Show Locations")
        showTreasuresBtn:SetScript("OnClick", function()
            self:ShowMissingTreasures(profName, expName, expData)
        end)
        yOffset = yOffset - 30
    elseif expData.oneTimeCollectedAll then
        yOffset = yOffset - 5
        local completeText = self.ScrollChild:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        completeText:SetPoint("TOPLEFT", 30, yOffset)
        completeText:SetText("|TInterface\\RaidFrame\\ReadyCheck-Ready:14:14|t All One-Time Treasures Collected")
        completeText:SetTextColor(0, 1, 0, 1)
        yOffset = yOffset - 20
    end
    
    yOffset = yOffset - 10
    return yOffset
end

-- Show missing treasures window
function CharacterDetailWindow:ShowMissingTreasures(profName, expName, expData)
    if not expData.missingOneTimeTreasures or #expData.missingOneTimeTreasures == 0 then
        return
    end
    
    -- Create or reuse treasure window
    if not self.missingTreasureWindow then
        local treasureWin = CreateFrame("Frame", "ProfessionTrackerMissingTreasures", UIParent, "BackdropTemplate")
        treasureWin:SetSize(500, 400)
        treasureWin:SetPoint("CENTER")
        treasureWin:SetFrameStrata("TOOLTIP")
        treasureWin:SetMovable(true)
        treasureWin:EnableMouse(true)
        treasureWin:RegisterForDrag("LeftButton")
        treasureWin:SetScript("OnDragStart", function(self) self:StartMoving() end)
        treasureWin:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
        
        treasureWin:SetBackdrop(DETAIL_BACKDROP)
        treasureWin:SetBackdropColor(0, 0, 0, 0.95)
        treasureWin:SetBackdropBorderColor(0.8, 0.6, 0, 1)
        
        treasureWin.Title = treasureWin:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        treasureWin.Title:SetPoint("TOP", 0, -15)
        
        treasureWin.CloseButton = CreateFrame("Button", nil, treasureWin, "UIPanelCloseButton")
        treasureWin.CloseButton:SetPoint("TOPRIGHT", -5, -5)
        
        treasureWin.ScrollFrame = CreateFrame("ScrollFrame", nil, treasureWin, "UIPanelScrollFrameTemplate")
        treasureWin.ScrollFrame:SetPoint("TOPLEFT", 15, -45)
        treasureWin.ScrollFrame:SetPoint("BOTTOMRIGHT", -30, 15)
        
        treasureWin.ScrollChild = CreateFrame("Frame", nil, treasureWin.ScrollFrame)
        treasureWin.ScrollChild:SetSize(450, 1)
        treasureWin.ScrollFrame:SetScrollChild(treasureWin.ScrollChild)
        
        self.missingTreasureWindow = treasureWin
    end
    
    local treasureWin = self.missingTreasureWindow
    treasureWin.Title:SetText(string.format("Missing Treasures - %s (%s)", profName, expName))
    
    -- Clear existing content
    for _, child in ipairs({treasureWin.ScrollChild:GetChildren()}) do
        child:Hide()
        child:SetParent(nil)
    end
    
    local yOffset = -10
    
    for i, treasure in ipairs(expData.missingOneTimeTreasures) do
        -- Treasure name
        local nameText = treasureWin.ScrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        nameText:SetPoint("TOPLEFT", 10, yOffset)
        nameText:SetText(treasure.name)
        nameText:SetTextColor(1, 0.82, 0, 1)
        yOffset = yOffset - 18
        
        -- Location info
        local locText = treasureWin.ScrollChild:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        locText:SetPoint("TOPLEFT", 20, yOffset)
        locText:SetText(string.format("Map ID: %d, Coords: %.1f, %.1f", 
            treasure.mapID or 0,
            treasure.x or 0,
            treasure.y or 0))
        yOffset = yOffset - 18
        
        -- Quest ID (for reference)
        local questText = treasureWin.ScrollChild:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        questText:SetPoint("TOPLEFT", 20, yOffset)
        questText:SetText(string.format("Quest ID: %d", treasure.questID or 0))
        questText:SetTextColor(0.7, 0.7, 0.7, 1)
        yOffset = yOffset - 20
    end
    
    treasureWin.ScrollChild:SetHeight(math.abs(yOffset) + 20)
    treasureWin:Show()
end

-- Make globally accessible
ProfessionTrackerUI = ProfessionTrackerUI or {}
ProfessionTrackerUI.CharacterDetailWindow = CharacterDetailWindow

print("|cff00ff00[Profession Tracker]|r Character detail window loaded.")