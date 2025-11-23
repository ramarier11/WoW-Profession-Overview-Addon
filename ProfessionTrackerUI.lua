-- ########################################################
-- ## Profession Tracker: UI Handler (XML-Based)        ##
-- ########################################################

local GATHERING_PROFESSIONS = {
    ["Herbalism"] = true,
    ["Mining"] = true,
    ["Skinning"] = true,
}

local ENCHANTING_ID = 333

-- Class color table
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

-- Backdrop templates
local DASHBOARD_BACKDROP = {
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 32,
    edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
}

local ENTRY_BACKDROP = {
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
}

-- Pool for reusable frames
local CharacterEntryPool = {}
local ProfessionProgressPool = {}

-- ========================================================
-- Pool Management
-- ========================================================

local function AcquireCharacterEntry()
    local frame = table.remove(CharacterEntryPool)
    if not frame then
        frame = CreateFrame("Frame", nil, ProfessionTrackerDashboard.ScrollFrame.ScrollChild, "CharacterEntryTemplate")
        frame.professionFrames = {}
        
        -- Apply backdrop using modern API
        frame:SetBackdrop(ENTRY_BACKDROP)
        frame:SetBackdropColor(0.1, 0.1, 0.1, 0.9)
        frame:SetBackdropBorderColor(0.6, 0.6, 0.6, 1)
    end
    frame:Show()
    return frame
end

local function ReleaseCharacterEntry(frame)
    frame:Hide()
    frame:ClearAllPoints()
    
    -- Release profession frames
    for _, profFrame in ipairs(frame.professionFrames) do
        ReleaseProfessionProgress(profFrame)
    end
    wipe(frame.professionFrames)
    
    table.insert(CharacterEntryPool, frame)
end

local function AcquireProfessionProgress()
    local frame = table.remove(ProfessionProgressPool)
    if not frame then
        frame = CreateFrame("Frame", nil, nil, "ProfessionProgressTemplate")
    end
    frame:Show()
    return frame
end

function ReleaseProfessionProgress(frame)
    frame:Hide()
    frame:ClearAllPoints()
    frame:SetParent(nil)
    table.insert(ProfessionProgressPool, frame)
end

-- ========================================================
-- UI Refresh Functions
-- ========================================================

function ProfessionTrackerDashboard:Refresh()
    -- Clear existing entries
    local scrollChild = self.ScrollFrame.ScrollChild
    for _, frame in ipairs(self.activeEntries or {}) do
        ReleaseCharacterEntry(frame)
    end
    self.activeEntries = {}
    
    -- Get all characters
    local characters = ProfessionTracker:GetAllCharacters()
    if not characters then
        print("|cffff0000[Profession Tracker]|r No character data found")
        return
    end
    
    -- Sort characters by last login (most recent first)
    local sortedChars = {}
    for charKey, charData in pairs(characters) do
        table.insert(sortedChars, {key = charKey, data = charData})
    end
    table.sort(sortedChars, function(a, b)
        return (a.data.lastLogin or 0) > (b.data.lastLogin or 0)
    end)
    
    -- Create entries
    local yOffset = 0
    for _, char in ipairs(sortedChars) do
        local entry = self:CreateCharacterEntry(char.key, char.data)
        if entry then
            entry:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, yOffset)
            yOffset = yOffset - (entry:GetHeight() + 10)
            table.insert(self.activeEntries, entry)
        end
    end
    
    -- Update scroll child height
    scrollChild:SetHeight(math.abs(yOffset))
end

function ProfessionTrackerDashboard:CreateCharacterEntry(charKey, charData)
    local entry = AcquireCharacterEntry()
    
    -- Set character name with class color
    local classColor = CLASS_COLORS[charData.class] or {1, 1, 1}
    entry.Name:SetText(string.format("|cff%02x%02x%02x%s-%s|r",
        classColor[1] * 255,
        classColor[2] * 255,
        classColor[3] * 255,
        charData.name or "Unknown",
        charData.realm or "Unknown"))
    
    -- Set character info
    entry.Info:SetText(string.format("Level %d %s", 
        charData.level or 0,
        charData.class or "Unknown"))
    
    -- Create profession progress indicators
    if charData.professions then
        local profIndex = 0
        local xOffset = 0
        
        for profName, profData in pairs(charData.professions) do
            if profData.expansions then
                -- Find the most current expansion (highest ID)
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
                
                -- Only show the most current expansion
                if mostCurrentExp then
                    local profFrame = self:CreateProfessionProgress(entry, profName, mostCurrentExp.name, mostCurrentExp.data, profData)
                    if profFrame then
                        profFrame:SetParent(entry.ProfessionContainer)
                        profFrame:SetPoint("TOPLEFT", entry.ProfessionContainer, "TOPLEFT", xOffset, 0)
                        xOffset = xOffset + 205
                        table.insert(entry.professionFrames, profFrame)
                        profIndex = profIndex + 1
                        
                        -- Wrap to next row if needed
                        if profIndex % 4 == 0 then
                            xOffset = 0
                        end
                    end
                end
            end
        end
    end
    
    return entry
end

