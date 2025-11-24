-- ########################################################
-- ## Character Detail Window
-- ########################################################

-- Create the detail window frame
local CharacterDetailWindow = CreateFrame("Frame", "ProfessionTrackerCharacterDetail", UIParent, "BackdropTemplate")
CharacterDetailWindow:SetSize(400, 280)
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

-- Static content container (non-scrollable)
CharacterDetailWindow.Content = CreateFrame("Frame", nil, CharacterDetailWindow)
CharacterDetailWindow.Content:SetPoint("TOPLEFT", 20, -60)
CharacterDetailWindow.Content:SetPoint("BOTTOMRIGHT", -30, 20)
CharacterDetailWindow.Content:SetSize(540, 1)

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
    self:RefreshDisplay()
    self:Show()
end

-- Refresh the current character's display
function CharacterDetailWindow:RefreshDisplay()
    if not self.currentCharKey then return end
    
    -- Get fresh character data
    local characters = ProfessionTracker:GetAllCharacters()
    if not characters or not characters[self.currentCharKey] then
        return
    end
    
    local charData = characters[self.currentCharKey]
    
    -- Set title with class color
    local classColor = CLASS_COLORS[charData.class] or {1, 1, 1}
    self.Title:SetText(string.format("|cff%02x%02x%02x%s-%s|r",
        classColor[1] * 255,
        classColor[2] * 255,
        classColor[3] * 255,
        charData.name or "Unknown",
        charData.realm or "Unknown"))
    
    -- Clear existing content (frames and font strings)
    local children = {self.Content:GetChildren()}
    for _, child in ipairs(children) do
        child:Hide()
        child:ClearAllPoints()
        child:SetParent(nil)
    end
    
    -- Clear font strings
    local regions = {self.Content:GetRegions()}
    for _, region in ipairs(regions) do
        if region:GetObjectType() == "FontString" then
            region:Hide()
            region:SetText("")
            region:ClearAllPoints()
        end
    end
    
    -- Build detailed profession display (2-column layout)
    local yOffset = -10
    local leftColumnX = 10
    local rightColumnX = 200
    local currentColumn = 0
    local maxHeightInRow = 0
    local columnStartY = yOffset
    
    if charData.professions then
        -- Sort professions alphabetically for consistent layout
        local sortedProfs = {}
        for profName, profData in pairs(charData.professions) do
            table.insert(sortedProfs, {name = profName, data = profData})
        end
        table.sort(sortedProfs, function(a, b) return a.name < b.name end)
        
        for _, prof in ipairs(sortedProfs) do
            local profName = prof.name
            local profData = prof.data
            
            -- Determine column position
            local xOffset = (currentColumn == 0) and leftColumnX or rightColumnX
            local startY = yOffset
            
            -- Create profession header
            local profHeader = self.Content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
            profHeader:SetPoint("TOPLEFT", xOffset, yOffset)
            profHeader:SetText(profName)
            profHeader:SetTextColor(1, 0.82, 0, 1)
            yOffset = yOffset - 30
            
            if profData.expansions then
                -- Find only the most current expansion (highest ID)
                local mostCurrentExp = nil
                local highestExpID = 0
                
                for expName, expData in pairs(profData.expansions) do
                    if expData.id and expData.id >= 10 then -- Only knowledge system expansions
                        if expData.id > highestExpID then
                            highestExpID = expData.id
                            mostCurrentExp = {name = expName, data = expData}
                        end
                    end
                end
                
                -- Display only the most current expansion
                if mostCurrentExp then
                    yOffset = self:CreateExpansionSection(mostCurrentExp.name, mostCurrentExp.data, profName, yOffset, xOffset)
                end
            end
            
            -- Calculate height used by this profession
            local profHeight = math.abs(startY - yOffset)
            if profHeight > maxHeightInRow then
                maxHeightInRow = profHeight
            end
            
            -- Move to next column or next row
            currentColumn = currentColumn + 1
            if currentColumn >= 2 then
                -- Move to next row
                currentColumn = 0
                yOffset = columnStartY - maxHeightInRow - 20
                columnStartY = yOffset
                maxHeightInRow = 0
            else
                -- Reset to top of current row for next column
                yOffset = columnStartY
            end
        end
    end
    
    -- Update scroll child height
    -- No scroll height adjustment needed; content is fixed
    self.Content:SetHeight(math.abs(yOffset) + 50)
