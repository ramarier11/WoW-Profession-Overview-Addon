-- ########################################################
-- ## Profession Tracker: Data Initialization & Storage  ##
-- ########################################################

ProfessionTracker = CreateFrame("Frame")

-- Register the UI so it can be refreshed later
function ProfessionTracker:RegisterUI(uiFrame)
    self.UI = uiFrame
end

-- ========================================================
-- Constants & Configuration
-- ========================================================

local ExpansionIndex = {
    ["Classic"] = 1,
    ["Outland"] = 2,
    ["Northrend"] = 3,
    ["Cataclysm"] = 4,
    ["Pandaria"] = 5,
    ["Draenor"] = 6,
    ["Legion"] = 7,
    ["Zandalari"] = 8,
    ["Kul Tiran"] = 8,
    ["Shadowlands"] = 9,
    ["Dragon Isles"] = 10,
    ["Khaz Algar"] = 11,
}

local KNOWLEDGE_SYSTEM_START = 10 -- Dragon Isles and later

local ProfessionData = {
    {
        name = "Alchemy",
        id = 171,
        expansions = { 2485, 2484, 2483, 2482, 2481, 2480, 2479, 2478, 2750, 2823, 2871 },
    },
    {
        name = "Blacksmithing",
        id = 164,
        expansions = { 2477, 2476, 2475, 2474, 2473, 2472, 2454, 2437, 2751, 2822, 2872 },
    },
    {
        name = "Cooking",
        id = 185,
        expansions = { 2548, 2547, 2546, 2545, 2544, 2543, 2542, 2541, 2752, 2824, 2873 },
    },
    {
        name = "Enchanting",
        id = 333,
        expansions = { 2494, 2493, 2492, 2491, 2489, 2488, 2487, 2486, 2753, 2825, 2874 },
    },
    {
        name = "Engineering",
        id = 202,
        expansions = { 2506, 2505, 2504, 2503, 2502, 2501, 2500, 2499, 2755, 2827, 2875 },
    },
    {
        name = "Fishing",
        id = 356,
        expansions = { 2592, 2591, 2590, 2589, 2588, 2587, 2586, 2585, 2754, 2826, 2876 },
    },
    {
        name = "Herbalism",
        id = 182,
        expansions = { 2556, 2555, 2554, 2553, 2552, 2551, 2550, 2549, 2760, 2832, 2877 },
    },
    {
        name = "Inscription",
        id = 773,
        expansions = { 2514, 2513, 2512, 2511, 2510, 2509, 2508, 2507, 2756, 2828, 2878 },
    },
    {
        name = "Jewelcrafting",
        id = 755,
        expansions = { 2524, 2523, 2522, 2521, 2520, 2519, 2518, 2517, 2757, 2829, 2879 },
    },
    {
        name = "Leatherworking",
        id = 165,
        expansions = { 2532, 2531, 2530, 2529, 2528, 2527, 2526, 2525, 2758, 2830, 2880 },
    },
    {
        name = "Mining",
        id = 186,
        expansions = { 2572, 2571, 2570, 2569, 2568, 2567, 2566, 2565, 2761, 2833, 2881 },
    },
    {
        name = "Skinning",
        id = 393,
        expansions = { 2564, 2563, 2562, 2561, 2560, 2559, 2558, 2557, 2762, 2834, 2882 },
    },
    {
        name = "Tailoring",
        id = 197,
        expansions = { 2540, 2539, 2538, 2537, 2536, 2535, 2534, 2533, 2759, 2831, 2883 },
    },
}

-- ========================================================
-- Utility Functions
-- ========================================================

local function GetCharacterKey()
    local name, realm = UnitFullName("player")

    -- Fallback if realm isn't available yet
    if not realm or realm == "" then
        realm = GetRealmName() or "UnknownRealm"
    end

    if not name then
        name = UnitName("player") or "UnknownPlayer"
    end

    return string.format("%s-%s", name, realm)
end

