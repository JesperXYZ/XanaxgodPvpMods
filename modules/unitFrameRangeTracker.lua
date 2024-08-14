local _, XPM = ...
local Main = XPM.Main

local Module = Main:NewModule("UnitFrameRangeTracker", "AceHook-3.0", "AceEvent-3.0")

local rc = LibStub("LibRangeCheck-3.0")

function Module:OnEnable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:OnDisable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:GetDescription()
    return "This module displays a frame that shows the distance between you and your target. The range-frame is anchored to the target-frame."
end

function Module:GetName()
    return "Unit Frame Range Tracker"
end

function Module:GetOptions(myOptionsTable, db)
    self.db = db
    local defaults = {
        fontSize = 1.7,
        fontOpacity = 1,
        xPosition = 0,
        yPosition = 0,
        always = false,
        buff = false,
        buffTextfield = "",
        debuff = true,
        debuffTextfield = "Shadow Sight"
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

        if setting == "fontOpacity" then
            self:RefreshUI()
        end
        if setting == "fontSize" then
            self:RefreshUI()
        end
        if setting == "xPosition" then
            self:RefreshUI()
        end
        if setting == "yPosition" then
            self:RefreshUI()
        end
        if setting == "always" then
            self.db.buff = false
            self.db.debuff = false
            self:RefreshUI()
        end
        if setting == "buff" then
            self.db.debuff = false
            self.db.always = false
            self:RefreshUI()
        end
        if setting == "buffTextfield" then
            self:RefreshUI()
        end
        if setting == "debuff" then
            self.db.buff = false
            self.db.always = false
            self:RefreshUI()
        end
        if setting == "debuffTextfield" then
            self:RefreshUI()
        end
    end
    local counter = CreateCounter(5)

    myOptionsTable.args.resetToDefault = {
        order = counter(),
        type = "execute",
        name = "Reset to Default",
        desc = "Reset scale and transparency to default values.",
        width = 0.75,
        func = function()
            self.db.fontSize = defaults.fontSize
            self.db.fontOpacity = defaults.fontOpacity
            self.db.xPosition = defaults.xPosition
            self.db.yPosition = defaults.yPosition
            self.db.always = defaults.always
            self.db.buff = defaults.buff
            self.db.buffTextfield = defaults.buffTextfield
            self.db.debuff = defaults.debuff
            self.db.debuffTextfield = defaults.debuffTextfield
            self:RefreshUI()
        end,
    }
    myOptionsTable.args.iconGroup = {
        order = counter(),
        name = "Range Frame Settings",
        type = "group",
        inline = true, --inline makes it a normal group. else it is a tab group (myOptionsTable in core.lua)
        args = {
            fontSize = {
                type = "range",
                name = "Font Size",
                order = counter(),
                get = get,
                set = set,
                min = 0,
                max = 3,
                step = 0.1,
                width = 1.05
            },
            fontOpacity = {
                type = "range",
                name = "Font Opacity",
                order = counter(),
                get = get,
                set = set,
                min = 0,
                max = 1,
                step = 0.1,
                width = 1.05
            },
            xPosition = {
                type = "range",
                name = "x-Position",
                order = counter(),
                get = get,
                set = set,
                min = -500,
                max = 500,
                step = 5,
                width = 1.05
            },
            yPosition = {
                type = "range",
                name = "y-Position",
                order = counter(),
                get = get,
                set = set,
                min = -500,
                max = 500,
                step = 5,
                width = 1.05
            }
        }
    }
    myOptionsTable.args.triggerGroup = {
        order = counter(),
        name = "Range Frame Triggers",
        type = "group",
        inline = true, --inline makes it a normal group. else it is a tab group (myOptionsTable in core.lua)
        args = {
            always = {
                type = "toggle",
                name = "Show always",
                order = counter(),
                get = get,
                set = set,
                width = "full"
            },
            buff = {
                type = "toggle",
                name = "Show when buffed",
                order = counter(),
                get = get,
                set = set,
                width = 1
            },
            buffTextfield = {
                type = "input",
                name = "Buff Name",
                order = counter(),
                get = get,
                set = set,
                width = 1.1
            },
            debuff = {
                type = "toggle",
                name = "Show when debuffed",
                order = counter(),
                get = get,
                set = set,
                width = 1
            },
            debuffTextfield = {
                type = "input",
                name = "Debuff Name",
                order = counter(),
                get = get,
                set = set,
                width = 1.1
            }
        }
    }

    return myOptionsTable
end

function Module:ShowRangeFrame()
    if self:IsEnabled() and (self.db.always or self.db.buff or self.db.debuff) then
        C_Timer.After(0.1, function() self:ShowRangeFrame() end)

        if self.db.always then
            rangeFrame:Show()
            self.UpdateRange()

        elseif self.db.buff and not rangeFrame:IsShown() then
            for i = 1, 40 do
                local D = C_UnitAuras.GetBuffDataByIndex("player", i)
                if D ~= nil then
                    if D.name == self.db.buffTextfield then
                        if D.expirationTime then
                            if D.expirationTime > 0 then
                                local expireTime = D.expirationTime - GetTime()
                                local a = 0
                                repeat
                                    C_Timer.After(a, function() self:UpdateRange() end)
                                    a = a + 0.1
                                until a > expireTime
                                rangeFrame:Show()

                                if expireTime < 0 then
                                    C_Timer.After(0.1, function() rangeFrame:Hide() end)
                                else
                                    C_Timer.After(expireTime, function() rangeFrame:Hide() end)
                                end
                            end
                        end
                    end
                end
            end


        elseif self.db.debuff and not rangeFrame:IsShown() then
            for i = 1, 40 do
                local D = C_UnitAuras.GetDebuffDataByIndex("player", i)
                if D ~= nil then
                    if D.name == self.db.debuffTextfield then
                        if D.expirationTime then
                            if D.expirationTime > 0 then
                                local expireTime = D.expirationTime - GetTime()
                                local a = 0
                                repeat
                                    C_Timer.After(a, function() self:UpdateRange() end)
                                    a = a + 0.1
                                until a > expireTime
                                rangeFrame:Show()

                                if expireTime < 0 then
                                    C_Timer.After(0.1, function() rangeFrame:Hide() end)
                                else
                                    C_Timer.After(expireTime, function() rangeFrame:Hide() end)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function Module:UpdateRange()
    if UnitExists("target") then
        local minRange, maxRange = rc:GetRange("target")
        if minRange == nil then
            minRange = 0
        end
        if maxRange == nil then
            maxRange = 1
        end

        if minRange > 100 then
            return
        else
            local bestRange = (minRange + maxRange) / 2

            local restOfBestRange = bestRange % 1

            local realRange = bestRange - restOfBestRange

            if realRange > 40 then
                rangeFrameText:SetTextColor(1, 0.5, 0)
            elseif realRange < 20 then
                rangeFrameText:SetTextColor(0.6, 1, 0)
            else
                rangeFrameText:SetTextColor(1, 1, 0)
            end

            rangeFrameText:SetFormattedText(realRange)
        end
    else
        rangeFrame:Hide()
    end
end

function Module:SetupUI()
    local minRange, maxRange = rc:GetRange("target")
    if minRange == nil then
        minRange = 0
    end

    if rangeFrame == nil then
        if C_AddOns.IsAddOnLoaded("JaxClassicFrames") then
            rangeFrame = CreateFrame("Frame", "RangeFrame", JcfTargetFrame)
        else
            rangeFrame = CreateFrame("Frame", "RangeFrame", TargetFrame)
        end
        rangeFrame:SetFrameStrata("BACKGROUND")
        rangeFrame:SetWidth(128)
        rangeFrame:SetHeight(64)

        rangeFrame:SetPoint("RIGHT", 0, 0)

        rangeFrameText = rangeFrame:CreateFontString("RangeFrameText", "ARTWORK", "GameFontNormal")
        rangeFrameText:SetFont(GameFontNormal:GetFont(), 24, "black")
        rangeFrameText:SetJustifyH("CENTER")
        rangeFrameText:SetPoint("LEFT", rangeFrame, "RIGHT", 2, 0)
        rangeFrameText:SetFormattedText(minRange)

        rangeFrame:Hide()
    end
end

function Module:Adjustments()
    rangeFrameText:SetTextColor(1, 1, 1, self.db.fontOpacity)
    rangeFrameText:SetScale(self.db.fontSize)

    rangeFrame:SetPoint("RIGHT", 0 + self.db.xPosition, 0 + self.db.yPosition)
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
        self:Adjustments()
        self:ShowRangeFrame()
    else
        rangeFrameText:SetFormattedText("")
        rangeFrame:Hide()
    end
end

function Module:IsAvailableForCurrentVersion()
    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
        return true -- retail
    elseif WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC then
        return false -- cata
    elseif WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        return false -- vanilla
    end
end
