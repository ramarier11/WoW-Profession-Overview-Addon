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
        
        -- Add hover highlight effect
        frame:EnableMouse(true)
        frame:SetScript("OnEnter", function(self)
            self:SetBackdropBorderColor(1, 0.82, 0, 1)  -- Gold highlight
        end)
        frame:SetScript("OnLeave", function(self)
            self:SetBackdropBorderColor(0.6, 0.6, 0.6, 1)  -- Reset to normal
        end)
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
    
    -- Create entries in 2-column layout
    local xOffset = 0
    local yOffset = 0
    local columnWidth = 420  -- Width of each character card plus spacing
    local currentColumn = 0
    local maxHeightInRow = 0
    
    for i, char in ipairs(sortedChars) do
        local entry = self:CreateCharacterEntry(char.key, char.data)
        if entry then
            entry:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", xOffset, yOffset)
            table.insert(self.activeEntries, entry)
            
            -- Track the tallest entry in this row
            local entryHeight = entry:GetHeight()
            if entryHeight > maxHeightInRow then
                maxHeightInRow = entryHeight
            end
            
            -- Move to next column or next row
            currentColumn = currentColumn + 1
            if currentColumn >= 2 then
                -- Move to next row
                currentColumn = 0
                xOffset = 0
                yOffset = yOffset - (maxHeightInRow + 10)
                maxHeightInRow = 0
            else
                -- Move to next column
                xOffset = xOffset + columnWidth
            end
        end
    end
    
    -- Add one more row height if we ended mid-row
    if currentColumn > 0 then
        yOffset = yOffset - (maxHeightInRow + 10)
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
    local profCount = 0
    local maxProfessionsPerRow = 2  -- Changed from 4 to 2 for narrower cards
    
    if charData.professions then
        local profIndex = 0
        local xOffset = 0
        local yOffset = 0
        local currentRow = 0
        
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
                        profFrame:SetPoint("TOPLEFT", entry.ProfessionContainer, "TOPLEFT", xOffset, yOffset)
                        xOffset = xOffset + 195  -- Adjusted for 2-column layout
                        table.insert(entry.professionFrames, profFrame)
                        profIndex = profIndex + 1
                        profCount = profCount + 1
                        
                        -- Wrap to next row if needed
                        if profIndex % maxProfessionsPerRow == 0 then
                            xOffset = 0
                            yOffset = yOffset - 90  -- Height for each profession box plus spacing
                            currentRow = currentRow + 1
                        end
                    end
                end
            end
        end
    end
    
    -- Calculate dynamic height based on number of professions
    -- Base height: 60 (header + padding)
    -- Each row of professions: 90 pixels
    local rows = math.ceil(profCount / maxProfessionsPerRow)
    local dynamicHeight = 60 + (rows * 90)
    entry:SetHeight(dynamicHeight)
    
    -- Also adjust the profession container height
    entry.ProfessionContainer:SetHeight((rows * 90) + 10)
    
    return entry
end