local function EnsureTable(t, key)
    if not t[key] then t[key] = {} end
    return t[key]
end

local function GetCurrentWeekTimestamp()
    -- Get Tuesday 00:00:00 of current week (US reset time)
    local serverTime = GetServerTime()
    local weekday = date("%w", serverTime) -- 0 = Sunday, 2 = Tuesday
    local daysSinceTuesday = (weekday - 2) % 7
    local tuesdayMidnight = serverTime - (daysSinceTuesday * 86400)
    
    -- Align to midnight
    local midnight = tuesdayMidnight - (tuesdayMidnight % 86400)
    return midnight
end

-- ========================================================
-- Profession Data Retrieval
-- ========================================================

-- Attempts to dynamically fetch expansion data from Blizzard API
local function GetCharacterProfessionExpansions(professionName)
    local expansions = {}

    -- Attempt dynamic retrieval from API
    if C_TradeSkillUI and C_TradeSkillUI.GetChildProfessionInfos then
        local childInfos = C_TradeSkillUI.GetChildProfessionInfos()
        if childInfos then
            for _, info in ipairs(childInfos) do
                if info.parentProfessionName == professionName then
                    table.insert(expansions, {
                        expansionName = info.expansionName or "Unknown",
                        skillLineID = info.professionID,
                        skillLevel = info.skillLevel,
                        maxSkillLevel = info.maxSkillLevel,
                    })
                end
            end
        end
    end

    return expansions
end

-- ========================================================
-- Knowledge Point Calculations
-- ========================================================

local function GetPointsMissingForTree(configID, nodeID)
    local todo = { nodeID }
    local missing = 0
    
    while next(todo) do
        local currentNodeID = table.remove(todo)
        
        -- Add children to process
        local children = C_ProfSpecs.GetChildrenForPath(currentNodeID)
        if children then
            for _, childID in ipairs(children) do
                table.insert(todo, childID)
            end
        end
        
        -- Calculate missing points for this node
        local info = C_Traits.GetNodeInfo(configID, currentNodeID)
        if info then
            -- Enabling a node counts as 1 rank but doesn't cost anything
            local enableFix = info.activeRank == 0 and 1 or 0
            missing = missing + info.maxRanks - info.activeRank - enableFix
        end
    end
    
    return missing
end

-- Calculate how many knowledge points are still missing for a profession
local function CalculateMissingKnowledgePoints(skillLineID)
    if not skillLineID then return 0 end
    
    local configID = C_ProfSpecs.GetConfigIDForSkillLine(skillLineID)
    if not configID then return 0 end
    
    local traitTreeIDs = C_ProfSpecs.GetSpecTabIDsForSkillLine(skillLineID)
    if not traitTreeIDs then return 0 end
    
    local totalMissing = 0
    
    for _, traitTreeID in ipairs(traitTreeIDs) do
        local tabInfo = C_ProfSpecs.GetTabInfo(traitTreeID)
        if tabInfo and tabInfo.rootNodeID then
            totalMissing = totalMissing + GetPointsMissingForTree(configID, tabInfo.rootNodeID)
        end
    end
    
    -- Subtract available unspent points
    local currencyInfo = C_ProfSpecs.GetCurrencyInfoForSkillLine(skillLineID)
    if currencyInfo and currencyInfo.numAvailable then
        totalMissing = totalMissing - currencyInfo.numAvailable
    end
    
    return totalMissing
end

-- ========================================================
-- Weekly Reset Handling
-- ========================================================

local function CheckAndResetWeeklyProgress(weeklyProgress)
    if not weeklyProgress then return end
    
    local currentWeek = GetCurrentWeekTimestamp()
    
    for activity, data in pairs(weeklyProgress) do
        if data.lastReset and data.lastReset < currentWeek then
            -- Reset this activity
            data.completed = false
            data.lastReset = currentWeek
        elseif not data.lastReset then
            -- Initialize reset timestamp
            data.lastReset = currentWeek
        end
    end
end

