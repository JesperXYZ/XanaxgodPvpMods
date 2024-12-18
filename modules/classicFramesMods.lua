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
        classicFramesColoredNameBackground = false,
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
        if setting == "classicFramesColoredNameBackground" then
            self:RefreshUI()
            self.db.classicFramesHideNameBackground = false
        end
        if setting == "classicFramesHideNameBackground" then
            self:RefreshUI()
            self.db.classicFramesColoredNameBackground = false
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
                desc = "You should reload your UI after changing options for this module.",
                width = 0.45,
                func = function()
                    ReloadUI()
                end,
                order = counter()
            },
            classicFramesHealthBarColor = {
                type = "toggle",
                name = "Class Colored Health Bar",
                desc = "This changes the color of your unit frames health bar to match their respective class (including target of target)",
                order = counter(),
                width = "full",
                get = get,
                set = set
            },
            classicFramesColoredNameBackground = {
                type = "toggle",
                name = "Class Colored Name Background",
                desc = "This changes the color of your unit frames name background to match their respective class",
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
    local targetTargetFrameHealthBar = TargetFrameToT.HealthBar
    local focusTargetFrameHealthBar = FocusFrameToT.HealthBar

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
    local function eventHandlerTargetOfTarget()
        if enabled then
            local unitTarget, englishClassTarget = UnitClass("targettarget")

            local targetColor = {r = 0, g = 1, b = 0, a = 1}
            if unitTarget then
                if UnitIsPlayer("targettarget") then
                    targetColor.r, targetColor.g, targetColor.b = GetClassColor(englishClassTarget)
                end

                if targetTargetFrameHealthBar:GetStatusBarColor() ~= targetColor then
                    targetTargetFrameHealthBar:SetStatusBarColor(targetColor.r, targetColor.g, targetColor.b)
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
    local function eventHandlerTargetOfFocus()
        if enabled then
            local unitFocus, englishClassFocus = UnitClass("focustarget")

            local focusColor = {r = 0, g = 1, b = 0, a = 1}
            if unitFocus then
                if UnitIsPlayer("focustarget") then
                    focusColor.r, focusColor.g, focusColor.b = GetClassColor(englishClassFocus)
                end

                if focusTargetFrameHealthBar:GetStatusBarColor() ~= focusColor then
                    focusTargetFrameHealthBar:SetStatusBarColor(focusColor.r, focusColor.g, focusColor.b)
                end
            end
        end
    end

    PlayerFrame:HookScript("OnUpdate", function(self)
        eventHandler()
    end)

    local ToTEnabled

    if GetCVar("showTargetOfTarget") == "1" then
        ToTEnabled = true
    else
        ToTEnabled = false
    end

    self:SecureHook(TargetFrame, "OnUpdate", function()
        eventHandlerTarget()
        if ToTEnabled then
            eventHandlerTargetOfTarget()
        end
    end)

    self:SecureHook(FocusFrame, "OnUpdate", function()
        eventHandlerFocus()
        if ToTEnabled then
            eventHandlerTargetOfFocus()
        end
    end)
end

function Module:ClassicFramesColoredNameBackground()
    local function enabled()
        if self:IsEnabled() then
            return self.db.classicFramesColoredNameBackground
        else
            return false
        end
    end


    if enabled() then
        local unitPlayer, englishClassPlayer = UnitClass("player")

        local playerColor = {r = 0, g = 1, b = 0, a = 1}
        if unitPlayer then
            playerColor.r, playerColor.g, playerColor.b = GetClassColor(englishClassPlayer)

            local BackgroundTexture = UIParent:CreateTexture(nil, "BACKGROUND", "TextStatusBar", -8)

            BackgroundTexture:SetParent(PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual)

            BackgroundTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-LevelBackground")

            BackgroundTexture:ClearAllPoints()
            BackgroundTexture:SetPoint("TOPRIGHT", -26, -26)
            BackgroundTexture:SetSize(119, 19)

            BackgroundTexture:SetVertexColor(playerColor.r, playerColor.g, playerColor.b, playerColor.a)

            local PlayerName = UIParent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")

            PlayerName:SetParent(PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual)


            PlayerName:SetFontObject(GameFontNormalSmall)
            PlayerName:ClearAllPoints()
            PlayerName:SetPoint("TOPRIGHT", -26, -27.5)
            PlayerName:SetSize(119, 19)

            PlayerName:SetText(UnitName("player"))

            if (not self.db.classicFramesSilverDragon) and (not self.db.classicFramesGoldenDragon) then
                local Texture = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual:CreateTexture(nil, "BACKGROUND", nil, 0)

                PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.FrameTexture = Texture

                PlayerFrame.PlayerFrameContainer.FrameTexture:SetAlpha(0)

                Texture:SetSize(232, 100)

                Texture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame")
                Texture:SetTexCoord(1, 0.09375, 0, 0.78125)
                Texture:SetDesaturated(true)
                Texture:ClearAllPoints()
                Texture:SetPoint("TOPLEFT", -19, -4)

                self:TextureHelper()
            end
        end
    end

    local frame = CreateFrame("FRAME")
    local function eventHandler(self, event, ...)

        local targetNameBackground = TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor
        if targetNameBackground and enabled() then
            local unitPlayer, englishClassPlayer = UnitClass("target")

            local targetColor = {r = 0, g = 1, b = 0, a = 1}
            if unitPlayer then
                if UnitIsPlayer("target") then
                    targetColor.r, targetColor.g, targetColor.b = GetClassColor(englishClassPlayer)
                end

                if targetNameBackground:GetVertexColor() ~= targetColor then
                    targetNameBackground:SetVertexColor(targetColor.r, targetColor.g, targetColor.b, 1)
                end
            end
        end

        local focusNameBackground = FocusFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor
        if focusNameBackground and enabled() then
            local unitPlayer, englishClassPlayer = UnitClass("focus")

            local focusColor = {r = 0, g = 1, b = 0, a = 1}
            if unitPlayer then
                if UnitIsPlayer("focus") then
                    focusColor.r, focusColor.g, focusColor.b = GetClassColor(englishClassPlayer)
                end

                if focusNameBackground:GetVertexColor() ~= focusColor then
                    focusNameBackground:SetVertexColor(focusColor.r, focusColor.g, focusColor.b, 1)
                end
            end
        end
    end

    frame:RegisterEvent("GROUP_ROSTER_UPDATE")
    frame:RegisterEvent("PLAYER_TARGET_CHANGED")
    frame:RegisterEvent("PLAYER_FOCUS_CHANGED")
    frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    frame:RegisterEvent("UNIT_FACTION")

    frame:SetScript("OnEvent", eventHandler)
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
    local playerPvpIcon3 = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PVPIcon
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
        if playerGroupIndicator1 and playerGroupIndicator2 and playerGroupIndicator3 and playerGroupIndicator4 then
            playerGroupIndicator1:SetAlpha(0)
            playerGroupIndicator2:SetAlpha(0)
            playerGroupIndicator3:SetAlpha(0)
            playerGroupIndicator4:SetAlpha(0)
        end
    else
        if playerGroupIndicator1 and playerGroupIndicator2 and playerGroupIndicator3 and playerGroupIndicator4 then
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

        PlayerFrame.PlayerFrameContainer.FrameTexture:SetAlpha(0)

        SilverDragonTexture:SetSize(232, 100)

        SilverDragonTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Rare-Elite")
        SilverDragonTexture:SetTexCoord(1, 0.09375, 0, 0.78125)
        SilverDragonTexture:SetDesaturated(true)
        SilverDragonTexture:ClearAllPoints()
        SilverDragonTexture:SetPoint("TOPLEFT", -19, -4)

        self:TextureHelper()
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

        PlayerFrame.PlayerFrameContainer.FrameTexture:SetAlpha(0)

        GoldenDragonTexture:SetSize(232, 100)

        GoldenDragonTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Elite")
        GoldenDragonTexture:SetTexCoord(1, 0.09375, 0, 0.78125)
        GoldenDragonTexture:ClearAllPoints()
        GoldenDragonTexture:SetPoint("TOPLEFT", -19, -4)

        self:TextureHelper()
    end
end

function Module:TextureHelper()
    local Texture2 = TargetFrame.TargetFrameContent.TargetFrameContentMain:CreateTexture(nil, "BACKGROUND", nil, 0)

    TargetFrame.TargetFrameContent.TargetFrameContentMain.FrameTexture = Texture2

    Texture2:SetSize(232, 100)

    Texture2:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame")
    Texture2:SetTexCoord(0.09375, 1, 0, 0.78125)
    Texture2:SetDesaturated(true)
    Texture2:ClearAllPoints()
    Texture2:SetPoint("TOPLEFT", 20, -4)


    local Texture3 = FocusFrame.TargetFrameContent.TargetFrameContentMain:CreateTexture(nil, "BACKGROUND", nil, 0)

    FocusFrame.TargetFrameContent.TargetFrameContentMain.FrameTexture = Texture3

    Texture3:SetSize(232, 100)

    Texture3:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame")
    Texture3:SetTexCoord(0.09375, 1, 0, 0.78125)
    Texture3:SetDesaturated(true)
    Texture3:ClearAllPoints()
    Texture3:SetPoint("TOPLEFT", 20, -4)
end

function Module:SetupUI()
    if self:IsEnabled() then
        self:ClassicFramesHealthBarColor()
        self:ClassicFramesColoredNameBackground()
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
