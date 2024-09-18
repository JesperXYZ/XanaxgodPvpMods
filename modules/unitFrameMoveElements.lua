local _, XPM = ...
local Main = XPM.Main

local Module = Main:NewModule("UnitFrameMoveElements", "AceHook-3.0", "AceEvent-3.0")

function Module:OnEnable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:OnDisable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:GetDescription()
    return "This module allows you to move specific elements of your unit frames."
end

function Module:GetName()
    return "Unit Frame Move Elements"
end

function Module:GetOptions(myOptionsTable, db)
    self.db = db
    local defaults = {
        moveCastBarToggle = false,
        targetPositionX = 0,
        targetPositionY = 33,

        focusPositionX = 0,
        focusPositionY = 33,


        moveToTToggle = false,
        toTPositionX = 120,
        toTPositionY = -31,

        toFPositionX = 120,
        toFPositionY = -31,


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

        self:RefreshUI()
    end

    local counter = CreateCounter(5)
    myOptionsTable.args.empty75133 = {
        order = counter(),
        type = "description",
        name = " ",
        width = 0.8
    }
    myOptionsTable.args.reloadExecute = {
        type = "execute",
        name = "/reload",
        desc = "You should reload your UI after changing options for this module.",
        width = 0.45,
        func = function()
            ReloadUI()
        end,
        order = counter()
    }
    myOptionsTable.args.moveCastBarGroup = {
        order = counter(),
        name = "Move Unit Frame Cast Bars",
        type = "group",
        args = {
            moveCastBarToggle = {
                type = "toggle",
                name = 'Enable',
                desc = "This will enable the ability to move the Cast Bar of your target/focus",
                order = counter(),
                width = "full",
                get = get,
                set = set
            },
            moveTargetCastBarGroup = {
                order = counter(),
                name = "Target Cast Bar",
                type = "group",
                inline = true, --inline makes it a normal group. else it is a tab group (myOptionsTable in core.lua)
                args = {
                    targetPositionX = {
                        type = "range",
                        name = "x-Position",
                        order = counter(),
                        get = get,
                        set = set,
                        min = -500,
                        max = 500,
                        step = 1,
                        width = 1
                    },
                    targetPositionY = {
                        type = "range",
                        name = "y-Position",
                        order = counter(),
                        get = get,
                        set = set,
                        min = -500,
                        max = 500,
                        step = 1,
                        width = 1
                    }
                }
            },
            moveFocusCastBarGroup = {
                order = counter(),
                name = "Focus Cast Bar",
                type = "group",
                inline = true, --inline makes it a normal group. else it is a tab group (myOptionsTable in core.lua)
                args = {
                    focusPositionX = {
                        type = "range",
                        name = "x-Position",
                        order = counter(),
                        get = get,
                        set = set,
                        min = -500,
                        max = 500,
                        step = 1,
                        width = 1
                    },
                    focusPositionY = {
                        type = "range",
                        name = "y-Position",
                        order = counter(),
                        get = get,
                        set = set,
                        min = -500,
                        max = 500,
                        step = 1,
                        width = 1
                    }
                }
            }
        }
    }
    myOptionsTable.args.moveToTGroup = {
        order = counter(),
        name = "Move Target of Target Frame",
        type = "group",
        args = {
            moveToTToggle = {
                type = "toggle",
                name = 'Enable',
                desc = "This will enable the ability to move the Target of Target Frame",
                order = counter(),
                width = "full",
                get = get,
                set = set
            },
            moveTargetToTGroup = {
                order = counter(),
                name = "Target of Target Frame",
                type = "group",
                inline = true, --inline makes it a normal group. else it is a tab group (myOptionsTable in core.lua)
                args = {
                    toTPositionX = {
                        type = "range",
                        name = "x-Position",
                        order = counter(),
                        get = get,
                        set = set,
                        min = -500,
                        max = 500,
                        step = 1,
                        width = 1
                    },
                    toTPositionY = {
                        type = "range",
                        name = "y-Position",
                        order = counter(),
                        get = get,
                        set = set,
                        min = -500,
                        max = 500,
                        step = 1,
                        width = 1
                    }
                }
            },
            moveFocusToTGroup = {
                order = counter(),
                name = "Target of Focus Frame",
                type = "group",
                inline = true, --inline makes it a normal group. else it is a tab group (myOptionsTable in core.lua)
                args = {
                    toFPositionX = {
                        type = "range",
                        name = "x-Position",
                        order = counter(),
                        get = get,
                        set = set,
                        min = -500,
                        max = 500,
                        step = 1,
                        width = 1
                    },
                    toFPositionY = {
                        type = "range",
                        name = "y-Position",
                        order = counter(),
                        get = get,
                        set = set,
                        min = -500,
                        max = 500,
                        step = 1,
                        width = 1
                    }
                }
            }
        }
    }


    return myOptionsTable
end


function Module:MoveCastBar()
    local enabled
    if self:IsEnabled() then
        enabled = self.db.moveCastBarToggle
    else
        enabled = false
    end

    if enabled then
        local targetPoint, targetPointX, targetPointY = "CENTER", self.db.targetPositionX, self.db.targetPositionY

        if self:IsHooked(TargetFrame, "OnUpdate") then
            return
        end

        self:SecureHook(TargetFrame, "OnUpdate", function()

            local oldTargetPoint, oldTargetPointX, oldTargetPointY = TargetFrameSpellBar:GetPoint(1)

            if not (oldTargetPointX == targetPointX) or not (oldTargetPointY == targetPointY) then
                TargetFrameSpellBar:SetMovable(true);
                TargetFrameSpellBar:ClearAllPoints();
                TargetFrameSpellBar:SetPoint(targetPoint, targetPointX, targetPointY);
                TargetFrameSpellBar:SetUserPlaced(true);
                TargetFrameSpellBar:SetMovable( false );
            end
        end)

        local focusPoint, focusPointX, focusPointY = "CENTER", self.db.focusPositionX, self.db.focusPositionY

        self:SecureHook(FocusFrame, "OnUpdate", function()

            local oldFocusPoint, oldFocusPointX, oldFocusPointY = FocusFrameSpellBar:GetPoint(1)

            if not (oldFocusPointX == focusPointX) or not (oldFocusPointY == focusPointY) then
                FocusFrameSpellBar:SetMovable(true);
                FocusFrameSpellBar:ClearAllPoints();
                FocusFrameSpellBar:SetPoint(focusPoint, focusPointX, focusPointY);
                FocusFrameSpellBar:SetUserPlaced(true);
                FocusFrameSpellBar:SetMovable( false );
            end
        end)
    end
end


function Module:MoveToTFrame()
    local enabled
    if self:IsEnabled() then
        enabled = self.db.moveToTToggle
    else
        enabled = false
    end

    if enabled then
        if GetCVar("showTargetOfTarget") == "1" then
            local targetPoint, targetPointX, targetPointY = "CENTER", self.db.toTPositionX, self.db.toTPositionY

            TargetFrameToT:SetMovable(true);
            TargetFrameToT:ClearAllPoints();
            TargetFrameToT:SetPoint("CENTER", targetPointX, targetPointY);
            TargetFrameToT:SetUserPlaced(true);
            TargetFrameToT:SetMovable( false );


            local focusPoint, focusPointX, focusPointY = "CENTER", self.db.toFPositionX, self.db.toFPositionY

            FocusFrameToT:SetMovable(true);
            FocusFrameToT:ClearAllPoints();
            FocusFrameToT:SetPoint("CENTER", focusPointX, focusPointY);
            FocusFrameToT:SetUserPlaced(true);
            FocusFrameToT:SetMovable( false );
        end
    end
end

function Module:SetupUI()
    if self:IsEnabled() then
        self:MoveCastBar()
        self:MoveToTFrame()
    end
end


function Module:RefreshUI()
    if self:IsEnabled() then
        self:Disable()
        self:Enable()
    end
end

function Module:CheckConditions()
    if not UnitAffectingCombat("player") then
        self:SetupUI()
    else
        C_Timer.After(5, function() self:CheckConditions() end)
    end
end


function Module:IsAvailableForCurrentVersion()
    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
        if C_AddOns.IsAddOnLoaded("JaxClassicFrames") then
            return false -- retail
        else
            return true -- retail
        end
    elseif WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC then
        return false -- cata
    elseif WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        return false -- vanilla
    end
end