function ProfessionTrackerDashboard:CreateProfessionProgress(parentEntry, profName, expName, expData, profData)
    local frame = AcquireProfessionProgress()
    
    -- Set profession name
    frame.Name:SetText(profName)
    frame.Name:SetTextColor(1,1,1,1) --profName to white
    
    -- Set expansion name
    -- frame.Expansion:SetText(expName)
    
    -- Get weekly progress data
    local weekly = expData.weeklyKnowledgePoints or {}
    
    -- Check if this is a gathering profession or enchanting
    local isGathering = GATHERING_PROFESSIONS[profName]
    local isEnchanting = (profData and profData.name == "Enchanting")
    
    -- Get profession ID and expansion index for icon lookup
    local profID = expData.baseSkillLineID
    local expIndex = expData.id
    
    -- Get icon references from KPReference table
    local treatiseIcon = "Interface\\Icons\\inv_misc_profession_book_enchanting"
    local craftingOrderIcon = "Interface\\Gossipframe\\inv_crafting_orders"
    local treasuresIcon = "Interface\\Icons\\inv_misc_book_07"
    local gatherNodesIcon = "Interface\\Icons\\inv_magic_swirl_color2"
    
    if profID and expIndex and KPReference and KPReference[profID] and KPReference[profID][expIndex] then
        local ref = KPReference[profID][expIndex]
        
        -- Get treatise icon
        if ref.weekly and ref.weekly.treatise and ref.weekly.treatise.icon then
            treatiseIcon = ref.weekly.treatise.icon
        end
        
        -- Get crafting order icon - use atlas for crafting orders
        if ref.weekly and ref.weekly.craftingOrder then
            -- Use atlas texture instead of icon path
            craftingOrderIcon = "|A:RecurringAvailableQuestIcon:16:16|a"
        else
            -- Fallback to regular icon if no crafting order data
            craftingOrderIcon = "Interface\\Icons\\inv_crafting_orders"
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
    
    -- Helper to create status line with icon, text, and check/x
    local function GetStatusLine(icon, label, completed, isAtlas)
        local statusIcon = completed 
            and "|TInterface\\RaidFrame\\ReadyCheck-Ready:14:14|t" 
            or "|TInterface\\RaidFrame\\ReadyCheck-NotReady:14:14|t"
        
        -- Handle atlas textures differently from regular textures
        local iconDisplay
        if isAtlas then
            iconDisplay = icon  -- Already formatted with |A:...|a
        else
            iconDisplay = string.format("|T%s:16:16|t", icon)
        end
        
        return string.format("%s %s %s", iconDisplay, label, statusIcon)
    end
    
    -- Build status text
    local statusLines = {}
    
    -- Crafting Order status
    table.insert(statusLines, GetStatusLine(
        craftingOrderIcon,
        "Profession Quest",
        weekly.craftingOrderQuest == true,
        true  -- isAtlas = true
    ))
    -- Treasures status (exclude for gathering professions, but include for enchanting)
    if not isGathering then
        local treasuresComplete = weekly.treasuresAllComplete == true
        table.insert(statusLines, GetStatusLine(
            treasuresIcon,
            "Treasures",
            treasuresComplete,
            false
        ))
    end
    
    -- Gather Nodes status (for gathering professions and enchanting)
    if isGathering or isEnchanting then
        local nodesComplete = weekly.gatherNodesAllComplete == true
        table.insert(statusLines, GetStatusLine(
            gatherNodesIcon,
            "Gather Nodes",
            nodesComplete,
            false
        ))
    end
    -- Treatise status
    table.insert(statusLines, GetStatusLine(
        treatiseIcon,
        "Treatise",
        weekly.treatise == true,
        false
    ))

    -- Create or update status text display
    if not frame.StatusText then
        frame.StatusText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        frame.StatusText:SetPoint("TOPLEFT", frame.Name, "BOTTOMLEFT", 0, -5)
        frame.StatusText:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -25)
        frame.StatusText:SetJustifyH("LEFT")
        frame.StatusText:SetJustifyV("TOP")
        frame.StatusText:SetSpacing(2)
    end
    
    frame.StatusText:SetText(table.concat(statusLines, "\n"))
    
    -- Add tooltip functionality to the entire frame
    frame:EnableMouse(true)
    frame:SetScript("OnEnter", function(self)
        -- Keep parent card highlighted
        if parentEntry then
            parentEntry:SetBackdropBorderColor(1, 0.82, 0, 1)
        end

        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine(profName .. " - " .. expName, 1, 1, 1, true)
        GameTooltip:AddLine(" ")
        
        -- Helper for status icons in tooltip
        local function GetTooltipStatus(completed)
            return completed 
                and "|TInterface\\RaidFrame\\ReadyCheck-Ready:14:14|t" 
                or "|TInterface\\RaidFrame\\ReadyCheck-NotReady:14:14|t"
        end
        
        -- Treatise
        GameTooltip:AddLine(GetTooltipStatus(weekly.treatise) .. " Treatise", 1, 1, 1)
        
        -- Crafting Order
        GameTooltip:AddLine(GetTooltipStatus(weekly.craftingOrderQuest) .. " Crafting Order", 1, 1, 1)
        
        -- Treasures (exclude for gathering professions)
        if not isGathering then
            local treasuresComplete = weekly.treasuresAllComplete == true
            if weekly.treasures and type(weekly.treasures) == "table" then
                GameTooltip:AddLine("Weekly Treasures:", 1, 1, 1)
                for i, treasure in ipairs(weekly.treasures) do
                    local status = treasure.completed 
                        and "|TInterface\\RaidFrame\\ReadyCheck-Ready:14:14|t" 
                        or "|TInterface\\RaidFrame\\ReadyCheck-NotReady:14:14|t"
                    GameTooltip:AddLine("  " .. status .. " " .. (treasure.label or "Treasure " .. i), 0.9, 0.9, 0.9)
                end
            else
                GameTooltip:AddLine(GetTooltipStatus(treasuresComplete) .. " Treasures", 1, 1, 1)
            end
        end
        
        -- Gather Nodes
        if isGathering or isEnchanting then
            if weekly.gatherNodes and type(weekly.gatherNodes) == "table" then
                GameTooltip:AddLine("Gather Nodes:", 1, 1, 1)
                for i, node in ipairs(weekly.gatherNodes) do
                    local status = node.completed 
                        and "|TInterface\\RaidFrame\\ReadyCheck-Ready:14:14|t" 
                        or "|TInterface\\RaidFrame\\ReadyCheck-NotReady:14:14|t"
                    GameTooltip:AddLine("  " .. status .. " " .. (node.name or "Node " .. i) .. " (" .. (node.count or 0) .. ")", 0.9, 0.9, 0.9)
                end
            else
                local nodesComplete = weekly.gatherNodesAllComplete == true
                GameTooltip:AddLine(GetTooltipStatus(nodesComplete) .. " Gather Nodes", 1, 1, 1)
            end
        end
        
        GameTooltip:Show()
    end)
    frame:SetScript("OnLeave", function(self) 
        GameTooltip:Hide()
        
        -- Reset parent card highlight only if mouse truly left the card
        if parentEntry and not MouseIsOver(parentEntry) then
            parentEntry:SetBackdropBorderColor(0.6, 0.6, 0.6, 1)
        end
    end)
    
    -- Hide the old icon textures since we're now embedding them in text
    frame.TreatiseIcon:Hide()
    frame.CraftingOrderIcon:Hide()
    frame.TreasuresIcon:Hide()
    frame.GatherNodesIcon:Hide()
    
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