-- ========================================================
-- Data Initialization & Update
-- ========================================================

local function UpdateCharacterProfessionData()
    if not ProfessionTrackerDB then
        ProfessionTrackerDB = {
            version = "1.0.0",
            characters = {},
        }
    end

    local charKey = GetCharacterKey()
    local charData = EnsureTable(ProfessionTrackerDB.characters, charKey)
    
    -- Initialize character metadata if needed
    if not charData then
        local name, realm = UnitFullName("player")
        charData.name = name
        charData.realm = realm or GetRealmName()
        charData.class = UnitClass("player")
        charData.level = UnitLevel("player")
        charData.faction = UnitFactionGroup("player")
    end
    
    charData.lastLogin = time()
    
    local professions = EnsureTable(charData, "professions")

    -- Track currently learned professions
    local currentProfs = {}
    local profIndices = { GetProfessions() }

    for _, profIndex in ipairs(profIndices) do
        if profIndex then
            local name, _, skillLevel, maxSkillLevel = GetProfessionInfo(profIndex)
            if name then
                currentProfs[name] = true

                -- Initialize or get profession entry
                local profession = professions[name]
                if not profession then
                    profession = {
                        expansions = {},
                        lastUpdated = time(),
                    }
                    professions[name] = profession
                    print(string.format("|cff00ff00[Profession Tracker]|r Tracking new profession: %s", name))
                else
                    profession.lastUpdated = time()
                end

                local expansions = profession.expansions

                -- Retrieve expansion-specific data from Blizzard API
                local expansionList = GetCharacterProfessionExpansions(name)

                for _, exp in ipairs(expansionList) do
                    local expName = exp.expansionName or "Unknown"
                    local expID = ExpansionIndex[expName] or 0
                    
                    -- Check if this expansion has the knowledge system
                    local hasKnowledgeSystem = expID >= KNOWLEDGE_SYSTEM_START

                     -- ✅ reuse existing expansion table if present
                    local expData = expansions[expName] or {}
                    expData.name = expName
                    expData.id = expID
                    expData.skillLineID = exp.skillLineID or expData.skillLineID
                    expData.skillLevel = exp.skillLevel or expData.skillLevel or 0
                    expData.maxSkillLevel = exp.maxSkillLevel or expData.maxSkillLevel or 0

                        -- Initialize knowledge system data for modern expansions
                        if hasKnowledgeSystem then
                            local missing = CalculateMissingKnowledgePoints(exp.skillLineID)
                            expData.pointsUntilMaxKnowledge = missing or expData.pointsUntilMaxKnowledge or 0
                            expData.knowledgePoints = expData.knowledgePoints or 0
                            expData.weeklyKnowledgePoints = expData.weeklyKnowledgePoints or {
                                treatise = false,
                                treasures = false,
                                craftingOrderQuest = false,
                        }
                        end

                        expansions[expName] = expData


                end
            end
        end
    end

    -- Remove professions the player no longer has
    for savedName in pairs(professions) do
        if not currentProfs[savedName] then
            print("|cffff0000[Profession Tracker]|r Removed profession:", savedName)
            professions[savedName] = nil
        end
    end

    -- Auto-refresh UI if it's open
    if ProfessionTracker.UI and ProfessionTracker.UI:IsShown() then
        C_Timer.After(0.25, function()
            if ProfessionTracker.UI.selectedProfession then
                ProfessionTracker.UI:Refresh()
            end
        end)
    end

    print("|cff00ff00[Profession Tracker]|r Data updated for:", charKey)
end

-- ========================================================
-- Public Accessors
-- ========================================================

function ProfessionTracker:GetCharacterData()
    local key = GetCharacterKey()
    return ProfessionTrackerDB and ProfessionTrackerDB[key]
end

function ProfessionTracker:GetProfessionData(profession)
    local charData = self:GetCharacterData()
    if not charData then return end
    return charData.professions and charData.professions[profession]
end