function ProfessionTrackerDashboard:CreateProfessionProgress(parentEntry, profName, expName, expData, profData)
    local frame = AcquireProfessionProgress()
    
    -- Set profession name
    frame.Name:SetText(profName)
    
    -- Set expansion name
    frame.Expansion:SetText(expName)
    
    -- Get weekly progress data
    local weekly = expData.weeklyKnowledgePoints or {}
    
    -- Helper to set icon alpha based on completion
    local function SetIconStatus(icon, completed)
        if completed then
            icon:SetAlpha(1.0)
            icon:SetDesaturated(false)
        else
            icon:SetAlpha(0.3)
            icon:SetDesaturated(true)
        end
    end
    
    -- Treatise status
    SetIconStatus(frame.TreatiseIcon, weekly.treatise == true)
    frame.TreatiseIcon:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine("Treatise")
        if weekly.treatise then
            GameTooltip:AddLine("|cff00ff00Completed|r", 1, 1, 1)
        else
            GameTooltip:AddLine("|cffff0000Not Completed|r", 1, 1, 1)
        end
        GameTooltip:Show()
    end)
    frame.TreatiseIcon:SetScript("OnLeave", function() GameTooltip:Hide() end)
    
    -- Crafting Order status
    SetIconStatus(frame.CraftingOrderIcon, weekly.craftingOrderQuest == true)
    frame.CraftingOrderIcon:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine("Crafting Order Quest")
        if weekly.craftingOrderQuest then
            GameTooltip:AddLine("|cff00ff00Completed|r", 1, 1, 1)
        else
            GameTooltip:AddLine("|cffff0000Not Completed|r", 1, 1, 1)
        end
        GameTooltip:Show()
    end)
    frame.CraftingOrderIcon:SetScript("OnLeave", function() GameTooltip:Hide() end)
    
    -- Treasures status
    local treasuresComplete = weekly.treasuresAllComplete == true
    SetIconStatus(frame.TreasuresIcon, treasuresComplete)
    frame.TreasuresIcon:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine("Weekly Treasures")
        
        if weekly.treasures and type(weekly.treasures) == "table" then
            for i, treasure in ipairs(weekly.treasures) do
                local status = treasure.completed and "|cff00ff00✓|r" or "|cffff0000✗|r"
                GameTooltip:AddLine(string.format("%s %s", status, treasure.label or "Treasure " .. i), 1, 1, 1)
            end
        elseif treasuresComplete then
            GameTooltip:AddLine("|cff00ff00All Completed|r", 1, 1, 1)
        else
            GameTooltip:AddLine("|cffff0000Not Completed|r", 1, 1, 1)
        end
        GameTooltip:Show()
    end)
    frame.TreasuresIcon:SetScript("OnLeave", function() GameTooltip:Hide() end)
    
    -- Gather Nodes status (for gathering professions and enchanting)
    local isGathering = GATHERING_PROFESSIONS[profName]
    local isEnchanting = (profData and profData.name == "Enchanting")
    
    if isGathering or isEnchanting then
        frame.GatherNodesIcon:Show()
        local nodesComplete = weekly.gatherNodesAllComplete == true
        SetIconStatus(frame.GatherNodesIcon, nodesComplete)
        
        frame.GatherNodesIcon:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:AddLine("Gather Nodes")
            
            if weekly.gatherNodes and type(weekly.gatherNodes) == "table" then
                for i, node in ipairs(weekly.gatherNodes) do
                    local status = node.completed and "|cff00ff00✓|r" or "|cffff0000✗|r"
                    GameTooltip:AddLine(string.format("%s %s (%d)", status, node.name or "Node " .. i, node.count or 0), 1, 1, 1)
                end
            elseif nodesComplete then
                GameTooltip:AddLine("|cff00ff00All Completed|r", 1, 1, 1)
            else
                GameTooltip:AddLine("|cffff0000Not Completed|r", 1, 1, 1)
            end
            GameTooltip:Show()
        end)
        frame.GatherNodesIcon:SetScript("OnLeave", function() GameTooltip:Hide() end)
    else
        frame.GatherNodesIcon:Hide()
    end
    
    return frame
end

-- ========================================================
-- Slash Commands & Initialization
-- ========================================================

SLASH_PROFESSIONTRACKER1 = "/pt"
SLASH_PROFESSIONTRACKER2 = "/proftracker"
SlashCmdList["PROFESSIONTRACKER"] = function(msg)
    msg = string.lower(msg or "")
    
    if msg == "show" or msg == "" then
        ProfessionTrackerDashboard:Show()
        ProfessionTrackerDashboard:Refresh()
    elseif msg == "hide" then
        ProfessionTrackerDashboard:Hide()
    elseif msg == "refresh" then
        ProfessionTrackerDashboard:Refresh()
        print("|cff00ff00[Profession Tracker]|r Dashboard refreshed")
    else
        print("|cff00ff00[Profession Tracker]|r Commands:")
        print("  /pt show - Show dashboard")
        print("  /pt hide - Hide dashboard")
        print("  /pt refresh - Refresh data")
    end
end

-- Initialize active entries table
ProfessionTrackerDashboard.activeEntries = {}

-- Apply dashboard backdrop on load
ProfessionTrackerDashboard:SetScript("OnShow", function(self)
    if not self.backdropApplied then
        self:SetBackdrop(DASHBOARD_BACKDROP)
        self:SetBackdropColor(0, 0, 0, 0.8)
        self:SetBackdropBorderColor(0.6, 0.6, 0.6, 1)
        self.backdropApplied = true
    end
end)

-- Register with ProfessionTracker
if ProfessionTracker and ProfessionTracker.RegisterUI then
    ProfessionTracker:RegisterUI(ProfessionTrackerDashboard)
end

print("|cff00ff00[Profession Tracker]|r UI loaded. Type /pt to open dashboard.")