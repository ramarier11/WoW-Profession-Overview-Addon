-- ########################################################
-- ## Profession Tracker: UI (Movable + Close)   ##
-- ########################################################
-- Checking if pull request is working

local ProfessionTrackerUI = CreateFrame("Frame", "ProfessionTrackerUIFrame", UIParent, "BackdropTemplate")

ProfessionTrackerUI:SetSize(420, 300)
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

ProfessionTrackerUI.selectedProfession = nil
ProfessionTrackerUI.currentExpansionIndex = 1

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
-- Dropdown & Arrow Layout
--------------------------------------------------------
local headerFrame = CreateFrame("Frame", nil, ProfessionTrackerUI)
headerFrame:SetSize(300, 30)
headerFrame:SetPoint("TOP", 0, -45)

local leftButton = CreateFrame("Button", nil, headerFrame, "UIPanelButtonTemplate")
leftButton:SetSize(25, 25)
leftButton:SetPoint("LEFT", headerFrame, "LEFT", 0, 0)
leftButton:SetText("<")

local dropdown = CreateFrame("Frame", "ProfessionTrackerUIDropdown", headerFrame, "UIDropDownMenuTemplate")
dropdown:SetPoint("LEFT", leftButton, "RIGHT", -10, -2)
ProfessionTrackerUI.dropdown = dropdown

local rightButton = CreateFrame("Button", nil, headerFrame, "UIPanelButtonTemplate")
rightButton:SetSize(25, 25)
rightButton:SetPoint("LEFT", dropdown, "RIGHT", -15, 2)
rightButton:SetText(">")


local expansionTitle = ProfessionTrackerUI:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
expansionTitle:SetPoint("TOP", 0, -90)
ProfessionTrackerUI.expansionTitle = expansionTitle

--------------------------------------------------------
-- Main Content
--------------------------------------------------------
local content = CreateFrame("Frame", nil, ProfessionTrackerUI)
content:SetSize(360, 150)
content:SetPoint("TOP", 0, -150)
ProfessionTrackerUI.content = content

local skillText = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
skillText:SetPoint("TOPLEFT", content, "TOPLEFT", 0, 0)
ProfessionTrackerUI.skillText = skillText

local knowledgeText = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
knowledgeText:SetPoint("TOPLEFT", skillText, "BOTTOMLEFT", 0, -10)
ProfessionTrackerUI.knowledgeText = knowledgeText

local pointsRemainingText = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
pointsRemainingText:SetPoint("TOPLEFT", knowledgeText, "BOTTOMLEFT", 0, -10)
ProfessionTrackerUI.pointsRemainingText = pointsRemainingText


--------------------------------------------------------
-- Dropdown Logic
--------------------------------------------------------
local function Dropdown_OnClick(self)
    UIDropDownMenu_SetSelectedValue(dropdown, self.value)
    ProfessionTrackerUI.selectedProfession = self.value
    ProfessionTrackerUI.currentExpansionIndex = 1
    ProfessionTrackerUI:Refresh()
end

local function Dropdown_Initialize(self, level)
    local charData = ProfessionTracker:GetCharacterData()
    if not charData or not charData.professions then return end

    for profName in pairs(charData.professions) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = profName
        info.value = profName
        info.func = Dropdown_OnClick
        info.checked = (UIDropDownMenu_GetSelectedValue(dropdown) == profName)
        UIDropDownMenu_AddButton(info, level)
    end
end


UIDropDownMenu_Initialize(dropdown, Dropdown_Initialize)
UIDropDownMenu_SetWidth(dropdown, 160)
UIDropDownMenu_SetText(dropdown, "Select Profession")



--------------------------------------------------------
-- Refresh Logic
--------------------------------------------------------
function ProfessionTrackerUI:Refresh()
    local charData = ProfessionTracker:GetCharacterData()
    if not charData or not charData.professions then
        self.expansionTitle:SetText("No data found.")
        self.skillText:SetText("")
        self.knowledgeText:SetText("")
        return
    end

    local professionName = self.selectedProfession
    if not professionName then
        self.expansionTitle:SetText("Select a profession.")
        self.skillText:SetText("")
        self.knowledgeText:SetText("")
        return
    end

    local professionData = charData.professions[professionName]
    if not professionData or not professionData.expansions then
        self.expansionTitle:SetText("No expansions found.")
        self.skillText:SetText("")
        self.knowledgeText:SetText("")
        return
    end

    local expansions = {}
    for name, data in pairs(professionData.expansions) do
        table.insert(expansions, { name = name, data = data })
    end
    table.sort(expansions, function(a, b) return (a.data.id or 0) > (b.data.id or 0) end)

    if #expansions == 0 then return end

    -- Clamp index
    if self.currentExpansionIndex < 1 then
        self.currentExpansionIndex = #expansions
    elseif self.currentExpansionIndex > #expansions then
        self.currentExpansionIndex = 1
    end

    local current = expansions[self.currentExpansionIndex]
    if not current then return end

    -- Text
    self.expansionTitle:SetText(current.name)
    self.skillText:SetText(string.format("Skill Level: %d / %d", current.data.skillLevel or 0, current.data.maxSkillLevel or 0))

    --------------------------------------------------------
-- Knowledge Point Display
--------------------------------------------------------
local hasKnowledgeSystem = current.data.id and current.data.id >= (10)

if hasKnowledgeSystem then
    local knowledge = current.data.knowledgePoints or 0
    local remaining = current.data.pointsUntilMaxKnowledge or 0

    -- Show current knowledge
    self.knowledgeText:SetText(string.format("Knowledge Points: %d", knowledge))

    -- Show remaining points or maxed message
    if remaining > 0 then
        self.pointsRemainingText:SetText(string.format("Points Until Max: %d", remaining))
    else
        self.pointsRemainingText:SetText("Knowledge Maxed")
    end
else
    -- Hide fields for expansions without knowledge systems
    self.knowledgeText:SetText("")
    self.pointsRemainingText:SetText("")
end

end

--------------------------------------------------------
-- Button Handlers
--------------------------------------------------------
leftButton:SetScript("OnClick", function()
    ProfessionTrackerUI.currentExpansionIndex = ProfessionTrackerUI.currentExpansionIndex - 1
    ProfessionTrackerUI:Refresh()
end)

rightButton:SetScript("OnClick", function()
    ProfessionTrackerUI.currentExpansionIndex = ProfessionTrackerUI.currentExpansionIndex + 1
    ProfessionTrackerUI:Refresh()
end)

--------------------------------------------------------
-- Slash Command
--------------------------------------------------------
SLASH_PROFTRACKER1 = "/proftrack"
SlashCmdList["PROFTRACKER"] = function()
    if ProfessionTrackerUI:IsShown() then
        ProfessionTrackerUI:Hide()
    else
        UIDropDownMenu_Initialize(dropdown, Dropdown_Initialize)
        UIDropDownMenu_SetText(dropdown, "Select Profession")
        ProfessionTrackerUI.selectedProfession = nil
        ProfessionTrackerUI.currentExpansionIndex = 1
        ProfessionTrackerUI:Refresh()
        ProfessionTrackerUI:Show()
    end
end

-- Register this UI with the core addon
if ProfessionTracker and ProfessionTracker.RegisterUI then
    ProfessionTracker:RegisterUI(ProfessionTrackerUI)
end

