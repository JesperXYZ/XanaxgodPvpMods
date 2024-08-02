local _, XPM = ...
local Main = XPM.Main

local Module = Main:NewModule("UnitFrameStatusText", "AceHook-3.0", "AceEvent-3.0")

function Module:OnEnable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:OnDisable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:GetDescription()
    return "This module allows you to reformat the status text displayed on the health and mana bar of your unit frames (you should reload after altering this module)."
end

function Module:GetName()
    return "Unit Frame Status Text"
end

function Module:GetOptions(myOptionsTable, db)
    self.db = db
    local defaults = {
        numericValueToggle = false,
        percentageToggle = false,
        bothToggle = false,
        noneToggle = false,
        xanaxgodNumericValueToggle = true,
        xanaxgodBothToggle = false,
        selectedFont = "Fonts\\FRIZQT__.TTF",
        fontSize = 10
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

        if setting == "numericValueToggle" then
            if
            not (self.db.numericValueToggle or self.db.percentageToggle or self.db.bothToggle or self.db.noneToggle or
                    self.db.xanaxgodNumericValueToggle or
                    self.db.xanaxgodBothToggle)
            then
                self.db.numericValueToggle = true
            end

            if self.db.percentageToggle then
                self.db.percentageToggle = false
            end
            if self.db.bothToggle then
                self.db.bothToggle = false
            end
            if self.db.noneToggle then
                self.db.noneToggle = false
            end
            if self.db.xanaxgodNumericValueToggle then
                self.db.xanaxgodNumericValueToggle = false
            end
            if self.db.xanaxgodBothToggle then
                self.db.xanaxgodBothToggle = false
            end

            self:RefreshUI()
            self:RefreshUI()
        end
        if setting == "percentageToggle" then
            if
            not (self.db.numericValueToggle or self.db.percentageToggle or self.db.bothToggle or self.db.noneToggle or
                    self.db.xanaxgodNumericValueToggle or
                    self.db.xanaxgodBothToggle)
            then
                self.db.percentageToggle = true
            end

            if self.db.numericValueToggle then
                self.db.numericValueToggle = false
            end
            if self.db.bothToggle then
                self.db.bothToggle = false
            end
            if self.db.noneToggle then
                self.db.noneToggle = false
            end
            if self.db.xanaxgodNumericValueToggle then
                self.db.xanaxgodNumericValueToggle = false
            end
            if self.db.xanaxgodBothToggle then
                self.db.xanaxgodBothToggle = false
            end

            self:RefreshUI()
            self:RefreshUI()
        end
        if setting == "bothToggle" then
            if
            not (self.db.numericValueToggle or self.db.percentageToggle or self.db.bothToggle or self.db.noneToggle or
                    self.db.xanaxgodNumericValueToggle or
                    self.db.xanaxgodBothToggle)
            then
                self.db.bothToggle = true
            end

            if self.db.numericValueToggle then
                self.db.numericValueToggle = false
            end
            if self.db.percentageToggle then
                self.db.percentageToggle = false
            end
            if self.db.noneToggle then
                self.db.noneToggle = false
            end
            if self.db.xanaxgodNumericValueToggle then
                self.db.xanaxgodNumericValueToggle = false
            end
            if self.db.xanaxgodBothToggle then
                self.db.xanaxgodBothToggle = false
            end

            self:RefreshUI()
            self:RefreshUI()
        end
        if setting == "noneToggle" then
            if
            not (self.db.numericValueToggle or self.db.percentageToggle or self.db.bothToggle or self.db.noneToggle or
                    self.db.xanaxgodNumericValueToggle or
                    self.db.xanaxgodBothToggle)
            then
                self.db.noneToggle = true
            end

            if self.db.numericValueToggle then
                self.db.numericValueToggle = false
            end
            if self.db.percentageToggle then
                self.db.percentageToggle = false
            end
            if self.db.bothToggle then
                self.db.bothToggle = false
            end
            if self.db.xanaxgodNumericValueToggle then
                self.db.xanaxgodNumericValueToggle = false
            end
            if self.db.xanaxgodBothToggle then
                self.db.xanaxgodBothToggle = false
            end

            self:RefreshUI()
            self:RefreshUI()
        end
        if setting == "xanaxgodNumericValueToggle" then
            if
            not (self.db.numericValueToggle or self.db.percentageToggle or self.db.bothToggle or self.db.noneToggle or
                    self.db.xanaxgodNumericValueToggle or
                    self.db.xanaxgodBothToggle)
            then
                self.db.xanaxgodNumericValueToggle = true
            end

            if self.db.numericValueToggle then
                self.db.numericValueToggle = false
            end
            if self.db.percentageToggle then
                self.db.percentageToggle = false
            end
            if self.db.bothToggle then
                self.db.bothToggle = false
            end
            if self.db.noneToggle then
                self.db.noneToggle = false
            end
            if self.db.xanaxgodBothToggle then
                self.db.xanaxgodBothToggle = false
            end

            self:RefreshUI()
            self:RefreshUI()
        end
        if setting == "xanaxgodBothToggle" then
            if
            not (self.db.numericValueToggle or self.db.percentageToggle or self.db.bothToggle or self.db.noneToggle or
                    self.db.xanaxgodNumericValueToggle or
                    self.db.xanaxgodBothToggle)
            then
                self.db.xanaxgodBothToggle = true
            end

            if self.db.numericValueToggle then
                self.db.numericValueToggle = false
            end
            if self.db.percentageToggle then
                self.db.percentageToggle = false
            end
            if self.db.bothToggle then
                self.db.bothToggle = false
            end
            if self.db.noneToggle then
                self.db.noneToggle = false
            end
            if self.db.xanaxgodNumericValueToggle then
                self.db.xanaxgodNumericValueToggle = false
            end

            self:RefreshUI()
            self:RefreshUI()
        end
        if setting == "selectedFont" or setting == "fontSize" then
            self:RefreshUI()
        end
    end

    local counter = CreateCounter(5)

    local UnitFrameStatusTextImage =
    "|TInterface\\Addons\\XanaxgodPvpMods\\media\\moduleImages\\UnitFrameStatusText:132:499:1:-1|t"

    myOptionsTable.args.statusTextGroup1 = {
        order = counter(),
        name = "Change Status Text Format",
        type = "group",
        inline = true, --inline makes it a normal group. else it is a tab group (myOptionsTable in core.lua)
        args = {
            statusTextGroup2 = {
                order = counter(),
                name = "Blizzard Formats",
                type = "group",
                inline = true, --inline makes it a normal group. else it is a tab group (myOptionsTable in core.lua)
                args = {
                    numericValueToggle = {
                        type = "toggle",
                        name = "Numeric",
                        desc = "",
                        order = counter(),
                        width = 0.47,
                        get = get,
                        set = set
                    },
                    percentageToggle = {
                        type = "toggle",
                        name = "Percentage",
                        desc = "",
                        order = counter(),
                        width = 0.57,
                        get = get,
                        set = set
                    },
                    bothToggle = {
                        type = "toggle",
                        name = "Both",
                        desc = "",
                        order = counter(),
                        width = 0.33,
                        get = get,
                        set = set
                    },
                    noneToggle = {
                        type = "toggle",
                        name = "None",
                        desc = "",
                        order = counter(),
                        width = 0.42,
                        get = get,
                        set = set
                    }
                }
            },
            statusTextGroup3 = {
                order = counter(),
                name = "Xanaxgod Formats",
                type = "group",
                inline = true, --inline makes it a normal group. else it is a tab group (myOptionsTable in core.lua)
                args = {
                    xanaxgodNumericValueToggle = {
                        type = "toggle",
                        name = "Xanaxgod Numeric",
                        desc = "",
                        order = counter(),
                        width = 0.83,
                        get = get,
                        set = set
                    },
                    xanaxgodBothToggle = {
                        type = "toggle",
                        name = "Xanaxgod Both",
                        desc = "",
                        order = counter(),
                        width = 0.69,
                        get = get,
                        set = set
                    },
                    reloadExecute = {
                        type = "execute",
                        name = "/reload",
                        desc = "",
                        width = 0.45,
                        func = function()
                            ReloadUI()
                        end,
                        order = counter()
                    }
                }
            }
        }
    }
    myOptionsTable.args.fontGroup = {
        order = counter(),
        name = "Font Settings",
        type = "group",
        inline = true,
        args = {
            selectedFont = {
                type = "select",
                name = "Font",
                order = counter(),
                width = 0.8,
                values = {
                    ["Fonts\\FRIZQT__.TTF"] = "Friz Quadrata TT",
                    ["Fonts\\ARIALN.TTF"] = "Arial Narrow",
                    ["Fonts\\MORPHEUS.TTF"] = "Morpheus",
                    ["Fonts\\SKURRI.TTF"] = "Skurri"
                },
                get = get,
                set = set
            },
            fontSize = {
                type = "range",
                name = "Font Size",
                order = counter(),
                width = 0.6,
                min = 8,
                max = 16,
                step = 1,
                get = get,
                set = set
            },
            resetToDefault = {
                type = "execute",
                name = "Reset to Default",
                desc = "Reset font and size to default values.",
                order = counter(),
                width = 0.75,
                func = function()
                    self.db.selectedFont = defaults.selectedFont
                    self.db.fontSize = defaults.fontSize
                    self:RefreshUI()
                end,
            }
        }
    }
    myOptionsTable.args.art222 = {
        order = counter(),
        type = "description",
        name = "" .. UnitFrameStatusTextImage,
        width = "full"
    }

    return myOptionsTable
end

function Module:SetupStatusText()

    local unitFrames = {
        player = {
            health = nil,
            healthRight = nil,
            healthLeft = nil,
            mana = nil,
            manaRight = nil,
            manaLeft = nil,
            alternatePower = nil,
            alternatePowerRight = nil,
            alternatePowerLeft = nil
        },
        target = {
            health = nil,
            healthRight = nil,
            healthLeft = nil,
            mana = nil,
            manaRight = nil,
            manaLeft = nil
        },
        focus = {
            health = nil,
            healthRight = nil,
            healthLeft = nil,
            mana = nil,
            manaRight = nil,
            manaLeft = nil
        },
        pet = {
            health = nil,
            healthRight = nil,
            healthLeft = nil,
            mana = nil,
            manaRight = nil,
            manaLeft = nil
        }
    }

    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
        if IsAddOnLoaded("JaxClassicFrames") then
            unitFrames.player.health = JcfPlayerFrameHealthBarText
            unitFrames.player.healthRight = JcfPlayerFrameHealthBarTextRight
            unitFrames.player.healthLeft = JcfPlayerFrameHealthBarTextLeft
            unitFrames.player.mana = JcfPlayerFrameManaBarText
            unitFrames.player.manaRight = JcfPlayerFrameManaBarTextRight
            unitFrames.player.manaLeft = JcfPlayerFrameManaBarTextLeft
            unitFrames.player.alternatePower = JcfPlayerFrameAlternateManaBarText
            unitFrames.player.alternatePowerRight = JcfPlayerFrameAlternateManaBarRightText
            unitFrames.player.alternatePowerLeft = JcfPlayerFrameAlternateManaBarLeftText

            unitFrames.target.health = JcfTargetFrameTextureFrame.HealthBarText
            unitFrames.target.healthRight = JcfTargetFrameTextureFrame.HealthBarTextRight
            unitFrames.target.healthLeft = JcfTargetFrameTextureFrame.HealthBarTextLeft
            unitFrames.target.mana = JcfTargetFrameTextureFrame.ManaBarText
            unitFrames.target.manaRight = JcfTargetFrameTextureFrame.ManaBarTextRight
            unitFrames.target.manaLeft = JcfTargetFrameTextureFrame.ManaBarTextLeft

            unitFrames.focus.health = JcfFocusFrameTextureFrame.HealthBarText
            unitFrames.focus.healthRight = JcfFocusFrameTextureFrame.HealthBarTextRight
            unitFrames.focus.healthLeft = JcfFocusFrameTextureFrame.HealthBarTextLeft
            unitFrames.focus.mana = JcfFocusFrameTextureFrame.ManaBarText
            unitFrames.focus.manaRight = JcfFocusFrameTextureFrame.ManaBarTextRight
            unitFrames.focus.manaLeft = JcfFocusFrameTextureFrame.ManaBarTextLeft

            unitFrames.pet.health = JcfPetFrameHealthBarText
            unitFrames.pet.healthRight = JcfPetFrameHealthBarTextRight
            unitFrames.pet.healthLeft = JcfPetFrameHealthBarTextLeft
            unitFrames.pet.mana = JcfPetFrameManaBarText
            unitFrames.pet.manaRight = JcfPetFrameManaBarTextRight
            unitFrames.pet.manaLeft = JcfPetFrameManaBarTextLeft
        else
            unitFrames.player.health = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarsContainer.HealthBarText
            unitFrames.player.healthRight = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarsContainer.RightText
            unitFrames.player.healthLeft = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarsContainer.LeftText
            unitFrames.player.mana = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar.ManaBarText
            unitFrames.player.manaRight = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar.RightText
            unitFrames.player.manaLeft = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar.LeftText
            unitFrames.player.alternatePower = AlternatePowerBarText
            unitFrames.player.alternatePowerRight = AlternatePowerBar.LeftText
            unitFrames.player.alternatePowerLeft = AlternatePowerBar.RightText

            unitFrames.target.health = TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBarsContainer.HealthBarText
            unitFrames.target.healthRight = TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBarsContainer.RightText
            unitFrames.target.healthLeft = TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBarsContainer.LeftText
            unitFrames.target.mana = TargetFrame.TargetFrameContent.TargetFrameContentMain.ManaBar.ManaBarText
            unitFrames.target.manaRight = TargetFrame.TargetFrameContent.TargetFrameContentMain.ManaBar.RightText
            unitFrames.target.manaLeft = TargetFrame.TargetFrameContent.TargetFrameContentMain.ManaBar.LeftText

            unitFrames.focus.health = FocusFrame.TargetFrameContent.TargetFrameContentMain.HealthBarsContainer.HealthBarText
            unitFrames.focus.healthRight = FocusFrame.TargetFrameContent.TargetFrameContentMain.HealthBarsContainer.RightText
            unitFrames.focus.healthLeft = FocusFrame.TargetFrameContent.TargetFrameContentMain.HealthBarsContainer.LeftText
            unitFrames.focus.mana = FocusFrame.TargetFrameContent.TargetFrameContentMain.ManaBar.ManaBarText
            unitFrames.focus.manaRight = FocusFrame.TargetFrameContent.TargetFrameContentMain.ManaBar.RightText
            unitFrames.focus.manaLeft = FocusFrame.TargetFrameContent.TargetFrameContentMain.ManaBar.LeftText

            unitFrames.pet.health = PetFrameHealthBarText
            unitFrames.pet.healthRight = PetFrameHealthBarTextRight
            unitFrames.pet.healthLeft = PetFrameHealthBarTextLeft
            unitFrames.pet.mana = PetFrameManaBarText
            unitFrames.pet.manaRight = PetFrameManaBarTextRight
            unitFrames.pet.manaLeft = PetFrameManaBarTextLeft
        end
    elseif WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC then
        unitFrames.player.health = PlayerFrameHealthBarText
        unitFrames.player.healthRight = PlayerFrameHealthBarTextRight
        unitFrames.player.healthLeft = PlayerFrameHealthBarTextLeft
        unitFrames.player.mana = PlayerFrameManaBarText
        unitFrames.player.manaRight = PlayerFrameManaBarTextRight
        unitFrames.player.manaLeft = PlayerFrameManaBarTextLeft
        unitFrames.player.alternatePower = nil
        unitFrames.player.alternatePowerRight = nil
        unitFrames.player.alternatePowerLeft = nil

        unitFrames.target.health = TargetFrameTextureFrame.HealthBarText
        unitFrames.target.healthRight = TargetFrameTextureFrame.HealthBarTextRight
        unitFrames.target.healthLeft = TargetFrameTextureFrame.HealthBarTextLeft
        unitFrames.target.mana = TargetFrameTextureFrame.ManaBarText
        unitFrames.target.manaRight = TargetFrameTextureFrame.ManaBarTextRight
        unitFrames.target.manaLeft = TargetFrameTextureFrame.ManaBarTextLeft

        unitFrames.focus.health = FocusFrameTextureFrame.HealthBarText
        unitFrames.focus.healthRight = FocusFrameTextureFrame.HealthBarTextRight
        unitFrames.focus.healthLeft = FocusFrameTextureFrame.HealthBarTextLeft
        unitFrames.focus.mana = FocusFrameTextureFrame.ManaBarText
        unitFrames.focus.manaRight = FocusFrameTextureFrame.ManaBarTextRight
        unitFrames.focus.manaLeft = FocusFrameTextureFrame.ManaBarTextLeft

        unitFrames.pet.health = PetFrameHealthBarText
        unitFrames.pet.healthRight = PetFrameHealthBarTextRight
        unitFrames.pet.healthLeft = PetFrameHealthBarTextLeft
        unitFrames.pet.mana = PetFrameManaBarText
        unitFrames.pet.manaRight = PetFrameManaBarTextRight
        unitFrames.pet.manaLeft = PetFrameManaBarTextLeft
    elseif WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        unitFrames.player.health = PlayerFrameHealthBarText
        unitFrames.player.healthRight = PlayerFrameHealthBarTextRight
        unitFrames.player.healthLeft = PlayerFrameHealthBarTextLeft
        unitFrames.player.mana = PlayerFrameManaBarText
        unitFrames.player.manaRight = PlayerFrameHealthBarTextRight
        unitFrames.player.manaLeft = PlayerFrameHealthBarTextLeft
        unitFrames.player.alternatePower = nil
        unitFrames.player.alternatePowerRight = nil
        unitFrames.player.alternatePowerLeft = nil

        unitFrames.target.health = TargetFrameHealthBarText
        unitFrames.target.healthRight = TargetFrameTextureFrame.HealthBarTextRight
        unitFrames.target.healthLeft = TargetFrameTextureFrame.HealthBarTextLeft
        unitFrames.target.mana = TargetFrameManaBarText
        unitFrames.target.manaRight = TargetFrameTextureFrame.ManaBarTextRight
        unitFrames.target.manaLeft = TargetFrameTextureFrame.ManaBarTextLeft

        unitFrames.focus.health = nil
        unitFrames.focus.healthRight = nil
        unitFrames.focus.healthLeft = nil
        unitFrames.focus.mana = nil
        unitFrames.focus.manaRight = nil
        unitFrames.focus.manaLeft = nil

        unitFrames.pet.health = PetFrameHealthBarText
        unitFrames.pet.healthRight = PetFrameHealthBarTextRight
        unitFrames.pet.healthLeft = PetFrameHealthBarTextLeft
        unitFrames.pet.mana = PetFrameManaBarText
        unitFrames.pet.manaRight = PetFrameManaBarTextRight
        unitFrames.pet.manaLeft = PetFrameManaBarTextLeft
    end

    local font = self.db.selectedFont
    local fontSize = self.db.fontSize

    for unitType, statusTexts in pairs(unitFrames) do
        for barType, statusText in pairs(statusTexts) do
            if statusText then
                if unitType == "pet" or barType == "alternatePower" or barType == "alternatePowerRight" or barType == "alternatePowerLeft" then
                    statusText:SetFont(font, fontSize - 1, "OUTLINE")
                else
                    statusText:SetFont(font, fontSize, "OUTLINE")
                end
            end
        end
    end

    local function FormatValue(val)
        --0 to 99.999
        if val < 100000 then
            if val < 1 then
                return " "
            elseif val < 1000 then
                --999 and below
                return ("%.0f"):format(val)
            else
                if val < 10000 then
                    --9.999 and below
                    local s = ("%.0f"):format(val)
                    return (string.sub(s, 1, 1) .. "," .. string.sub(s, 2, 4))
                else
                    --99.999 and below
                    local s = ("%.0f"):format(val)
                    return (string.sub(s, 1, 2) .. "," .. string.sub(s, 3, 5))
                end
            end
        --100 K to 99.999 K
        elseif val < 100000000 then

            return ("%.0f K"):format(val / 1000)

            --[[if val < 1000000 then
                --999 K and below
                return ("%.0f K"):format(val / 1000)
            elseif val < 10000000 then
                --9.999 K and below
                local s = ("%.0f K"):format(val / 1000)
                return (string.sub(s, 1, 1) .. "," .. string.sub(s, 2, 6))
            else
                --99.999 K and below
                local s = ("%.0f K"):format(val / 1000)
                return (string.sub(s, 1, 2) .. "," .. string.sub(s, 3, 7))
            end]]--

        --100 M to 99.999 M
        elseif val < 100000000000 then

            return ("%.0f M"):format(val / 1000000)

            --[[if val < 1000000000 then
                --999 M and below
                return ("%.0f M"):format(val / 1000000)
            elseif val < 10000000000 then
                --9.999 M and below
                local s = ("%.0f M"):format(val / 1000000)
                return (string.sub(s, 1, 1) .. "," .. string.sub(s, 2, 6))
            else
                --99.999 M and below
                local s = ("%.0f M"):format(val / 1000000)
                return (string.sub(s, 1, 2) .. "," .. string.sub(s, 3, 7))
            end]]--

        else
            --100 B and above
            return ("%.0ft B"):format(val / 1000000000000)
        end
    end

    --NumericValue
    if self:IsEnabled() and self.db.numericValueToggle then
        SetCVar("statusText")
        SetCVar("statusText", 1)
        SetCVar("statusTextDisplay", "NUMERIC")
    end
    --Percentage
    if self:IsEnabled() and self.db.percentageToggle then
        SetCVar("statusText")
        SetCVar("statusText", 1)
        SetCVar("statusTextDisplay", "PERCENT")
    end
    --Both
    if self:IsEnabled() and self.db.bothToggle then
        SetCVar("statusText")
        SetCVar("statusText", 1)
        SetCVar("statusTextDisplay", "BOTH")
    end
    --None
    if self:IsEnabled() and self.db.noneToggle then
        SetCVar("statusText")
        SetCVar("statusTextDisplay", "NONE")
    end
    --XanaxgodNumericValue
    if self:IsEnabled() and self.db.xanaxgodNumericValueToggle then
        SetCVar("statusText")
        SetCVar("statusText", 1)
        SetCVar("statusTextDisplay", "NUMERIC")

        local function NumericUpdater()
            for unitType, statusTexts in pairs(unitFrames) do
                for barType, statusText in pairs(statusTexts) do
                    if barType == "health" then
                        statusText:SetText(tostring(FormatValue(UnitHealth(unitType))))
                    end
                    if barType == "mana" then
                        statusText:SetText(tostring(FormatValue(UnitPower(unitType))))
                    end
                    if barType == "alternatePower" then
                        local croppedName = statusText:GetText()

                        if croppedName then
                            if croppedName:find("/") then
                                croppedName = croppedName:match("[^/]+")
                                croppedName = croppedName:sub(1, -2)
                                statusText:SetText(croppedName)
                            end
                        end
                    end
                end
            end
        end

        if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
            if self:IsHooked("UnitFrameHealthBar_OnUpdate") or self:IsHooked("UnitFrameManaBar_OnUpdate") then
                return
            end

            self:SecureHook("UnitFrameHealthBar_OnUpdate", function() NumericUpdater() end)
            self:SecureHook("UnitFrameManaBar_OnUpdate", function() NumericUpdater() end)

        else
            if self:IsHooked("TextStatusBar_UpdateTextStringWithValues") then
                return
            end

            self:SecureHook("TextStatusBar_UpdateTextStringWithValues", function() NumericUpdater() end)
        end

        NumericUpdater()
    end
    --XanaxgodBoth
    if self:IsEnabled() and self.db.xanaxgodBothToggle then
        SetCVar("statusText")
        SetCVar("statusText", 1)
        SetCVar("statusTextDisplay", "NUMERIC")

        local function NumericUpdater()
            for unitType, statusTexts in pairs(unitFrames) do
                for barType, statusText in pairs(statusTexts) do
                    if barType == "health" then
                        if UnitHealth(unitType) < 1 then
                            statusText:SetText(" ")
                        else
                            statusText:SetText(tostring(FormatValue(UnitHealth(unitType))).. " (" .. tostring(UnitHealth(unitType) / UnitHealthMax(unitType) * 100 - (UnitHealth(unitType) / UnitHealthMax(unitType) * 100) % 1) .. "%)")
                        end
                    end
                    if barType == "mana" then
                        if UnitPower(unitType) < 1 then
                            statusText:SetText("0")
                        else
                            statusText:SetText(tostring(FormatValue(UnitPower(unitType))).. " (" .. tostring(UnitPower(unitType) / UnitPowerMax(unitType) * 100 - (UnitPower(unitType) / UnitPowerMax(unitType) * 100) % 1) .. "%)")
                        end
                    end
                    if barType == "alternatePower" then
                        local croppedName = statusText:GetText()

                        if croppedName then
                            if croppedName:find("/") then
                                croppedName = croppedName:match("[^/]+")
                                croppedName = croppedName:sub(1, -2)
                                statusText:SetText(croppedName)
                            end
                        end
                    end
                end
            end
        end

        if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
            if self:IsHooked("UnitFrameHealthBar_OnUpdate") or self:IsHooked("UnitFrameManaBar_OnUpdate") then
                return
            end

            self:SecureHook("UnitFrameHealthBar_OnUpdate", function() NumericUpdater() end)
            self:SecureHook("UnitFrameManaBar_OnUpdate", function() NumericUpdater() end)

        else
            if self:IsHooked("TextStatusBar_UpdateTextStringWithValues") then
                return
            end

            self:SecureHook("TextStatusBar_UpdateTextStringWithValues", function() NumericUpdater() end)
        end

        NumericUpdater()
    end
end

function Module:SetupUI()
    self:SetupStatusText()
end

function Module:RefreshUI()
    if self:IsEnabled() then
        self:Disable()
        self:Enable()
    end
end

function Module:CheckConditions()
    if self:IsEnabled() then
        self:SetupUI()
    else
        self:SetupUI()
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