function ProfessionTracker:GetAllCharacters()
    if not ProfessionTrackerDB then return {} end
    local chars = {}
    for key, data in pairs(ProfessionTrackerDB) do
        if key ~= "version" and type(data) == "table" then
            table.insert(chars, {
                key = key,
                name = data.name,
                realm = data.realm,
                class = data.class,
                level = data.level,
                lastLogin = data.lastLogin,
            })
        end
    end
    return chars
end

-- ========================================================
-- Weekly Activity Tracking
-- ========================================================

function ProfessionTracker:MarkWeeklyActivityComplete(profession, expansion, activity)
    local charData = self:GetCharacterData()
    if not charData or not charData.professions then return false end
    
    local profData = charData.professions[profession]
    if not profData or not profData.expansions then return false end
    
    local expData = profData.expansions[expansion]
    if not expData or not expData.weeklyKnowledgeProgress then return false end
    
    if expData.weeklyKnowledgeProgress[activity] then
        expData.weeklyKnowledgeProgress[activity].completed = true
        expData.weeklyKnowledgeProgress[activity].lastCompleted = time()
        print(string.format("|cff00ff00[Profession Tracker]|r Marked %s complete for %s (%s)", 
            activity, profession, expansion))
        return true
    end
    
    return false
end

-- ========================================================
-- Event Registration & Handling
-- ========================================================

ProfessionTracker:RegisterEvent("TRADE_SKILL_SHOW")
ProfessionTracker:RegisterEvent("SKILL_LINES_CHANGED")
ProfessionTracker:RegisterEvent("TRAIT_TREE_CURRENCY_INFO_UPDATED")
ProfessionTracker:RegisterEvent("TRADE_SKILL_DATA_SOURCE_CHANGED")
ProfessionTracker:RegisterEvent("TRADE_SKILL_LIST_UPDATE")
ProfessionTracker:RegisterEvent("LEARNED_SPELL_IN_SKILL_LINE")
ProfessionTracker:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
ProfessionTracker:RegisterEvent("PLAYER_LOGIN")

ProfessionTracker:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        -- Initialize database on login
        C_Timer.After(2, function()
            UpdateCharacterProfessionData()
        end)
    elseif event == "TRADE_SKILL_SHOW" or
           event == "SKILL_LINES_CHANGED" or
           event == "TRADE_SKILL_LIST_UPDATE" or
           event == "TRADE_SKILL_DATA_SOURCE_CHANGED" or
           event == "LEARNED_SPELL_IN_SKILL_LINE" or
           event == "TRAIT_TREE_CURRENCY_INFO_UPDATED" or 
           event == "CURRENCY_DISPLAY_UPDATE" then
        -- Update data on profession-related events
        UpdateCharacterProfessionData()
    end
end)

-- ========================================================
-- Debug Commands
-- ========================================================

function ProfessionTracker:PrintCharacterData()
    local charData = self:GetCharacterData()
    if not charData then
        print("|cffff0000[Profession Tracker]|r No data found for this character")
        return
    end
    
    print("|cff00ff00[Profession Tracker]|r Character Data:")
    print(string.format("  Name: %s-%s", charData.name or "Unknown", charData.realm or "Unknown"))
    print(string.format("  Class: %s, Level: %d", charData.class or "Unknown", charData.level or 0))
    
    if charData.professions then
        print("  Professions:")
        for profName, profData in pairs(charData.professions) do
            print(string.format("    - %s", profName))
            if profData.expansions then
                for expName, expData in pairs(profData.expansions) do
                    local knowledgeInfo = ""
                    if expData.knowledgePoints then
                        knowledgeInfo = string.format(" [Knowledge: %d Remaining %d]",
                            expData.knowledgePoints or 0,
                            expData.pointsUntilMaxKnowledge or 0)
                    end
                    print(string.format("      %s: %d/%d%s",
                        expName,
                        expData.skillLevel or 0,
                        expData.maxSkillLevel or 0,
                        knowledgeInfo))
                end
            end
        end
    end
end