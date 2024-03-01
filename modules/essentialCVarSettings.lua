local _, XPM = ...;
local Main = XPM.Main;

local Module = Main:NewModule('EssentialCVarSettings', 'AceHook-3.0', 'AceEvent-3.0');

function Module:OnEnable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:OnDisable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:GetDescription()
    return 'This module simplifies changing the value of console variables that really should be available through the default WoW settings.';
end

function Module:GetName()
    return 'Essential CVar Settings';
end

function Module:GetOptions(myOptionsTable, db)
    self.db = db;
    local defaults = {
        softTargetInteractToggle = true,
        nameplateOpacityToggle = false,
        spellQueueWindowRange = tonumber(GetCVar("SpellQueueWindow")),
    }
    for key, value in pairs(defaults) do
        if self.db[key] == nil then
            self.db[key] = value;
        end
    end
    local get = function(info)
        return self.db[info[#info]];
    end
    local getSpellQueueWindow = function(info)
        return tonumber(GetCVar("SpellQueueWindow"))
    end
    local set = function(info, value)
        local setting = info[#info];
        self.db[setting] = value;

        if setting == 'softTargetInteractToggle' then
            self:RefreshUI()
        end
        if setting == 'spellQueueWindowRange' then
            self:RefreshUI()
        end
        if setting == 'nameplateOpacityToggle' then
            self:RefreshUI()
        end
    end

    local counter = CreateCounter(5);

    myOptionsTable.args.softTargetInteract = {
        order = counter(),
        name = "SoftTarget CVars",
        type = "group",
        inline = true, --inline makes it a normal group. else it is a tab group (myOptionsTable in core.lua)
        args = {
            softTargetInteractDesc = {
                order = counter(),
                type = 'description',
                name = 'Setting the value of these CVars to 0 fixes the odd interaction that sometimes makes your focus macros go on your current target.',
                width = 'full',
            },
            softTargetInteractToggle = {
                type = 'toggle',
                name = 'Auto set value',
                desc = 'Automatically sets the CVar values to 0 upon logging in (some CVars are character specific)',
                order = counter(),
                width = 0.7,
                get = get,
                set = set,
            },
            softTargetInteractSetOnce = {
                type = 'execute',
                name = 'Set Value Once',
                desc = 'SetCVar("SoftTargetInteract",0) SetCVar("SoftTargetEnemyRange",0) SetCVar("SoftTargetFriendRange",0)',
                width = 0.8,
                func = function()
                    self:SetValueOnce('softTargetInteract')
                end,
                order = counter(),
            },
            softTargetInteractReset = {
                type = 'execute',
                name = 'Reset to Default',
                desc = 'SetCVar("SoftTargetInteract",1) SetCVar("SoftTargetEnemyRange",45) SetCVar("SoftTargetFriendRange",45)',
                width = 0.8,
                func = function()
                    self:ResetToDefault('softTargetInteract')
                end,
                order = counter(),
            },
        }
    }
    myOptionsTable.args.nameplateOpacity = {
        order = counter(),
        name = "Nameplate Opacity CVars",
        type = "group",
        inline = true, --inline makes it a normal group. else it is a tab group (myOptionsTable in core.lua)
        args = {
            nameplateOpacityDesc = {
                order = counter(),
                type = 'description',
                name = 'These CVars act as multipliers for the opacity of your nameplates. When set to a value of 1, these CVars make nameplates more visible through pillars and more visible for targets at greater distances.',
                width = 'full',
            },
            nameplateOpacityToggle = {
                type = 'toggle',
                name = 'Auto set value',
                desc = 'Automatically sets the CVar values to 1 upon logging in (some CVars are character specific)',
                order = counter(),
                width = 0.7,
                get = get,
                set = set,
            },
            nameplateOpacitySetOnce = {
                type = 'execute',
                name = 'Set Value Once',
                desc = 'SetCVar("nameplateMinAlpha",1) SetCVar("nameplateOccludedAlphaMult",1)',
                width = 0.8,
                func = function()
                    self:SetValueOnce('nameplateOpacity')
                end,
                order = counter(),
            },
            nameplateOpacityReset = {
                type = 'execute',
                name = 'Reset to Default',
                desc = 'SetCVar("nameplateMinAlpha",0.6) SetCVar("nameplateOccludedAlphaMult",0.4)',
                width = 0.8,
                func = function()
                    self:ResetToDefault('nameplateOpacity')
                end,
                order = counter(),
            },
        },
    }
    myOptionsTable.args.spellQueueWindow = {
        order = counter(),
        name = "SpellQueueWindow",
        type = "group",
        inline = true,
        args = {
            spellQueueWindowDesc = {
                order = counter(),
                type = 'description',
                name = 'This CVar determines the duration of queuing consecutive spell casts in milliseconds. Raising this value may reduce gaps/delays between abilities.',
                width = 'full',
            },
            spellQueueWindowRange = {
                type = 'range',
                name = 'SpellQueueWindow Value',
                order = counter(),
                get = getSpellQueueWindow,
                set = set,
                min = 1,
                max = 400,
                step = 1,
                width = 1.5,
            },
            spellQueueWindowReset = {
                type = 'execute',
                name = 'Reset to Default',
                desc = 'SetCVar("SpellQueueWindow", 400)',
                width = 0.8,
                func = function()
                    self.db.spellQueueWindowRange = 400;
                    self:ResetToDefault('spellQueueWindow')
                end,
                order = counter(),
            },
        }
    }

    return myOptionsTable;
end

function Module:SetupUI()
    if not UnitAffectingCombat('player') then
        if self:IsEnabled() then
            if self.db.softTargetInteractToggle == true then
                self:SetValueOnce('softTargetInteract')
            end
            if self.db.nameplateOpacityToggle == true then
                self:SetValueOnce('nameplateOpacity')

                if IsAddOnLoaded("BetterBlizzPlates") then
                    self:RegisterEvent("PLAYER_ENTERING_WORLD", "SetupUI");
                    self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "SetupUI");
                    self:RegisterEvent("GROUP_ROSTER_UPDATE", "SetupUI");
                    C_Timer.After(1, function() self:SetValueOnce('nameplateOpacity') end)
                end

            end
            self:SetValueOnce('spellQueueWindow')

        end
    end
end

function Module:SetValueOnce(input)
    if self:IsEnabled() then
        if input == 'softTargetInteract' then
            SetCVar("SoftTargetInteract", 0)
            SetCVar("SoftTargetEnemyRange", 0)
            SetCVar("SoftTargetFriendRange", 0)
        end
        if input == 'spellQueueWindow' then
            SetCVar("SpellQueueWindow", self.db.spellQueueWindowRange)
        end
        if input == 'nameplateOpacity' then
            SetCVar("nameplateMinAlpha", 1)
            SetCVar("nameplateOccludedAlphaMult", 1)
        end
    end
end

function Module:ResetToDefault(input)
    if self:IsEnabled() then
        if input == 'softTargetInteract' then
            self.db.softTargetInteractToggle = false;
            SetCVar("SoftTargetInteract", 1)
            SetCVar("SoftTargetEnemyRange", 45)
            SetCVar("SoftTargetFriendRange", 45)
        end
        if input == 'spellQueueWindow' then
            SetCVar("SpellQueueWindow", 400)
        end
        if input == 'nameplateOpacity' then
            self.db.nameplateOpacityToggle = false;
            SetCVar("nameplateMinAlpha", 0.6)
            SetCVar("nameplateOccludedAlphaMult", 0.4)
        end
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
        return true -- retail
    elseif WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC then
        return false -- wrath
    elseif WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        return false -- vanilla
    end
end