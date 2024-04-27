local _, XPM = ...
local Main = XPM.Main

local Module = Main:NewModule("UnitFrameCastBarColors", "AceHook-3.0", "AceEvent-3.0")

function Module:OnEnable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:OnDisable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:GetDescription()
    return "This module remakes the coloring of your unit frame cast bars and makes fake casts easier to spot (you should reload after altering this module)."
end

function Module:GetName()
    return "Unit Frame Cast Bar Colors"
end

function Module:GetOptions(myOptionsTable, db)
    self.db = db
    local defaults = {
        customCastBarColorsToggle = false,
        successColor = {
            r = 0,
            g = 1,
            b = 0,
            a = 1
        },
        normalColor = {
            r = 1,
            g = 0.7,
            b = 0,
            a = 1
        },
        interruptedColor = {
            r = 1,
            g = 0,
            b = 0,
            a = 1
        },
        notInterruptibleColor = {
            r = 0.3,
            g = 0.3,
            b = 0.3,
            a = 1
        }
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

        if setting == "customCastBarColorsToggle" then
            self:RefreshUI()
        end
    end
    local getColor = function(info)
        local color = self.db[info[#info]]
        return color.r, color.g, color.b, color.a
    end
    local setColor = function(info, r, g, b, a)
        local color = self.db[info[#info]]
        color.r, color.g, color.b, color.a = r, g, b, a
    end

    local counter = CreateCounter(5)

    local UnitFrameCastBarColors1Image =
    "|TInterface\\Addons\\XanaxgodPvpMods\\media\\moduleImages\\UnitFrameCastBarColors1:78:499:0:-1|t"
    local UnitFrameCastBarColors2Image =
    "|TInterface\\Addons\\XanaxgodPvpMods\\media\\moduleImages\\UnitFrameCastBarColors2:78:499:0:-1|t"

    myOptionsTable.args.spaceDesc = {
        order = counter(),
        type = "description",
        name = "  ",
        width = 0.6
    }
    myOptionsTable.args.reloadExecute = {
        type = "execute",
        name = "/reload",
        desc = "",
        width = 0.45,
        func = function()
            ReloadUI()
        end,
        order = counter()
    }
    myOptionsTable.args.colorSettingsGroup = {
        order = counter(),
        name = "Custom Cast Bar Colors",
        type = "group",
        inline = true, --inline makes it a normal group. else it is a tab group (myOptionsTable in core.lua)
        args = {
            customCastBarColorsToggle = {
                type = "toggle",
                name = "Enable",
                order = counter(),
                width = 0.525,
                get = get,
                set = set
            },
            reset = {
                type = "execute",
                name = "Reset to Default",
                width = 0.8,
                func = function()
                    self.db.successColor = defaults.successColor
                    self.db.normalColor = defaults.normalColor
                    self.db.interruptedColor = defaults.interruptedColor
                    self.db.notInterruptibleColor = defaults.notInterruptibleColor
                    Module:RefreshUI()
                end,
                order = counter()
            },
            spaceDesc = {
                order = counter(),
                type = "description",
                name = "  ",
                width = 0.175
            },
            successColor = {
                type = "color",
                name = "Success/channel cast bar color",
                hasAlpha = true,
                width = 0.75,
                order = counter(),
                get = getColor,
                set = setColor
            },
            normalColor = {
                type = "color",
                name = "Normal cast bar color",
                hasAlpha = true,
                width = 0.75,
                order = counter(),
                get = getColor,
                set = setColor
            },
            interruptedColor = {
                type = "color",
                name = "Interrupted cast bar color",
                hasAlpha = true,
                width = 0.75,
                order = counter(),
                get = getColor,
                set = setColor
            },
            notInterruptibleColor = {
                type = "color",
                name = "Not interruptible cast bar color",
                hasAlpha = true,
                width = 0.75,
                order = counter(),
                get = getColor,
                set = setColor
            }
        }
    }
    myOptionsTable.args.empty51235 = {
        order = counter(),
        type = "description",
        name = " ",
        width = "full"
    }
    myOptionsTable.args.empty512351 = {
        order = counter(),
        type = "description",
        name = " ",
        width = "full"
    }
    myOptionsTable.args.pic1Desc = {
        order = counter(),
        type = "description",
        name = "Default blizzard frames (module disabled vs. module enabled).",
        width = "full"
    }
    myOptionsTable.args.art51233 = {
        order = counter(),
        type = "description",
        name = "" .. UnitFrameCastBarColors1Image,
        width = "full"
    }
    myOptionsTable.args.empty512325 = {
        order = counter(),
        type = "description",
        name = " ",
        width = "full"
    }
    myOptionsTable.args.empty512335 = {
        order = counter(),
        type = "description",
        name = " ",
        width = "full"
    }
    myOptionsTable.args.pic2Desc = {
        order = counter(),
        type = "description",
        name = "Jax Classic Frames (module disabled vs. module enabled).",
        width = "full"
    }
    myOptionsTable.args.art512334 = {
        order = counter(),
        type = "description",
        name = "" .. UnitFrameCastBarColors2Image,
        width = "full"
    }

    return myOptionsTable
end

function Module:SetupCastBarColors()
    if self:IsEnabled() then
        local isTargetCasting = false
        local isFocusCasting = false
        local targetCastEndTime = 1
        local focusCastEndTime = 1

        local green
        local yellow
        local red
        local grey

        if self.db.customCastBarColorsToggle then
            green = self.db.successColor
            yellow = self.db.normalColor
            red = self.db.interruptedColor
            grey = self.db.notInterruptibleColor
        else
            local defaults

            if IsAddOnLoaded("JaxClassicFrames") then
                defaults = {
                    successColor = {
                        r = 0,
                        g = 1,
                        b = 0,
                        a = 1
                    },
                    normalColor = {
                        r = 1,
                        g = 0.7,
                        b = 0,
                        a = 1
                    },
                    interruptedColor = {
                        r = 1,
                        g = 0,
                        b = 0,
                        a = 1
                    },
                    notInterruptibleColor = {
                        r = 0.3,
                        g = 0.3,
                        b = 0.3,
                        a = 1
                    }
                }
            else
                defaults = {
                    successColor = {
                        r = 0,
                        g = 1,
                        b = 0,
                        a = 1
                    },
                    normalColor = {
                        r = 1,
                        g = 0.9,
                        b = 0,
                        a = 1
                    },
                    interruptedColor = {
                        r = 1,
                        g = 0,
                        b = 0,
                        a = 1
                    },
                    notInterruptibleColor = {
                        r = 0.3,
                        g = 0.3,
                        b = 0.3,
                        a = 1
                    }
                }
            end

            green = defaults.successColor
            yellow = defaults.normalColor
            red = defaults.interruptedColor
            grey = defaults.notInterruptibleColor
        end

        function Module:CheckCastStatus(castType)
            if castType == "TargetEmpower" then
                if select(10, UnitChannelInfo("target")) then
                    if select(10, UnitChannelInfo("target")) > 0 then
                        isTargetCasting = true

                        targetCastEndTime =
                        (select(5, UnitChannelInfo("target")) + GetUnitEmpowerHoldAtMaxTime("target")) / 1000
                    end
                else
                    isTargetCasting = false
                end
                return
            end

            if castType == "FocusEmpower" then
                if select(10, UnitChannelInfo("focus")) then
                    if select(10, UnitChannelInfo("focus")) > 0 then
                        isFocusCasting = true

                        focusCastEndTime =
                        (select(5, UnitChannelInfo("focus")) + GetUnitEmpowerHoldAtMaxTime("focus")) / 1000
                    end
                else
                    isFocusCasting = false
                end
                return
            end

            if castType == "TargetChannel" then
                if UnitChannelInfo("target") then
                    isTargetCasting = true
                    targetCastEndTime = select(5, UnitChannelInfo("target")) / 1000
                else
                    isTargetCasting = false
                end
                return
            end

            if castType == "FocusChannel" then
                if UnitChannelInfo("focus") then
                    isFocusCasting = true
                    focusCastEndTime = select(5, UnitChannelInfo("focus")) / 1000
                else
                    isFocusCasting = false
                end
                return
            end

            if castType == "TargetCast" then
                if UnitCastingInfo("target") then
                    isTargetCasting = true
                    targetCastEndTime = select(5, UnitCastingInfo("target")) / 1000
                else
                    isTargetCasting = false
                end
                return
            end

            if castType == "FocusCast" then
                if UnitCastingInfo("focus") then
                    isFocusCasting = true
                    focusCastEndTime = select(5, UnitCastingInfo("focus")) / 1000
                else
                    isFocusCasting = false
                end
                return
            end
        end

        if IsAddOnLoaded("JaxClassicFrames") then
            JcfTargetFrameSpellBar.Flash:SetDrawLayer("BACKGROUND", -8)
            JcfFocusFrameSpellBar.Flash:SetDrawLayer("BACKGROUND", -8)

            function Module:JCFStopCastHandler(unitTarget)
                if unitTarget == "target" then
                    Module:CheckCastStatus("TargetCast")
                    if not isTargetCasting then
                        if (GetTime()) > (targetCastEndTime - 0.1) then
                        else
                            targetCastEndTime = targetCastEndTime + 999999

                            Module:JCFSetRed(unitTarget)
                        end
                    end
                end

                if unitTarget == "focus" then
                    Module:CheckCastStatus("FocusCast")
                    if not isFocusCasting then
                        if (GetTime()) > (focusCastEndTime - 0.1) then
                        else
                            focusCastEndTime = focusCastEndTime + 999999

                            Module:JCFSetRed(unitTarget)
                        end
                    end
                end
            end

            function Module:JCFStartCastHandler(unitTarget)
                if unitTarget == "target" then
                    Module:CheckCastStatus("TargetCast")
                    if isTargetCasting then
                        local notInterruptible = select(8, UnitCastingInfo(unitTarget))
                        if notInterruptible then
                            Module:JCFSetGrey(unitTarget)
                        else
                            Module:JCFSetYellow(unitTarget)
                        end
                    end
                end

                if unitTarget == "focus" then
                    Module:CheckCastStatus("FocusCast")
                    if isFocusCasting then
                        local notInterruptible = select(8, UnitCastingInfo(unitTarget))
                        if notInterruptible then
                            Module:JCFSetGrey(unitTarget)
                        else
                            Module:JCFSetYellow(unitTarget)
                        end
                    end
                end
            end

            function Module:JCFStopChannelHandler(unitTarget)
                if unitTarget == "target" then
                    Module:CheckCastStatus("TargetChannel")
                    if not isTargetCasting then
                        if not ((GetTime()) > (targetCastEndTime - 0.1)) then
                            Module:JCFSetRed(unitTarget)
                        end
                    end
                end

                if unitTarget == "focus" then
                    Module:CheckCastStatus("FocusChannel")
                    if not isFocusCasting then
                        if not ((GetTime()) > (focusCastEndTime - 0.1)) then
                            Module:JCFSetRed(unitTarget)
                        end
                    end
                end
            end

            function Module:JCFStartChannelHandler(unitTarget)
                if unitTarget == "target" then
                    Module:CheckCastStatus("TargetChannel")
                    if isTargetCasting then
                        local notInterruptible = select(7, UnitChannelInfo(unitTarget))
                        if notInterruptible then
                            Module:JCFSetGrey(unitTarget)
                        else
                            Module:JCFSetGreen(unitTarget)
                        end
                    end
                end

                if unitTarget == "focus" then
                    Module:CheckCastStatus("FocusChannel")
                    if isFocusCasting then
                        local notInterruptible = select(7, UnitChannelInfo(unitTarget))
                        if notInterruptible then
                            Module:JCFSetGrey(unitTarget)
                        else
                            Module:JCFSetGreen(unitTarget)
                        end
                    end
                end
            end

            function Module:JCFStopEmpowerHandler(unitTarget)
                if unitTarget == "target" then
                    Module:CheckCastStatus("TargetEmpower")
                    if not isTargetCasting then
                        if (GetTime()) > (targetCastEndTime - 0.1) then
                            Module:JCFSetGreen(unitTarget)
                        else
                            targetCastEndTime = targetCastEndTime + 999999

                            JcfTargetFrameSpellBar.Flash:SetVertexColor(1, 0.8, 0, 1)
                        end
                    end
                end

                if unitTarget == "focus" then
                    Module:CheckCastStatus("FocusEmpower")
                    if not isFocusCasting then
                        if (GetTime()) > (focusCastEndTime - 0.1) then
                            Module:JCFSetGreen(unitTarget)
                        else
                            targetCastEndTime = targetCastEndTime + 999999

                            JcfFocusFrameSpellBar.Flash:SetVertexColor(1, 0.8, 0, 1)
                        end
                    end
                end
            end

            function Module:JCFStartEmpowerHandler(unitTarget)
                if unitTarget == "target" then
                    Module:CheckCastStatus("TargetEmpower")
                end
                if unitTarget == "focus" then
                    Module:CheckCastStatus("FocusEmpower")
                end
            end

            function Module:JCFSetGrey(unitTarget)
                if unitTarget == "target" then
                    JcfTargetFrameSpellBar:SetStatusBarColor(grey.r, grey.g, grey.b, grey.a) --Grey
                end

                if unitTarget == "focus" then
                    JcfFocusFrameSpellBar:SetStatusBarColor(grey.r, grey.g, grey.b, grey.a) --Grey
                end
            end

            function Module:JCFSetRed(unitTarget)
                if unitTarget == "target" then
                    JcfTargetFrameSpellBar:SetValue(select(2, TargetFrameSpellBar:GetMinMaxValues()) - 0.01)
                    JcfTargetFrameSpellBar:SetStatusBarColor(red.r, red.g, red.b, red.a) --Red

                    JcfTargetFrameSpellBar.Flash:SetVertexColor(red.r, red.g, red.b, red.a)

                    successfulCastBufferTarget = true

                    C_Timer.After(1.25, function() successfulCastBufferTarget = false end)
                end

                if unitTarget == "focus" then
                    JcfFocusFrameSpellBar:SetValue(select(2, FocusFrameSpellBar:GetMinMaxValues()) - 0.01)
                    JcfFocusFrameSpellBar:SetStatusBarColor(red.r, red.g, red.b, red.a) --Red

                    JcfFocusFrameSpellBar.Flash:SetVertexColor(red.r, red.g, red.b, red.a)

                    successfulCastBufferFocus = true

                    C_Timer.After(1.25, function() successfulCastBufferFocus = false end)
                end
            end

            function Module:JCFSetYellow(unitTarget)
                if unitTarget == "target" then
                    JcfTargetFrameSpellBar:SetStatusBarColor(yellow.r, yellow.g, yellow.b, yellow.a) --Yellow
                end

                if unitTarget == "focus" then
                    JcfFocusFrameSpellBar:SetStatusBarColor(yellow.r, yellow.g, yellow.b, yellow.a) --Yellow
                end
            end

            function Module:JCFSetGreen(unitTarget)
                if unitTarget == "target" then
                    JcfTargetFrameSpellBar:SetStatusBarColor(green.r, green.g, green.b, green.a) --Green
                end

                if unitTarget == "focus" then
                    JcfFocusFrameSpellBar:SetStatusBarColor(green.r, green.g, green.b, green.a) --Green
                end
            end

            function Module:JCFTargetChanged()
                if UnitChannelInfo("target") then
                    if select(10, UnitChannelInfo("target")) > 0 then
                        self:JCFStartEmpowerHandler("target")
                    elseif UnitChannelInfo("target") then
                        self:JCFStartChannelHandler("target")
                    end
                elseif UnitCastingInfo("target") then
                    self:JCFStartCastHandler("target")
                end
            end

            function Module:JCFFocusChanged()
                if UnitChannelInfo("focus") then
                    if select(10, UnitChannelInfo("focus")) > 0 then
                        self:JCFStartEmpowerHandler("focus")
                    elseif UnitChannelInfo("focus") then
                        self:JCFStartChannelHandler("focus")
                    end
                elseif UnitCastingInfo("focus") then
                    self:JCFStartCastHandler("focus")
                end
            end

            if not eventHandlerFrame then
                eventHandlerFrame = CreateFrame("Frame", "EventHandlerFrame")
            end

            eventHandlerFrame:RegisterEvent("UNIT_SPELLCAST_STOP")
            eventHandlerFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
            eventHandlerFrame:RegisterEvent("UNIT_SPELLCAST_EMPOWER_STOP")

            eventHandlerFrame:RegisterEvent("UNIT_SPELLCAST_START")
            eventHandlerFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
            eventHandlerFrame:RegisterEvent("UNIT_SPELLCAST_EMPOWER_START")

            eventHandlerFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
            eventHandlerFrame:RegisterEvent("PLAYER_FOCUS_CHANGED")

            eventHandlerFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE")
            eventHandlerFrame:RegisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE")
            eventHandlerFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
            eventHandlerFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
            --this event sucks and its awful dont use it 'UNIT_SPELLCAST_FAILED'

            local function EventHandlerGiga(self, event, unitTarget)
                if (unitTarget == "target" or unitTarget == "focus") then
                    if event == "UNIT_SPELLCAST_STOP" then
                        Module:JCFStopCastHandler(unitTarget)
                    elseif event == "UNIT_SPELLCAST_CHANNEL_STOP" then
                        Module:JCFStopChannelHandler(unitTarget)
                    elseif event == "UNIT_SPELLCAST_EMPOWER_STOP" then
                        Module:JCFStopEmpowerHandler(unitTarget)
                    elseif event == "UNIT_SPELLCAST_START" then
                        Module:JCFStartCastHandler(unitTarget)
                    elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
                        Module:JCFStartChannelHandler(unitTarget)
                    elseif event == "UNIT_SPELLCAST_EMPOWER_START" then
                        Module:JCFStartEmpowerHandler(unitTarget)
                    elseif event == "UNIT_SPELLCAST_INTERRUPTIBLE" then
                        if UnitChannelInfo(unitTarget) then
                            local numStages = select(10, UnitChannelInfo(unitTarget))
                            if not (numStages > 0) then
                                Module:JCFSetGreen(unitTarget)
                            else
                            end
                        else
                            if UnitCastingInfo(unitTarget) then
                                Module:JCFSetYellow(unitTarget)
                            end
                        end
                    elseif event == "UNIT_SPELLCAST_NOT_INTERRUPTIBLE" then
                        Module:JCFSetGrey(unitTarget)
                    elseif event == "UNIT_SPELLCAST_INTERRUPTED" then
                        Module:JCFSetRed(unitTarget)
                    elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
                        if not (UnitCastingInfo(unitTarget) and UnitChannelInfo(unitTarget)) then
                            if
                            unitTarget == "target" and (GetTime() > targetCastEndTime - 0.05) and
                                    not successfulCastBufferTarget
                            then
                                Module:JCFSetGreen(unitTarget)
                            elseif
                            unitTarget == "focus" and (GetTime() > focusCastEndTime - 0.05) and
                                    not successfulCastBufferFocus
                            then
                                Module:JCFSetGreen(unitTarget)
                            end
                        end
                    end
                else
                    if event == "PLAYER_TARGET_CHANGED" then
                        Module:JCFTargetChanged()
                    end
                    if event == "PLAYER_FOCUS_CHANGED" then
                        Module:JCFFocusChanged()
                    end
                end
            end
            eventHandlerFrame:SetScript("OnEvent", EventHandlerGiga)

            --the first function call of the session usually behaves odd. calling them like this fixes it somehow
            Module:JCFStopCastHandler()
            Module:JCFStopChannelHandler()
            Module:JCFStopEmpowerHandler()

            Module:JCFStartCastHandler()
            Module:JCFStartChannelHandler()
            Module:JCFStartEmpowerHandler()

            Module:JCFTargetChanged()
            Module:JCFFocusChanged()

            Module:JCFSetGrey()
            Module:JCFSetRed()
            Module:JCFSetYellow()
            Module:JCFSetGreen()
        else
            function Module:StopCastHandler(unitTarget)
                if unitTarget == "target" then
                    Module:CheckCastStatus("TargetCast")
                    if not isTargetCasting then
                        if (GetTime()) > (targetCastEndTime - 0.1) then
                            self:SetTargetBarType()
                        else
                            targetCastEndTime = targetCastEndTime + 999999

                            Module:SetRed(unitTarget)
                        end
                    end
                end

                if unitTarget == "focus" then
                    Module:CheckCastStatus("FocusCast")
                    if not isFocusCasting then
                        if (GetTime()) > (focusCastEndTime - 0.1) then
                            self:SetFocusBarType()
                        else
                            focusCastEndTime = focusCastEndTime + 999999

                            Module:SetRed(unitTarget)
                        end
                    end
                end
            end

            function Module:StartCastHandler(unitTarget)
                if unitTarget == "target" then
                    Module:CheckCastStatus("TargetCast")
                    if isTargetCasting then
                        local notInterruptible = select(8, UnitCastingInfo(unitTarget))
                        if notInterruptible then
                            Module:SetGrey(unitTarget)
                        else
                            Module:SetYellow(unitTarget)
                        end
                    end
                end

                if unitTarget == "focus" then
                    Module:CheckCastStatus("FocusCast")
                    if isFocusCasting then
                        local notInterruptible = select(8, UnitCastingInfo(unitTarget))
                        if notInterruptible then
                            Module:SetGrey(unitTarget)
                        else
                            Module:SetYellow(unitTarget)
                        end
                    end
                end
            end

            function Module:StopChannelHandler(unitTarget)
                if unitTarget == "target" then
                    Module:CheckCastStatus("TargetChannel")
                    if not isTargetCasting then
                        if not ((GetTime()) > (targetCastEndTime - 0.1)) then
                            Module:SetRed(unitTarget)
                        end
                    end
                end

                if unitTarget == "focus" then
                    Module:CheckCastStatus("FocusChannel")
                    if not isFocusCasting then
                        if not ((GetTime()) > (focusCastEndTime - 0.1)) then
                            Module:SetRed(unitTarget)
                        end
                    end
                end
            end

            function Module:StartChannelHandler(unitTarget)
                if unitTarget == "target" then
                    Module:CheckCastStatus("TargetChannel")
                    if isTargetCasting then
                        local notInterruptible = select(7, UnitChannelInfo(unitTarget))
                        if notInterruptible then
                            Module:SetGrey(unitTarget)
                        else
                            Module:SetGreen(unitTarget)
                        end
                    end
                end

                if unitTarget == "focus" then
                    Module:CheckCastStatus("FocusChannel")
                    if isFocusCasting then
                        local notInterruptible = select(7, UnitChannelInfo(unitTarget))
                        if notInterruptible then
                            Module:SetGrey(unitTarget)
                        else
                            Module:SetGreen(unitTarget)
                        end
                    end
                end
            end

            function Module:StopEmpowerHandler(unitTarget)
                if unitTarget == "target" then
                    Module:CheckCastStatus("TargetEmpower")
                    if not isTargetCasting then
                        if (GetTime()) > (targetCastEndTime - 0.1) then
                            Module:SetGreen(unitTarget)
                        else
                            targetCastEndTime = targetCastEndTime + 999999

                            TargetFrameSpellBar:SetValue(select(2, TargetFrameSpellBar:GetMinMaxValues()) - 0.01)
                            TargetFrameSpellBar:SetStatusBarColor(1, 0, 0, 1) --Red
                        end
                    end
                end

                if unitTarget == "focus" then
                    Module:CheckCastStatus("FocusEmpower")
                    if not isFocusCasting then
                        if (GetTime()) > (focusCastEndTime - 0.1) then
                            Module:SetGreen(unitTarget)
                        else
                            targetCastEndTime = targetCastEndTime + 999999

                            FocusFrameSpellBar:SetValue(select(2, FocusFrameSpellBar:GetMinMaxValues()) - 0.01)
                            FocusFrameSpellBar:SetStatusBarColor(1, 0, 0, 1) --Red
                        end
                    end
                end
            end

            function Module:StartEmpowerHandler(unitTarget)
                if unitTarget == "target" then
                    Module:CheckCastStatus("TargetEmpower")
                end
                if unitTarget == "focus" then
                    Module:CheckCastStatus("FocusEmpower")
                end
            end

            function Module:SetGrey(unitTarget)
                if unitTarget == "target" then
                    TargetFrameSpellBar:SetStatusBarColor(grey.r, grey.g, grey.b, grey.a) --Grey

                    self:SetTargetBarType()
                end

                if unitTarget == "focus" then
                    FocusFrameSpellBar:SetStatusBarColor(grey.r, grey.g, grey.b, grey.a) --Grey

                    self:SetFocusBarType()
                end
            end

            function Module:SetRed(unitTarget)
                if unitTarget == "target" then
                    TargetFrameSpellBar:SetValue(select(2, TargetFrameSpellBar:GetMinMaxValues()) - 0.01)
                    TargetFrameSpellBar:SetStatusBarColor(red.r, red.g, red.b, red.a) --Red

                    self:SetTargetBarType()

                    successfulCastBufferTarget = true

                    C_Timer.After(1.25, function() successfulCastBufferTarget = false end)
                end

                if unitTarget == "focus" then
                    FocusFrameSpellBar:SetValue(select(2, FocusFrameSpellBar:GetMinMaxValues()) - 0.01)
                    FocusFrameSpellBar:SetStatusBarColor(red.r, red.g, red.b, red.a) --Red

                    self:SetFocusBarType()

                    successfulCastBufferFocus = true

                    C_Timer.After(1.25, function() successfulCastBufferFocus = false end)
                end
            end

            function Module:SetYellow(unitTarget)
                if unitTarget == "target" then
                    TargetFrameSpellBar:SetStatusBarColor(yellow.r, yellow.g, yellow.b, yellow.a) --Yellow

                    self:SetTargetBarType()
                end

                if unitTarget == "focus" then
                    FocusFrameSpellBar:SetStatusBarColor(yellow.r, yellow.g, yellow.b, yellow.a) --Yellow

                    self:SetFocusBarType()
                end
            end

            function Module:SetGreen(unitTarget)
                if unitTarget == "target" then
                    TargetFrameSpellBar:SetStatusBarColor(green.r, green.g, green.b, green.a) --Green

                    self:SetTargetBarType()
                end

                if unitTarget == "focus" then
                    FocusFrameSpellBar:SetStatusBarColor(green.r, green.g, green.b, green.a) --Green

                    self:SetFocusBarType()
                end
            end

            function Module:TargetChanged()
                if UnitChannelInfo("target") then
                    if select(10, UnitChannelInfo("target")) > 0 then
                        self:StartEmpowerHandler("target")
                    elseif UnitChannelInfo("target") then
                        self:StartChannelHandler("target")
                    end
                elseif UnitCastingInfo("target") then
                    self:StartCastHandler("target")
                end
            end

            function Module:FocusChanged()
                if UnitChannelInfo("focus") then
                    if select(10, UnitChannelInfo("focus")) > 0 then
                        self:StartEmpowerHandler("focus")
                    elseif UnitChannelInfo("focus") then
                        self:StartChannelHandler("focus")
                    end
                elseif UnitCastingInfo("focus") then
                    self:StartCastHandler("focus")
                end
            end

            function Module:SetTargetBarType()
                TargetFrameSpellBar.barType = "standard" --DEN HER VIRKER

                local barTypeInfo = TargetFrameSpellBar:GetTypeInfo(TargetFrameSpellBar.barType)
                if barTypeInfo then
                    TargetFrameSpellBar:SetStatusBarTexture(barTypeInfo.full)
                    --print(barTypeInfo.full) --ui-castingbar-full-standard
                end
            end

            function Module:SetFocusBarType()
                FocusFrameSpellBar.barType = "standard" --DEN HER VIRKER

                local barTypeInfo = FocusFrameSpellBar:GetTypeInfo(FocusFrameSpellBar.barType)
                if barTypeInfo then
                    FocusFrameSpellBar:SetStatusBarTexture(barTypeInfo.full)
                    --print(barTypeInfo.full) --ui-castingbar-full-standard
                end
            end

            if not eventHandlerFrame then
                eventHandlerFrame = CreateFrame("Frame", "EventHandlerFrame")
            end

            eventHandlerFrame:RegisterEvent("UNIT_SPELLCAST_STOP")
            eventHandlerFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
            eventHandlerFrame:RegisterEvent("UNIT_SPELLCAST_EMPOWER_STOP")

            eventHandlerFrame:RegisterEvent("UNIT_SPELLCAST_START")
            eventHandlerFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
            eventHandlerFrame:RegisterEvent("UNIT_SPELLCAST_EMPOWER_START")

            eventHandlerFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
            eventHandlerFrame:RegisterEvent("PLAYER_FOCUS_CHANGED")

            eventHandlerFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE")
            eventHandlerFrame:RegisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE")
            eventHandlerFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
            eventHandlerFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
            --this event sucks and its awful dont use it 'UNIT_SPELLCAST_FAILED'

            local function EventHandlerGiga(self, event, unitTarget)
                if (unitTarget == "target" or unitTarget == "focus") then
                    if event == "UNIT_SPELLCAST_STOP" then
                        Module:StopCastHandler(unitTarget)
                    elseif event == "UNIT_SPELLCAST_CHANNEL_STOP" then
                        Module:StopChannelHandler(unitTarget)
                    elseif event == "UNIT_SPELLCAST_EMPOWER_STOP" then
                        Module:StopEmpowerHandler(unitTarget)
                    elseif event == "UNIT_SPELLCAST_START" then
                        Module:StartCastHandler(unitTarget)
                    elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
                        Module:StartChannelHandler(unitTarget)
                    elseif event == "UNIT_SPELLCAST_EMPOWER_START" then
                        Module:StartEmpowerHandler(unitTarget)
                    elseif event == "UNIT_SPELLCAST_INTERRUPTIBLE" then
                        if UnitChannelInfo(unitTarget) then
                            local numStages = select(10, UnitChannelInfo(unitTarget))
                            if not (numStages > 0) then
                                Module:SetGreen(unitTarget)
                            else
                            end
                        else
                            if UnitCastingInfo(unitTarget) then
                                Module:SetYellow(unitTarget)
                            end
                        end
                    elseif event == "UNIT_SPELLCAST_NOT_INTERRUPTIBLE" then
                        Module:SetGrey(unitTarget)
                    elseif event == "UNIT_SPELLCAST_INTERRUPTED" then
                        Module:SetRed(unitTarget)
                    elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
                        if not (UnitCastingInfo(unitTarget) and UnitChannelInfo(unitTarget)) then
                            if
                            unitTarget == "target" and (GetTime() > targetCastEndTime - 0.05) and
                                    not successfulCastBufferTarget
                            then
                                Module:SetGreen(unitTarget)
                            elseif
                            unitTarget == "focus" and (GetTime() > focusCastEndTime - 0.05) and
                                    not successfulCastBufferFocus
                            then
                                Module:SetGreen(unitTarget)
                            end
                        end
                    end
                else
                    if event == "PLAYER_TARGET_CHANGED" then
                        Module:TargetChanged()
                    end
                    if event == "PLAYER_FOCUS_CHANGED" then
                        Module:FocusChanged()
                    end
                end
            end
            eventHandlerFrame:SetScript("OnEvent", EventHandlerGiga)

            --the first function call of the session usually behaves odd. calling them like this fixes it somehow
            Module:StopCastHandler()
            Module:StopChannelHandler()
            Module:StopEmpowerHandler()

            Module:StartCastHandler()
            Module:StartChannelHandler()
            Module:StartEmpowerHandler()

            Module:TargetChanged()
            Module:FocusChanged()

            Module:SetGrey()
            Module:SetRed()
            Module:SetYellow()
            Module:SetGreen()
        end
    end
end

function Module:SetupUI()
    if not UnitAffectingCombat("player") then
        self:SetupCastBarColors()
    else
        C_Timer.After(5, function() self:SetupUI() end)
    end
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
    elseif WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC then
        return false -- wrath
    elseif WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        return false -- vanilla
    end
end