end

-- Refresh method to update with latest data
function CharacterDetailWindow:Refresh()
    if self:IsShown() and self.currentCharKey then
        self:RefreshDisplay()
    end
end

function CharacterDetailWindow:CreateExpansionSection(expName, expData, profName, yOffset, xOffset)
    local weekly = expData.weeklyKnowledgePoints or {}
    local isGathering = GATHERING_PROFESSIONS[profName]
    local isEnchanting = (profName == "Enchanting")
    
    xOffset = xOffset or 20 -- Default indent if not specified
    
    -- Get profession ID and expansion index for icon lookup
    local profID = expData.baseSkillLineID or expData.skillLineID
    local expIndex = expData.id
    
    -- Get icon references from KPReference table
    local treatiseIcon = "Interface\\Icons\\inv_misc_profession_book_enchanting"
    local craftingOrderIcon = "Interface\\Icons\\inv_crafting_orders"
    local treasuresIcon = "Interface\\Icons\\inv_misc_book_07"
    local gatherNodesIcon = "Interface\\Icons\\inv_magic_swirl_color2"
    
    if profID and expIndex and KPReference and KPReference[profID] and KPReference[profID][expIndex] then
        local ref = KPReference[profID][expIndex]
        
        -- Get treatise icon
        if ref.weekly and ref.weekly.treatise and ref.weekly.treatise.icon then
            treatiseIcon = ref.weekly.treatise.icon
        end
        
        -- Get crafting order icon
        if ref.weekly and ref.weekly.craftingOrder and ref.weekly.craftingOrder.icon then
            craftingOrderIcon = ref.weekly.craftingOrder.icon
        end
        
        -- Get treasures icon (use first treasure's icon if available)
        if ref.weekly and ref.weekly.treasures then
            if type(ref.weekly.treasures) == "table" and ref.weekly.treasures[1] and ref.weekly.treasures[1].icon then
                treasuresIcon = ref.weekly.treasures[1].icon
            elseif ref.weekly.treasures.icon then
                treasuresIcon = ref.weekly.treasures.icon
            end
        end
        
        -- Get gather nodes icon (use first node's icon if available)
        if ref.weekly and ref.weekly.gatherNodes then
            if type(ref.weekly.gatherNodes) == "table" and ref.weekly.gatherNodes[1] and ref.weekly.gatherNodes[1].icon then
                gatherNodesIcon = ref.weekly.gatherNodes[1].icon
            end
        end
    end
    
    -- Expansion name (smaller)
    local expHeader = self.Content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    expHeader:SetPoint("TOPLEFT", xOffset, yOffset)
    expHeader:SetText(expName)
    expHeader:SetTextColor(0.7, 0.7, 0.8, 1)
    yOffset = yOffset - 16
    
    -- Skill level (condensed)
    local skillText = self.Content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    skillText:SetPoint("TOPLEFT", xOffset + 10, yOffset)
    skillText:SetText(string.format("Skill: %d/%d", 
        expData.skillLevel or 0,
        expData.maxSkillLevel or 0))
    yOffset = yOffset - 14
    
    -- Knowledge points (condensed)
    if expData.pointsUntilMaxKnowledge then
        local kpText = self.Content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        kpText:SetPoint("TOPLEFT", xOffset + 10, yOffset)
        local kpRemaining = math.max(0, expData.pointsUntilMaxKnowledge)
        kpText:SetText(string.format("KP: %d", kpRemaining))
        if kpRemaining == 0 then
            kpText:SetTextColor(0, 1, 0, 1)
        end
        yOffset = yOffset - 14
    end
    
    -- Concentration (condensed, exclude for gathering)
    if not isGathering and expData.concentration then
        local currentConc, maxConc = GetCurrentConcentration(expData)
        local concPct = (currentConc / maxConc) * 100
        
        local concText = self.Content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        concText:SetPoint("TOPLEFT", xOffset + 10, yOffset)
        concText:SetText(string.format("Conc: %d/%d", currentConc, maxConc))
        
        if concPct >= 75 then
            concText:SetTextColor(0, 1, 0, 1)
        elseif concPct >= 50 then
            concText:SetTextColor(1, 1, 0, 1)
        elseif concPct >= 25 then
            concText:SetTextColor(1, 0.53, 0, 1)
        else
            concText:SetTextColor(1, 0, 0, 1)
        end
        yOffset = yOffset - 14
    end
    
    yOffset = yOffset - 3
    
    -- Helper for status display with icons
    local function CreateStatusLine(icon, label, completed, isAtlas)
        local statusText = self.Content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        statusText:SetPoint("TOPLEFT", xOffset + 10, yOffset)
        
        local statusIcon = completed 
            and "|TInterface\\RaidFrame\\ReadyCheck-Ready:12:12|t" 
            or "|TInterface\\RaidFrame\\ReadyCheck-NotReady:12:12|t"
        
        -- Handle atlas textures differently from regular textures
        local iconDisplay
        if isAtlas then
            iconDisplay = icon  -- Already formatted with |A:...|a
        else
            iconDisplay = string.format("|T%s:14:14|t", icon)
        end
        
        statusText:SetText(string.format("%s %s %s", iconDisplay, label, statusIcon))
        yOffset = yOffset - 16
        return statusText
    end
    
    -- Crafting Order
    local isCraftingOrderAtlas = (craftingOrderIcon == "Interface\\Icons\\inv_crafting_orders")
    if isCraftingOrderAtlas then
        craftingOrderIcon = "|A:RecurringAvailableQuestIcon:14:14|a"
    end
    CreateStatusLine(craftingOrderIcon, "Order", weekly.craftingOrderQuest == true, isCraftingOrderAtlas)
    
    -- Treatise
    CreateStatusLine(treatiseIcon, "Treatise", weekly.treatise == true, false)
    
    -- Treasures (exclude for gathering)
    if not isGathering then
        CreateStatusLine(treasuresIcon, "Treasures", weekly.treasuresAllComplete == true, false)
    end
    
    -- Gather Nodes
    if isGathering or isEnchanting then
        CreateStatusLine(gatherNodesIcon, "Nodes", weekly.gatherNodesAllComplete == true, false)
    end
    
    -- One-time treasures section (condensed)
    if expData.missingOneTimeTreasures and #expData.missingOneTimeTreasures > 0 then
        yOffset = yOffset - 3
        local treasureText = self.Content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        treasureText:SetPoint("TOPLEFT", xOffset + 10, yOffset)
        treasureText:SetText(string.format("|cffff8800Missing: %d|r", 
            #expData.missingOneTimeTreasures))
        yOffset = yOffset - 16
        
        -- Create smaller button
        local showTreasuresBtn = CreateFrame("Button", nil, self.Content, "UIPanelButtonTemplate")
        showTreasuresBtn:SetSize(100, 20)
        showTreasuresBtn:SetPoint("TOPLEFT", xOffset + 10, yOffset)
        showTreasuresBtn:SetText("Show")
        showTreasuresBtn:SetScript("OnClick", function()
            self:ShowMissingTreasures(profName, expName, expData)
        end)
        yOffset = yOffset - 25
    elseif expData.oneTimeCollectedAll then
        yOffset = yOffset - 3
        local completeText = self.Content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        completeText:SetPoint("TOPLEFT", xOffset + 10, yOffset)
        completeText:SetText("|TInterface\\RaidFrame\\ReadyCheck-Ready:12:12|t All Collected")
        completeText:SetTextColor(0, 1, 0, 1)
        yOffset = yOffset - 16
    end
    
    yOffset = yOffset - 5
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