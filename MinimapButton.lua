-- ########################################################
-- ## Profession Tracker: Minimap Button
-- ########################################################

local addonName = "ProfessionTracker"
local buttonName = "ProfessionTrackerMinimapButton"

-- Create the minimap button
local minimapButton = CreateFrame("Button", buttonName, Minimap)
minimapButton:SetSize(32, 32)
minimapButton:SetFrameStrata("MEDIUM")
minimapButton:SetFrameLevel(8)
minimapButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
minimapButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

-- Set icon texture
local icon = minimapButton:CreateTexture(nil, "BACKGROUND")
icon:SetSize(20, 20)
icon:SetPoint("CENTER", 0, 0)
icon:SetTexture("Interface\\Icons\\Trade_Engineering") -- Using engineering icon as placeholder
minimapButton.icon = icon

-- Border/overlay texture
local overlay = minimapButton:CreateTexture(nil, "OVERLAY")
overlay:SetSize(53, 53)
overlay:SetPoint("TOPLEFT", 0, 0)
overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
minimapButton.overlay = overlay

-- Dragging functionality
minimapButton:SetMovable(true)
minimapButton:EnableMouse(true)
minimapButton:RegisterForDrag("LeftButton")

-- Tooltip
minimapButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("|cff00ff00Profession Tracker|r", 1, 1, 1)
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine("|cffffffffLeft-Click:|r Open Character Details", 0.8, 0.8, 0.8)
    GameTooltip:AddLine("|cffffffffRight-Click:|r Open Dashboard", 0.8, 0.8, 0.8)
    GameTooltip:AddLine("|cffffffffDrag:|r Move button", 0.8, 0.8, 0.8)
    GameTooltip:Show()
end)

minimapButton:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end)

-- Click handlers
minimapButton:SetScript("OnClick", function(self, button)
    if button == "LeftButton" then
        -- Open character detail window for current character
        local charKey = ProfessionTracker and (function()
            local name, realm = UnitFullName("player")
            if not realm or realm == "" then
                realm = GetRealmName() or "UnknownRealm"
            end
            if not name then
                name = UnitName("player") or "UnknownPlayer"
            end
            return string.format("%s-%s", name, realm)
        end)() or nil
        
        if charKey then
            local characters = ProfessionTracker:GetAllCharacters()
            if characters and characters[charKey] then
                if ProfessionTrackerUI and ProfessionTrackerUI.CharacterDetailWindow then
                    ProfessionTrackerUI.CharacterDetailWindow:ShowCharacter(charKey, characters[charKey])
                end
            else
                print("|cffff0000[Profession Tracker]|r No data found for current character")
            end
        end
    elseif button == "RightButton" then
        -- Open dashboard
        if ProfessionTrackerDashboard then
            if ProfessionTrackerDashboard:IsShown() then
                ProfessionTrackerDashboard:Hide()
            else
                ProfessionTrackerDashboard:Show()
                ProfessionTrackerDashboard:Refresh()
            end
        end
    end
end)

-- Position update function
local function UpdatePosition()
    if not ProfessionTrackerDB then
        ProfessionTrackerDB = {}
    end
    
    ProfessionTrackerDB.minimapButton = ProfessionTrackerDB.minimapButton or {}
    local config = ProfessionTrackerDB.minimapButton
    
    -- Default position if not set
    if not config.angle then
        config.angle = 200 -- Default angle
    end
    
    local angle = math.rad(config.angle)
    local x = math.cos(angle) * 100
    local y = math.sin(angle) * 100
    
    minimapButton:ClearAllPoints()
    minimapButton:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

-- Drag handling
minimapButton:SetScript("OnDragStart", function(self)
    self.isDragging = true
    self:SetScript("OnUpdate", function(self)
        local mx, my = Minimap:GetCenter()
        local px, py = GetCursorPosition()
        local scale = Minimap:GetEffectiveScale()
        px, py = px / scale, py / scale
        
        local angle = math.deg(math.atan2(py - my, px - mx))
        if angle < 0 then
            angle = angle + 360
        end
        
        if not ProfessionTrackerDB then
            ProfessionTrackerDB = {}
        end
        ProfessionTrackerDB.minimapButton = ProfessionTrackerDB.minimapButton or {}
        ProfessionTrackerDB.minimapButton.angle = angle
        
        UpdatePosition()
    end)
end)

minimapButton:SetScript("OnDragStop", function(self)
    self.isDragging = false
    self:SetScript("OnUpdate", nil)
end)

-- Initialize position on load
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, loadedAddon)
    if loadedAddon == "ProfessionTracker" then
        UpdatePosition()
        self:UnregisterEvent("ADDON_LOADED")
    end
end)

-- Make globally accessible
ProfessionTrackerMinimapButton = minimapButton

print("|cff00ff00[Profession Tracker]|r Minimap button loaded")
