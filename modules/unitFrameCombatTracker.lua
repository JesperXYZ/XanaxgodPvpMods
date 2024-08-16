local _, XPM = ...
local Main = XPM.Main

local Module = Main:NewModule("UnitFrameCombatTracker", "AceHook-3.0", "AceEvent-3.0")

function Module:OnEnable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:OnDisable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:GetDescription()
    return "This module displays an icon on the TargetFrame/FocusFrame to indicate whether your current target/focus is in combat or not. This only tracks hostile targets."
end

function Module:GetName()
    return "Unit Frame Combat Tracker"
end

function Module:GetOptions(myOptionsTable, db)
    self.db = db
    local defaults = {
        classConditionsAll = false,
        classConditionsRmp = true,
        classConditionsRogue = false,
        outOfCombatTrackerToggle = true,
        outOfCombatTrackerPlayersOnlyToggle = true,
        outOfCombatTrackerOpacity = 1,
        outOfCombatTrackerSize = 2,
        outOfCombatTrackerXOffset = 20,
        outOfCombatTrackerYOffset = 2,
        inCombatTrackerToggle = true,
        inCombatTrackerPlayersOnlyToggle = true,
        inCombatTrackerOpacity = 0.7,
        inCombatTrackerSize = 2,
        inCombatTrackerXOffset = 20,
        inCombatTrackerYOffset = 2
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

        if setting == "classConditionsAll" then
            if not (self.db.classConditionsAll or self.db.classConditionsRmp or self.db.classConditionsRogue) then
                self.db.classConditionsAll = true
            end
            if self.db.classConditionsRmp then
                self.db.classConditionsRmp = false
            end
            if self.db.classConditionsRogue then
                self.db.classConditionsRogue = false
            end
            self:RefreshUI()
        end
        if setting == "classConditionsRmp" then
            if not (self.db.classConditionsAll or self.db.classConditionsRmp or self.db.classConditionsRogue) then
                self.db.classConditionsRmp = true
            end
            if self.db.classConditionsAll then
                self.db.classConditionsAll = false
            end
            if self.db.classConditionsRogue then
                self.db.classConditionsRogue = false
            end
            self:RefreshUI()
        end
        if setting == "classConditionsRogue" then
            if not (self.db.classConditionsAll or self.db.classConditionsRmp or self.db.classConditionsRogue) then
                self.db.classConditionsRogue = true
            end
            if self.db.classConditionsAll then
                self.db.classConditionsAll = false
            end
            if self.db.classConditionsRmp then
                self.db.classConditionsRmp = false
            end
            self:RefreshUI()
        end
        if setting == "outOfCombatTrackerToggle" then
            self:RefreshUI()
        end
        if setting == "outOfCombatTrackerPlayersOnlyToggle" then
            self:RefreshUI()
        end
        if setting == "outOfCombatTrackerOpacity" then
            self:RefreshUI()
        end
        if setting == "outOfCombatTrackerSize" then
            self:RefreshUI()
        end
        if setting == "outOfCombatTrackerXOffset" then
            self:RefreshUI()
        end
        if setting == "outOfCombatTrackerYOffset" then
            self:RefreshUI()
        end
        if setting == "inCombatTrackerToggle" then
            self:RefreshUI()
        end
        if setting == "inCombatTrackerPlayersOnlyToggle" then
            self:RefreshUI()
        end
        if setting == "inCombatTrackerOpacity" then
            self:RefreshUI()
        end
        if setting == "inCombatTrackerSize" then
            self:RefreshUI()
        end
        if setting == "inCombatTrackerXOffset" then
            self:RefreshUI()
        end
        if setting == "inCombatTrackerYOffset" then
            self:RefreshUI()
        end
    end
    local counter = CreateCounter(5)

    local UnitFrameCombatTrackerImage =
    "|TInterface\\Addons\\XanaxgodPvpMods\\media\\moduleImages\\UnitFrameCombatTracker:119:474:1:-10|t"

    myOptionsTable.args.classConditionsGroup = {
        order = counter(),
        name = "Class Conditions",
        type = "group",
        inline = true,
        args = {
            classConditionsDesc = {
                order = counter(),
                type = "description",
                name = "Enable/disable this module based on the class you are currently playing.",
                width = "full"
            },
            classConditionsAll = {
                type = "toggle",
                name = "All Classes",
                desc = "Toggle to enable this module for all classes.",
                order = counter(),
                width = 0.57,
                get = get,
                set = set
            },
            classConditionsRmp = {
                type = "toggle",
                name = "Rogue/Mage/Priest",
                desc = "Toggle to enable this module for Rogues, Mages, and Priests only.",
                order = counter(),
                width = 0.9,
                get = get,
                set = set
            },
            classConditionsRogue = {
                type = "toggle",
                name = "Rogue Only",
                desc = "Toggle to enable this module only for the Rogue class.",
                order = counter(),
                width = 0.65,
                get = get,
                set = set
            }
        }
    }
    myOptionsTable.args.outOfCombatTrackerGroup = {
        order = counter(),
        name = "Out of Combat Icon",
        type = "group",
        --inline = true,
        args = {
            outOfCombatTrackerToggle = {
                type = "toggle",
                name = "Enable",
                desc = "Toggle to enable/disable the out-of-combat icon.",
                order = counter(),
                width = 0.6,
                get = get,
                set = set
            },
            outOfCombatTrackerPlayersOnlyToggle = {
                type = "toggle",
                name = "Track players only",
                desc = "Toggle to only show the out-of-combat icon on players.",
                order = counter(),
                width = 1.4,
                get = get,
                set = set
            },
            outOfCombatTrackerOpacity = {
                type = "range",
                name = "Icon Opacity",
                desc = "Adjust the opacity of the out-of-combat icon.",
                order = counter(),
                min = 0,
                max = 1,
                step = 0.01,
                width = 1.1,
                get = get,
                set = set
            },
            outOfCombatTrackerSize = {
                type = "range",
                name = "Icon Size",
                desc = "Adjust the size of the out-of-combat icon.",
                order = counter(),
                min = 1,
                max = 5,
                step = 0.1,
                width = 1.1,
                get = get,
                set = set
            },
            outOfCombatTrackerXOffset = {
                type = "range",
                name = "Icon x-Offset",
                desc = "Adjust the horizontal position of the out-of-combat icon.",
                order = counter(),
                min = -100,
                max = 100,
                step = 1,
                width = 1.1,
                get = get,
                set = set
            },
            outOfCombatTrackerYOffset = {
                type = "range",
                name = "Icon y-Offset",
                desc = "Adjust the vertical position of the out-of-combat icon.",
                order = counter(),
                min = -100,
                max = 100,
                step = 1,
                width = 1.1,
                get = get,
                set = set
            },
            art321123 = {
                order = counter(),
                type = "description",
                name = "" .. UnitFrameCombatTrackerImage,
                width = "full"
            }
        }
    }
    myOptionsTable.args.inCombatTrackerGroup = {
        order = counter(),
        name = "In Combat Icon",
        type = "group",
        --inline = true,
        args = {
            inCombatTrackerToggle = {
                type = "toggle",
                name = "Enable",
                desc = "Toggle to enable/disable the in-combat icon.",
                order = counter(),
                width = 0.6,
                get = get,
                set = set
            },
            inCombatTrackerPlayersOnlyToggle = {
                type = "toggle",
                name = "Track players only",
                desc = "Toggle to only show the in-combat icon on players.",
                order = counter(),
                width = 1.4,
                get = get,
                set = set
            },
            inCombatTrackerOpacity = {
                type = "range",
                name = "Icon Opacity",
                desc = "Adjust the opacity of the in-combat icon.",
                order = counter(),
                min = 0,
                max = 1,
                step = 0.01,
                width = 1.1,
                get = get,
                set = set
            },
            inCombatTrackerSize = {
                type = "range",
                name = "Icon Size",
                desc = "Adjust the size of the in-combat icon.",
                order = counter(),
                min = 1,
                max = 5,
                step = 0.1,
                width = 1.1,
                get = get,
                set = set
            },
            inCombatTrackerXOffset = {
                type = "range",
                name = "Icon x-Offset",
                desc = "Adjust the horizontal position of the in-combat icon.",
                order = counter(),
                min = -100,
                max = 100,
                step = 1,
                width = 1.1,
                get = get,
                set = set
            },
            inCombatTrackerYOffset = {
                type = "range",
                name = "Icon y-Offset",
                desc = "Adjust the vertical position of the in-combat icon.",
                order = counter(),
                min = -100,
                max = 100,
                step = 1,
                width = 1.1,
                get = get,
                set = set
            },
            art321123 = {
                order = counter(),
                type = "description",
                name = "" .. UnitFrameCombatTrackerImage,
                width = "full"
            }
        }
    }

    return myOptionsTable
end

function Module:TargetOutOfCombat()
    if not UnitAffectingCombat("target") and not UnitIsFriend("player", "target") and UnitHealth("target") > 0 then
        if self.db.outOfCombatTrackerPlayersOnlyToggle and (not UnitIsPlayer("target")) then
            outOfCombatTargetFrame:Hide()
        else
            outOfCombatTargetFrame:Show()
        end
    else
        outOfCombatTargetFrame:Hide()
    end
end

function Module:FocusOutOfCombat()
    if not UnitAffectingCombat("focus") and not UnitIsFriend("player", "focus") and UnitHealth("focus") > 0 then
        if self.db.outOfCombatTrackerPlayersOnlyToggle and (not UnitIsPlayer("focus")) then
            outOfCombatFocusFrame:Hide()
        else
            outOfCombatFocusFrame:Show()
        end
    else
        outOfCombatFocusFrame:Hide()
    end
end

function Module:TargetInCombat()
    if UnitAffectingCombat("target") and not UnitIsFriend("player", "target") and UnitHealth("target") > 0 then
        if self.db.inCombatTrackerPlayersOnlyToggle and (not UnitIsPlayer("target")) then
            inCombatTargetFrame:Hide()
        else
            inCombatTargetFrame:Show()
        end
    else
        inCombatTargetFrame:Hide()
    end
end

function Module:FocusInCombat()
    if UnitAffectingCombat("focus") and not UnitIsFriend("player", "focus") and UnitHealth("focus") > 0 then
        if self.db.inCombatTrackerPlayersOnlyToggle and (not UnitIsPlayer("focus")) then
            inCombatFocusFrame:Hide()
        else
            inCombatFocusFrame:Show()
        end
    else
        inCombatFocusFrame:Hide()
    end
end

function Module:Adjustments()
    if outOfCombatTargetFrame and outOfCombatFocusFrame then
        outOfCombatTargetFrame:SetWidth(16 * self.db.outOfCombatTrackerSize)
        outOfCombatTargetFrame:SetHeight(16 * self.db.outOfCombatTrackerSize)
        outOfCombatTargetFrame:SetAlpha(self.db.outOfCombatTrackerOpacity)
        outOfCombatTargetFrame:SetPoint("RIGHT", 0 + self.db.outOfCombatTrackerXOffset, 0 + self.db.outOfCombatTrackerYOffset)

        outOfCombatFocusFrame:SetWidth(16 * self.db.outOfCombatTrackerSize)
        outOfCombatFocusFrame:SetHeight(16 * self.db.outOfCombatTrackerSize)
        outOfCombatFocusFrame:SetAlpha(self.db.outOfCombatTrackerOpacity)
        outOfCombatFocusFrame:SetPoint("RIGHT", 0 + self.db.outOfCombatTrackerXOffset, 0 + self.db.outOfCombatTrackerYOffset)
    end

    if inCombatTargetFrame and inCombatFocusFrame then
        inCombatTargetFrame:SetWidth(16 * self.db.inCombatTrackerSize)
        inCombatTargetFrame:SetHeight(16 * self.db.inCombatTrackerSize)
        inCombatTargetFrame:SetAlpha(self.db.inCombatTrackerOpacity)
        inCombatTargetFrame:SetPoint("RIGHT", 0 + self.db.inCombatTrackerXOffset, 0 + self.db.inCombatTrackerYOffset)

        inCombatFocusFrame:SetWidth(16 * self.db.inCombatTrackerSize)
        inCombatFocusFrame:SetHeight(16 * self.db.inCombatTrackerSize)
        inCombatFocusFrame:SetAlpha(self.db.inCombatTrackerOpacity)
        inCombatFocusFrame:SetPoint("RIGHT", 0 + self.db.inCombatTrackerXOffset, 0 + self.db.inCombatTrackerYOffset)
    end

    if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        if outOfCombatTargetFrame then
            outOfCombatTargetFrame:SetWidth(16 * self.db.outOfCombatTrackerSize)
            outOfCombatTargetFrame:SetHeight(16 * self.db.outOfCombatTrackerSize)
            outOfCombatTargetFrame:SetAlpha(self.db.outOfCombatTrackerOpacity)
            outOfCombatTargetFrame:SetPoint("RIGHT", 0 + self.db.outOfCombatTrackerXOffset, 0 + self.db.outOfCombatTrackerYOffset)
        end
        if inCombatTargetFrame then
            inCombatTargetFrame:SetWidth(16 * self.db.inCombatTrackerSize)
            inCombatTargetFrame:SetHeight(16 * self.db.inCombatTrackerSize)
            inCombatTargetFrame:SetAlpha(self.db.inCombatTrackerOpacity)
            inCombatTargetFrame:SetPoint("RIGHT", 0 + self.db.inCombatTrackerXOffset, 0 + self.db.inCombatTrackerYOffset)
        end
    end
end

function Module:SetupUI()
    if self.db.outOfCombatTrackerToggle then
        if not outOfCombatTargetFrame and not outOfCombatFocusFrame then
            if C_AddOns.IsAddOnLoaded("JaxClassicFrames") then
                outOfCombatTargetFrame = CreateFrame("Frame", "outOfCombatTargetFrame", JcfTargetFrame)
            else
                outOfCombatTargetFrame = CreateFrame("Frame", "outOfCombatTargetFrame", TargetFrame)
            end
            outOfCombatTargetFrame:SetFrameStrata("BACKGROUND")
            outOfCombatTargetFrame:SetWidth(16)
            outOfCombatTargetFrame:SetHeight(16)

            outOfCombatTargetFrame:SetPoint("RIGHT", 20, 0)

            outOfCombatTargetFrame.texture = outOfCombatTargetFrame:CreateTexture(nil, BORDER)
            outOfCombatTargetFrame.texture:SetAllPoints()
            outOfCombatTargetFrame.texture:SetTexture("Interface\\Icons\\ability_sap") -- Replace with the desired ability icon path

            outOfCombatTargetFrame:Hide()

            if C_AddOns.IsAddOnLoaded("JaxClassicFrames") then
                outOfCombatFocusFrame = CreateFrame("Frame", "outOfCombatFocusFrame", JcfFocusFrame)
            else
                outOfCombatFocusFrame = CreateFrame("Frame", "outOfCombatFocusFrame", FocusFrame)
            end
            outOfCombatFocusFrame:SetFrameStrata("BACKGROUND")
            outOfCombatFocusFrame:SetWidth(16)
            outOfCombatFocusFrame:SetHeight(16)

            outOfCombatFocusFrame:SetPoint("RIGHT", 20, 0)

            outOfCombatFocusFrame.texture = outOfCombatFocusFrame:CreateTexture(nil, BORDER)
            outOfCombatFocusFrame.texture:SetAllPoints()
            outOfCombatFocusFrame.texture:SetTexture("Interface\\Icons\\ability_sap") -- Replace with the desired ability icon path

            outOfCombatFocusFrame:Hide()
        end
    else
        if outOfCombatTargetFrame and outOfCombatFocusFrame then
            outOfCombatTargetFrame:Hide()
            outOfCombatFocusFrame:Hide()
        end
    end

    if self.db.inCombatTrackerToggle then
        if not inCombatTargetFrame and not inCombatFocusFrame then
            if C_AddOns.IsAddOnLoaded("JaxClassicFrames") then
                inCombatTargetFrame = CreateFrame("Frame", "inCombatTargetFrame", JcfTargetFrame)
            else
                inCombatTargetFrame = CreateFrame("Frame", "inCombatTargetFrame", TargetFrame)
            end
            inCombatTargetFrame:SetFrameStrata("BACKGROUND")
            inCombatTargetFrame:SetWidth(16)
            inCombatTargetFrame:SetHeight(16)

            inCombatTargetFrame:SetPoint("RIGHT", 20, 0)

            inCombatTargetFrame.texture = inCombatTargetFrame:CreateTexture(nil, BORDER)
            inCombatTargetFrame.texture:SetAllPoints()
            inCombatTargetFrame.texture:SetTexture("Interface\\Icons\\ability_dualwield") -- Replace with the desired ability icon path

            inCombatTargetFrame:Hide()

            if C_AddOns.IsAddOnLoaded("JaxClassicFrames") then
                inCombatFocusFrame = CreateFrame("Frame", "inCombatFocusFrame", JcfFocusFrame)
            else
                inCombatFocusFrame = CreateFrame("Frame", "inCombatFocusFrame", FocusFrame)
            end
            inCombatFocusFrame:SetFrameStrata("BACKGROUND")
            inCombatFocusFrame:SetWidth(16)
            inCombatFocusFrame:SetHeight(16)

            inCombatFocusFrame:SetPoint("RIGHT", 20, 0)

            inCombatFocusFrame.texture = inCombatFocusFrame:CreateTexture(nil, BORDER)
            inCombatFocusFrame.texture:SetAllPoints()
            inCombatFocusFrame.texture:SetTexture("Interface\\Icons\\ability_dualwield") -- Replace with the desired ability icon path

            inCombatFocusFrame:Hide()
        end
    else
        if inCombatTargetFrame and inCombatFocusFrame then
            inCombatTargetFrame:Hide()
            inCombatFocusFrame:Hide()
        end
    end
    self:Adjustments()
    self:Hooks()
end

function Module:Hooks()
    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
        self:SecureHook(TargetFrame, "OnUpdate", function()
            if self.db.outOfCombatTrackerToggle then
                self:TargetOutOfCombat()
                self:FocusOutOfCombat()
            end
            if self.db.inCombatTrackerToggle then
                self:TargetInCombat()
                self:FocusInCombat()
            end
        end)
        self:SecureHook(FocusFrame, "OnUpdate", function()
            if self.db.outOfCombatTrackerToggle then
                self:TargetOutOfCombat()
                self:FocusOutOfCombat()
            end
            if self.db.inCombatTrackerToggle then
                self:TargetInCombat()
                self:FocusInCombat()
            end
        end)

        local eventFrame = CreateFrame("Frame")

        local function OnEvent()
            if self.db.outOfCombatTrackerToggle then
                self:TargetOutOfCombat()
                self:FocusOutOfCombat()
                C_Timer.After(0.1, function() self:TargetOutOfCombat() end)
                C_Timer.After(0.1, function() self:FocusOutOfCombat() end)
            end
            if self.db.inCombatTrackerToggle then
                self:TargetInCombat()
                self:FocusInCombat()
                C_Timer.After(0.1, function() self:TargetInCombat() end)
                C_Timer.After(0.1, function() self:FocusInCombat() end)
            end
        end

        eventFrame:RegisterEvent("UNIT_COMBAT")
        eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
        eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
        eventFrame:RegisterEvent("UNIT_TARGET")
        eventFrame:RegisterEvent("PLAYER_FOCUS_CHANGED")
        eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")

        eventFrame:SetScript("OnEvent", OnEvent)
    end

    if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        self:SecureHook("TargetFrame_OnUpdate", function()
            if self.db.outOfCombatTrackerToggle then
                self:TargetOutOfCombat()
            end
            if self.db.inCombatTrackerToggle then
                self:TargetInCombat()
            end
        end)

        local eventFrame = CreateFrame("Frame")

        local function OnEvent()
            if self.db.outOfCombatTrackerToggle then
                self:TargetOutOfCombat()
                C_Timer.After(0.1, function() self:TargetOutOfCombat() end)
            end
            if self.db.inCombatTrackerToggle then
                self:TargetInCombat()
                C_Timer.After(0.1, function() self:TargetInCombat() end)
            end
        end

        eventFrame:RegisterEvent("UNIT_COMBAT")
        eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
        eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
        eventFrame:RegisterEvent("UNIT_TARGET")
        eventFrame:RegisterEvent("PLAYER_FOCUS_CHANGED")
        eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")

        eventFrame:SetScript("OnEvent", OnEvent)
    end

    if WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC then
        self:SecureHook("TargetFrame_OnUpdate", function()
            if self.db.outOfCombatTrackerToggle then
                self:TargetOutOfCombat()
                self:FocusOutOfCombat()
                C_Timer.After(0.1, function() self:TargetOutOfCombat() end)
                C_Timer.After(0.1, function() self:FocusOutOfCombat() end)
            end
            if self.db.inCombatTrackerToggle then
                self:TargetInCombat()
                self:FocusInCombat()
                C_Timer.After(0.1, function() self:TargetInCombat() end)
                C_Timer.After(0.1, function() self:FocusInCombat() end)
            end
        end)

        local eventFrame = CreateFrame("Frame")

        local function OnEvent()
            if self.db.outOfCombatTrackerToggle then
                self:TargetOutOfCombat()
                self:FocusOutOfCombat()
                C_Timer.After(0.1, function() self:TargetOutOfCombat() end)
                C_Timer.After(0.1, function() self:FocusOutOfCombat() end)
            end
            if self.db.inCombatTrackerToggle then
                self:TargetInCombat()
                self:FocusInCombat()
                C_Timer.After(0.1, function() self:TargetInCombat() end)
                C_Timer.After(0.1, function() self:FocusInCombat() end)
            end
        end

        eventFrame:RegisterEvent("UNIT_COMBAT")
        eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
        eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
        eventFrame:RegisterEvent("UNIT_TARGET")
        eventFrame:RegisterEvent("PLAYER_FOCUS_CHANGED")
        eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")

        eventFrame:SetScript("OnEvent", OnEvent)
    end
end

function Module:RefreshUI()
    if self:IsEnabled() then
        self:Disable()
        self:Enable()
    end
end

function Module:CheckConditions()
    local localizedClass, englishClass, classIndex = UnitClass("player")

    if self:IsEnabled() then
        if self.db.classConditionsRogue then
            if englishClass == "ROGUE" then
                self:SetupUI()
            else
                --hide the frames if exists
                if inCombatTargetFrame and inCombatFocusFrame then
                    inCombatTargetFrame:Hide()
                    inCombatFocusFrame:Hide()
                end
                if outOfCombatTargetFrame and outOfCombatFocusFrame then
                    outOfCombatTargetFrame:Hide()
                    outOfCombatFocusFrame:Hide()
                end
            end
        end

        if self.db.classConditionsRmp then
            if (englishClass == "ROGUE" or englishClass == "MAGE" or englishClass == "PRIEST") then
                self:SetupUI()
            else
                --hide the frames if exists
                if inCombatTargetFrame and inCombatFocusFrame then
                    inCombatTargetFrame:Hide()
                    inCombatFocusFrame:Hide()
                end
                if outOfCombatTargetFrame and outOfCombatFocusFrame then
                    outOfCombatTargetFrame:Hide()
                    outOfCombatFocusFrame:Hide()
                end
            end
        end

        if self.db.classConditionsAll then
            self:SetupUI()
        end
    else
        --hide the frames if exists
        if inCombatTargetFrame and inCombatFocusFrame then
            inCombatTargetFrame:Hide()
            inCombatFocusFrame:Hide()
        end
        if outOfCombatTargetFrame and outOfCombatFocusFrame then
            outOfCombatTargetFrame:Hide()
            outOfCombatFocusFrame:Hide()
        end
    end
end

function Module:IsAvailableForCurrentVersion()
    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
        return true -- retail
    elseif WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC then
        return true -- cata
    elseif WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        return true -- vanilla
    end
end
