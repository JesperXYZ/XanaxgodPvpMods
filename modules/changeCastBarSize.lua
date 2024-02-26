local _, XPM = ...;
local Main = XPM.Main;

local Module = Main:NewModule('ChangeCastBarSize', 'AceHook-3.0', 'AceEvent-3.0');

function Module:OnEnable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:OnDisable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:GetDescription()
    return 'This module allows you to change the cast bar size of your target and focus.';
end

function Module:GetName()
    return 'Change Cast Bar Size';
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

    local ChangeCastBarSizeImage = "|TInterface\\Addons\\XanaxgodPvpMods\\media\\moduleImages\\ChangeCastBarSize:147:480:5:-15|t"

    myOptionsTable.args.targetCastBarSize = {
        type = 'range',
        name = 'Target Cast Bar Size',
        order = counter(),
        get = get,
        set = set,
        min = 0.1,
        max = 2,
        step = 0.1,
        width = 1.2,
    };
    myOptionsTable.args.focusCastBarSize = {
        type = 'range',
        name = 'Focus Cast Bar Size',
        order = counter(),
        get = get,
        set = set,
        min = 0.1,
        max = 2,
        step = 0.1,
        width = 1.2,
    };
    myOptionsTable.args.art3 = {
        order = counter(),
        type = 'description',
        name = '' .. ChangeCastBarSizeImage,
        width = 'full',
    };

    return myOptionsTable;
end

function Module:SetupUI()
    if not UnitAffectingCombat('player') then
        if self:IsEnabled() then

            TargetFrameSpellBar:SetScale(self.db.targetCastBarSize)
            FocusFrameSpellBar:SetScale(self.db.focusCastBarSize)
        else
            TargetFrameSpellBar:SetScale(1)
            FocusFrameSpellBar:SetScale(1)

        end
    else
        C_Timer.After(10, function() self:SetupUI() end)
    end
end

function Module:RefreshUI()
    if self:IsEnabled() then
        self:Disable();
        self:Enable();
    end
end

function Module:CheckConditions()
    self:SetupUI()
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