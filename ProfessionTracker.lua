-- ########################################################
-- ## Profession Tracker: Data Initialization & Storage  ##
-- ########################################################

ProfessionTracker = CreateFrame("Frame")

-- Register the UI so it can be refreshed later
function ProfessionTracker:RegisterUI(uiFrame)
    self.UI = uiFrame
end

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
    ["Khaz Algar"] = 11, -- newest expansion
}

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

--------------------------------------------------------
-- Profession Expansion Lookup
--------------------------------------------------------

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

--------------------------------------------------------
-- Knowledge Point Calculations
--------------------------------------------------------

local function GetPointsMissingForTree(configID, nodeID)
    local todo = { nodeID }
    local missing = 0
    while next(todo) do
        local nodeID = table.remove(todo)
        tAppendAll(todo, C_ProfSpecs.GetChildrenForPath(nodeID))
        local info = C_Traits.GetNodeInfo(configID, nodeID)
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

    local configID = C_ProfSpecs.GetConfigIDForSkillLine(skillLineID)
    local traitTreeIDs = C_ProfSpecs.GetSpecTabIDsForSkillLine(skillLineID)
    local totalMissing = 0
    for _, traitTreeID in ipairs(traitTreeIDs) do
        local tabInfo = C_ProfSpecs.GetTabInfo(traitTreeID)
        totalMissing = totalMissing + GetPointsMissingForTree(configID, tabInfo.rootNodeID)
    end
    local currencyInfo = C_ProfSpecs.GetCurrencyInfoForSkillLine(skillLineID) or {numAvailable = 0}
    return totalMissing - currencyInfo.numAvailable
end

--------------------------------------------------------
-- ## Unified Character Data Initialization + Update
--------------------------------------------------------

local function UpdateCharacterProfessionData()
    if not ProfessionTrackerDB then
        ProfessionTrackerDB = {}
    end

    local charKey = GetCharacterKey()
    local charData = EnsureTable(ProfessionTrackerDB, charKey)
    local professions = EnsureTable(charData, "professions")

    -- Build a set of current profession names
    local currentProfs = {}
    local profIndices = { GetProfessions() }

    for _, profIndex in ipairs(profIndices) do
        if profIndex then
            local name, _, skillLevel, maxSkillLevel = GetProfessionInfo(profIndex)
            if name then
                currentProfs[name] = true

                -- Create or reuse profession entry
                local profession = EnsureTable(professions, name)
                local expansions = EnsureTable(profession, "expansions")

                -- Retrieve expansion-specific data from Blizzard API
                local expansionList = GetCharacterProfessionExpansions(name)

                for _, exp in ipairs(expansionList) do
                    local expName = exp.expansionName or "Unknown"
                    local expID = ExpansionIndex[expName] or 0
                    local dragonflightID = ExpansionIndex["Dragon Isles"] or 10                       
                    -- Create or update expansion entry
                    local expData = expansions[expName]
                    if expData then
                        expData = {
                            name = expName,
                            id = expID,
                            skillLineID = exp.skillLineID,
                            skillLevel = exp.skillLevel or 0,
                            maxSkillLevel = exp.maxSkillLevel or 0,
                        }

                        -- Add knowledge data only for Dragonflight and newer
                        if expID >= dragonflightID then
                            local missing = CalculateMissingKnowledgePoints(exp.skillLineID)
                            expData.knowledgePoints = expData.knowledgePoints or 0
                            expData.pointsUntilMaxKnowledge = missing                            
                            expData.weeklyKnowledgePoints = expData.weeklyKnowledgePoints or {
                                treatise = false,
                                treasures = false,
                                craftingOrderQuest = false,
                            }
                        end
                    end
                        
                    expansions[expName] = expData
                end
                
            end
        end
    end

    -- Remove any professions the player no longer has
    for savedName in pairs(professions) do
        if not currentProfs[savedName] then
            print("|cffff0000[Profession Tracker]|r Removed profession:", savedName)
            professions[savedName] = nil
        end
    end
   -- ✅ Auto-refresh the UI if it’s open
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
-- Accessors
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

-- ========================================================
-- Events
-- ========================================================
ProfessionTracker:RegisterEvent("TRADE_SKILL_SHOW")
ProfessionTracker:RegisterEvent("SKILL_LINES_CHANGED")
ProfessionTracker:RegisterEvent("TRAIT_TREE_CURRENCY_INFO_UPDATED")
ProfessionTracker:RegisterEvent("TRADE_SKILL_DATA_SOURCE_CHANGED")
ProfessionTracker:RegisterEvent("TRADE_SKILL_LIST_UPDATE")
ProfessionTracker:RegisterEvent("LEARNED_SPELL_IN_SKILL_LINE")
ProfessionTracker:RegisterEvent("CURRENCY_DISPLAY_UPDATE")


ProfessionTracker:SetScript("OnEvent", function(self, event, arg1, arg2, arg3)
    if event == "TRADE_SKILL_SHOW" or
       event == "SKILL_LINES_CHANGED" or
       event == "TRADE_SKILL_LIST_UPDATE" or
       event == "TRADE_SKILL_DATA_SOURCE_CHANGED" or
       event == "LEARNED_SPELL_IN_SKILL_LINE" or
       event == "TRAIT_TREE_CURRENCY_INFO_UPDATED" or 
       event == "CURRENCY_DISPLAY_UPDATE"
    then
        UpdateCharacterProfessionData()

        
    end

    
end)




