local _, XPM = ...
local Main = XPM.Main

local Module = Main:NewModule("ClassicFramesMods", "AceHook-3.0", "AceEvent-3.0")

function Module:OnEnable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:OnDisable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:GetDescription()
    return "This module adds some basic options to the retail addon Classic Frames."
end

function Module:GetName()
    return "Classic Frames Mods"
end

function Module:GetOptions(myOptionsTable, db)
    self.db = db
    local defaults = {
        classicFramesHealthBarColor = true,
        classicFramesHideNameBackground = true,
        classicFramesHidePvpIcon = true,
        classicFramesHidePlayerGroupNumber = true,
        classicFramesSilverDragon = true,
        classicFramesGoldenDragon = false
    }
    for key, value in pairs(defaults) do
        if self.db[key] == nil then
            self.db[key] = value
        end
    end

    local get = function(info)
        return self.db[info[#info]]
    end
    local set = function(info, value)
        local setting = info[#info]
        self.db[setting] = value

        if setting == "classicFramesHealthBarColor" then
            self:RefreshUI()
        end
        if setting == "classicFramesHideNameBackground" then
            self:RefreshUI()
        end
        if setting == "classicFramesHidePvpIcon" then
            self:RefreshUI()
        end
        if setting == "classicFramesHidePlayerGroupNumber" then
            self:RefreshUI()
        end
        if setting == "classicFramesSilverDragon" then
            self.db.classicFramesGoldenDragon = false
            self:RefreshUI()
        end
        if setting == "classicFramesGoldenDragon" then
            self.db.classicFramesSilverDragon = false
            self:RefreshUI()
        end
    end

    local counter = CreateCounter(5)

    myOptionsTable.args.classicFramesOptionsGroup = {
        order = counter(),
        name = "Classic Frames Mods Options",
        type = "group",
        inline = true, --inline makes it a normal group. else it is a tab group (myOptionsTable in core.lua)
        args = {
            reloadExecute = {
                type = "execute",
                name = "/reload",
                desc = "",
                width = 0.45,
                func = function()
                    ReloadUI()
                end,
                order = counter()
            },
            classicFramesHealthBarColor = {
                type = "toggle",
                name = "Class Colored Health Bar",
                desc = "This changes the color of your unit frames health bar to match their respective class",
                order = counter(),
                width = "full",
                get = get,
                set = set
            },
            classicFramesHideNameBackground = {
                type = "toggle",
                name = "Hide Name Background",
                desc = "This hides the colored background that indicates whether if you or your target/focus is friendly or hostile",
                order = counter(),
                width = "full",
                get = get,
                set = set
            },
            classicFramesHidePvpIcon = {
                type = "toggle",
                name = "Hide PvP Icon",
                desc = "This hides the pvp icon that indicates whether if you or your target/focus is pvp flagged or not",
                order = counter(),
                width = "full",
                get = get,
                set = set
            },
            classicFramesHidePlayerGroupNumber = {
                type = "toggle",
                name = "Hide Player Group Number",
                desc = "This hides the group number indicator that shows up when you are in a group",
                order = counter(),
                width = "full",
                get = get,
                set = set
            },
            classicFramesSilverDragon = {
                type = "toggle",
                name = "Silver Dragon Player Portrait",
                desc = "This adds the rare texture to the player portrait",
                order = counter(),
                width = "full",
                get = get,
                set = set
            },
            classicFramesGoldenDragon = {
                type = "toggle",
                name = "Golden Dragon Player Portrait",
                desc = "This adds the elite texture to the player portrait",
                order = counter(),
                width = "full",
                get = get,
                set = set
            }
        }
    }

    return myOptionsTable
end

function Module:ClassicFramesHealthBarColor()
    local enabled
    if self:IsEnabled() then
        enabled = self.db.classicFramesHealthBarColor
    else
        enabled = false
    end
    local playerHealthBar = CfPlayerFrameHealthBar
    local targetFrameHealthBar = CfTargetFrameHealthBar
    local focusFrameHealthBar = CfFocusFrameHealthBar

    local function eventHandler(self, event, ...)
        if enabled then
            local unitPlayer, englishClassPlayer = UnitClass("player")

            local playerColor = {r = 0, g = 1, b = 0, a = 1}
            if unitPlayer then
                playerColor.r, playerColor.g, playerColor.b = GetClassColor(englishClassPlayer)

                if playerHealthBar:GetStatusBarColor() ~= playerColor then
                    playerHealthBar:SetStatusBarColor(playerColor.r, playerColor.g, playerColor.b)
                end
            end
        end
    end
    local function eventHandlerTarget()
        if enabled then
            local unitTarget, englishClassTarget = UnitClass("target")

            local targetColor = {r = 0, g = 1, b = 0, a = 1}
            if unitTarget then
                if UnitIsPlayer("target") then
                    targetColor.r, targetColor.g, targetColor.b = GetClassColor(englishClassTarget)
                end

                if targetFrameHealthBar:GetStatusBarColor() ~= targetColor then
                    targetFrameHealthBar:SetStatusBarColor(targetColor.r, targetColor.g, targetColor.b)
                end
            end
        end
    end
    local function eventHandlerFocus()
        if enabled then
            local unitFocus, englishClassFocus = UnitClass("focus")

            local focusColor = {r = 0, g = 1, b = 0, a = 1}
            if unitFocus then
                if UnitIsPlayer("focus") then
                    focusColor.r, focusColor.g, focusColor.b = GetClassColor(englishClassFocus)
                end

                if focusFrameHealthBar:GetStatusBarColor() ~= focusColor then
                    focusFrameHealthBar:SetStatusBarColor(focusColor.r, focusColor.g, focusColor.b)
                end
            end
        end
    end

    PlayerFrame:HookScript("OnUpdate", function(self)
        eventHandler()
    end)

    self:SecureHook(TargetFrame, "OnUpdate", function()
        eventHandlerTarget()
    end)

    self:SecureHook(FocusFrame, "OnUpdate", function()
        eventHandlerFocus()
    end)

    --[[
    hooksecurefunc("HealthBar_OnValueChanged", function (self)
        if self.unit == "player" then
            eventHandler()
        end
    end)

    hooksecurefunc("UnitFrameHealthBar_Update", function (self)
        if self.unit == "player" then
            eventHandler()
        end
    end)

    hooksecurefunc("UnitFrameHealthBar_OnUpdate", function (self)
        if self.unit == "player" then
            eventHandler()
        end
    end)

    hooksecurefunc("PlayerFrame_OnUpdate", function (self)
        eventHandler()
    end)

    hooksecurefunc("PlayerFrame_OnEvent", function (self)
        eventHandler()
        C_Timer.After(1, function() eventHandler() end)
    end)
    ]]--

    --[[
    local frame = CreateFrame("FRAME")
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:RegisterEvent("UNIT_MAX_HEALTH_MODIFIERS_CHANGED")
    frame:RegisterEvent("UNIT_PORTRAIT_UPDATE")
    frame:RegisterEvent("GROUP_ROSTER_UPDATE")
    frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    frame:RegisterEvent("UNIT_FACTION")
    frame:RegisterEvent("PLAYER_TARGET_CHANGED")
    frame:RegisterEvent("PLAYER_FOCUS_CHANGED")

    frame:SetScript("OnEvent", eventHandler)
    ]]--
end

function Module:ClassicFramesHideNameBackground()
    local function enabled()
        if self:IsEnabled() then
            return self.db.classicFramesHideNameBackground
        else
            return false
        end
    end

    local frame = CreateFrame("FRAME")
    local function eventHandler(self, event, ...)

        local targetNameBackground = TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor
        if targetNameBackground and enabled() then
            targetNameBackground:SetVertexColor(0, 0, 0, 0.5)
        end

        local focusNameBackground = FocusFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor
        if focusNameBackground and enabled() then
            focusNameBackground:SetVertexColor(0, 0, 0, 0.5)
        end
    end

    frame:RegisterEvent("GROUP_ROSTER_UPDATE")
    frame:RegisterEvent("PLAYER_TARGET_CHANGED")
    frame:RegisterEvent("PLAYER_FOCUS_CHANGED")
    frame:RegisterEvent("UNIT_FACTION")

    frame:SetScript("OnEvent", eventHandler)
end

function Module:ClassicFramesHidePvpIcon()
    local enabled
    if self:IsEnabled() then
        enabled = self.db.classicFramesHidePvpIcon
    else
        enabled = false
    end

    local playerPvpIcon = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigePortrait
    local playerPvpIcon2 = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigeBadge
    local playerPvpIcon3 = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PvpIcon
    local targetPvpIcon = TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigePortrait
    local targetPvpIcon2 = TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigeBadge
    local targetPvpIcon3 = TargetFrame.TargetFrameContent.TargetFrameContentContextual.PvpIcon
    local focusPvpIcon = FocusFrame.TargetFrameContent.TargetFrameContentContextual.PrestigePortrait
    local focusPvpIcon2 = FocusFrame.TargetFrameContent.TargetFrameContentContextual.PrestigeBadge
    local focusPvpIcon3 = FocusFrame.TargetFrameContent.TargetFrameContentContextual.PvpIcon
    if enabled then
        if playerPvpIcon and playerPvpIcon2 then
            playerPvpIcon:SetAlpha(0)
            playerPvpIcon2:SetAlpha(0)
        end
        if playerPvpIcon3 then
            playerPvpIcon3:SetAlpha(0)
        end
        if targetPvpIcon and targetPvpIcon2 then
            targetPvpIcon:SetAlpha(0)
            targetPvpIcon2:SetAlpha(0)
        end
        if targetPvpIcon3 then
            targetPvpIcon3:SetAlpha(0)
        end
        if focusPvpIcon and focusPvpIcon2 then
            focusPvpIcon:SetAlpha(0)
            focusPvpIcon2:SetAlpha(0)
        end
        if focusPvpIcon3 then
            focusPvpIcon3:SetAlpha(0)
        end
    else
        if playerPvpIcon and playerPvpIcon2 then
            playerPvpIcon:SetAlpha(1)
            playerPvpIcon2:SetAlpha(1)
        end
        if playerPvpIcon3 then
            playerPvpIcon3:SetAlpha(1)
        end
        if targetPvpIcon and targetPvpIcon2 then
            targetPvpIcon:SetAlpha(1)
            targetPvpIcon2:SetAlpha(1)
        end
        if targetPvpIcon3 then
            targetPvpIcon3:SetAlpha(1)
        end
        if focusPvpIcon and focusPvpIcon2 then
            focusPvpIcon:SetAlpha(1)
            focusPvpIcon2:SetAlpha(1)
        end
        if focusPvpIcon3 then
            focusPvpIcon3:SetAlpha(1)
        end
    end
end

function Module:ClassicFramesHidePlayerGroupNumber()
    local enabled
    if self:IsEnabled() then
        enabled = self.db.classicFramesHidePlayerGroupNumber
    else
        enabled = false
    end

    local playerGroupIndicator1, playerGroupIndicator2, playerGroupIndicator3, playerGroupIndicator4 = PlayerFrameGroupIndicatorText, PlayerFrameGroupIndicatorLeft, PlayerFrameGroupIndicatorMiddle, PlayerFrameGroupIndicatorRight
    if enabled then
        if playerGroupIndicator1 then
            playerGroupIndicator1:SetAlpha(0)
            playerGroupIndicator2:SetAlpha(0)
            playerGroupIndicator3:SetAlpha(0)
            playerGroupIndicator4:SetAlpha(0)
        end
    else
        if playerGroupIndicator1 then
            playerGroupIndicator1:SetAlpha(1)
            playerGroupIndicator2:SetAlpha(1)
            playerGroupIndicator3:SetAlpha(1)
            playerGroupIndicator4:SetAlpha(1)
        end
    end
end

function Module:ClassicFramesSilverDragon()
    local enabled
    if self:IsEnabled() then
        enabled = self.db.classicFramesSilverDragon
    else
        enabled = false
    end

    if enabled then
        local SilverDragonTexture = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual:CreateTexture(nil, "BACKGROUND", nil, 0)

        PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.FrameTexture = SilverDragonTexture

        SilverDragonTexture:SetSize(232, 100)

        SilverDragonTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Rare-Elite")
        SilverDragonTexture:SetTexCoord(1, 0.09375, 0, 0.78125)
        SilverDragonTexture:SetDesaturated(true)
        SilverDragonTexture:ClearAllPoints()
        SilverDragonTexture:SetPoint("TOPLEFT", -19, -4)
    end
end

function Module:ClassicFramesGoldenDragon()
    local enabled
    if self:IsEnabled() then
        enabled = self.db.classicFramesGoldenDragon
    else
        enabled = false
    end

    if enabled then
        local GoldenDragonTexture = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual:CreateTexture(nil, "BACKGROUND", nil, 0)

        PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.FrameTexture = GoldenDragonTexture

        GoldenDragonTexture:SetSize(232, 100)

        GoldenDragonTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Elite")
        GoldenDragonTexture:SetTexCoord(1, 0.09375, 0, 0.78125)
        GoldenDragonTexture:ClearAllPoints()
        GoldenDragonTexture:SetPoint("TOPLEFT", -19, -4)
    end
end

function Module:SetupUI()
    if self:IsEnabled() then
        self:ClassicFramesHealthBarColor()
        self:ClassicFramesHideNameBackground()
        self:ClassicFramesHidePvpIcon()
        self:ClassicFramesHidePlayerGroupNumber()
        self:ClassicFramesSilverDragon()
        self:ClassicFramesGoldenDragon()
    end
end

function Module:RefreshUI()
    if self:IsEnabled() then
        self:Disable()
        self:Enable()
    end
end

function Module:CheckConditions()
    self:SetupUI()
end

function Module:IsAvailableForCurrentVersion()
    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
        if C_AddOns.IsAddOnLoaded("ClassicFrames") then
            return true -- retail
        else
            return false -- retail
        end
    elseif WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC then
        return false -- cata
    elseif WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        return false -- vanilla
    end
end