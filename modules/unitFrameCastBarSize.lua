local _, XPM = ...;
local Main = XPM.Main;

local Module = Main:NewModule('UnitFrameCastBarSize', 'AceHook-3.0', 'AceEvent-3.0');

function Module:OnEnable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:OnDisable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:GetDescription()
    return 'This module allows you to change the cast bar size of your target/focus.';
end

function Module:GetName()
    return 'Unit Frame Cast Bar Size';
end

function Module:GetOptions(myOptionsTable, db)
    self.db = db;
    local defaults = {
        targetCastBarSize = 1.3,
        focusCastBarSize = 1.3,
    }
    for key, value in pairs(defaults) do
        if self.db[key] == nil then
            self.db[key] = value;
        end
    end

    local get = function(info)
        return self.db[info[#info]];
    end
    local set = function(info, value)
        local setting = info[#info];
        self.db[setting] = value;

        if setting == 'targetCastBarSize' then
            self:RefreshUI()
        end
        if setting == 'focusCastBarSize' then
            self:RefreshUI()
        end
    end

    local counter = CreateCounter(5);

    --local UnitFrameCastBarSizeImage = "|TInterface\\Addons\\XanaxgodPvpMods\\media\\moduleImages\\UnitFrameCastBarSize:147:480:5:-15|t"
    local UnitFrameCastBarSizeImage = "|TInterface\\Addons\\XanaxgodPvpMods\\media\\moduleImages\\UnitFrameCastBarSize:152:490:5:-1|t"

    myOptionsTable.args.castBarSizeGroup = {
        order = counter(),
        name = "Change Cast Bar Size",
        type = "group",
        inline = true, --inline makes it a normal group. else it is a tab group (myOptionsTable in core.lua)
        args = {
            targetCastBarSize = {
                type = 'range',
                name = 'Target Cast Bar Size',
                order = counter(),
                get = get,
                set = set,
                min = 0.1,
                max = 2,
                step = 0.1,
                width = 1.1,
            };
            focusCastBarSize = {
                type = 'range',
                name = 'Focus Cast Bar Size',
                order = counter(),
                get = get,
                set = set,
                min = 0.1,
                max = 2,
                step = 0.1,
                width = 1.1,
            };
        }
    }
    myOptionsTable.args.art3 = {
        order = counter(),
        type = 'description',
        name = '' .. UnitFrameCastBarSizeImage,
        width = 'full',
    };

    return myOptionsTable;
end

function Module:SetupCastBarSize()
    if self:IsEnabled() then

        TargetFrameSpellBar:SetScale(self.db.targetCastBarSize)
        C_Timer.After(2, function() TargetFrameSpellBar:SetScale(self.db.targetCastBarSize) end)
        if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE or WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC then
            FocusFrameSpellBar:SetScale(self.db.focusCastBarSize)
            C_Timer.After(2, function() FocusFrameSpellBar:SetScale(self.db.focusCastBarSize) end)
        end
    else
        TargetFrameSpellBar:SetScale(1)
        if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE or WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC then
            FocusFrameSpellBar:SetScale(1)
        end
    end
end

function Module:SetupUI()
    if not UnitAffectingCombat('player') then
        self:SetupCastBarSize()
    else
        C_Timer.After(5, function() self:SetupUI() end)
    end
end

function Module:RefreshUI()
    if self:IsEnabled() then
        self:Disable();
        self:Enable();
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
        if IsAddOnLoaded("JaxClassicFrames") then
            return false
        else
            return true -- retail
        end
    elseif WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC then
        return true -- wrath
    elseif WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        return true -- vanilla
    end
end