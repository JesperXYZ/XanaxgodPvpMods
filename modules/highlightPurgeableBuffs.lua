local _, XPM = ...;
local Main = XPM.Main;

local Module = Main:NewModule('HighlightPurgeableBuffs', 'AceHook-3.0', 'AceEvent-3.0');

function Module:OnEnable()
    self:CheckConditions()
end

function Module:OnDisable()
    self:CheckConditions()
end

function Module:GetDescription()
    return 'This module allows you to highlight the purgeable buffs of your target and focus as if your current class/spec has an offensive dispell ability.';
end

function Module:GetName()
    return 'Highlight Purgeable Buffs';
end

function Module:GetOptions(myOptionsTable, db)
    self.db = db;
    local defaults = {}
    for key, value in pairs(defaults) do
        if self.db[key] == nil then
            self.db[key] = value;
        end
    end

    local counter = CreateCounter(5);

    local get = function(info)
        return self.db[info[#info]];
    end
    local set = function(info, value)
        local setting = info[#info];
        self.db[setting] = value;

        if setting == 'enableForEveryone' then
            self:RefreshUI()
        end
    end

    local HighlightPurgeableBuffsImage = "|TInterface\\Addons\\XanaxgodPvpMods\\media\\moduleImages\\HighlightPurgeableBuffs:145:234:132:-15|t"

    myOptionsTable.args.enableForEveryone = {
        order = counter(),
        type = 'toggle',
        name = 'Highlight purgeable buffs for friendly targets as well',
        desc = 'Highlights purgeable buffs for friendly targets as well',
        width = 'full',
        get = get,
        set = set,
    };
    myOptionsTable.args.art3 = {
        order = counter(),
        type = 'description',
        name = '' .. HighlightPurgeableBuffsImage,
        width = 'full',
    };
    myOptionsTable.args.empty3152 = {
        order = counter(),
        type = 'description',
        name = ' ',
        width = 'full',
    };
    myOptionsTable.args.empty31522 = {
        order = counter(),
        type = 'description',
        name = ' ',
        width = 'full',
    };
    myOptionsTable.args.empty315222 = {
        order = counter(),
        type = 'description',
        name = ' ',
        width = 'full',
    };
    myOptionsTable.args.IMPORTANT = {
        order = counter(),
        type = 'description',
        name = 'IMPORTANT: As of the 26th of January 2024 this module is no longer compatible with JaxClassicFrames. To enable this function for JaxClassicFrames do the following.',
        width = 'full',
    };
    myOptionsTable.args.IMPORTANT3 = {
        order = counter(),
        type = 'description',
        name = ' 1.  Go to \\Interface\\Addons\\JaxClassicFrames\\JcfTargetFrame\\JcfTargetFrame.lua',
        width = 'full',
    };
    myOptionsTable.args.IMPORTANT4 = {
        order = counter(),
        type = 'description',
        name = ' 2.  Go to line 528 (Version 2.1.4) (Ctrl-F search for "local frameStealable")',
        width = 'full',
    };
    myOptionsTable.args.IMPORTANT5 = {
        order = counter(),
        type = 'description',
        name = ' 3.  Replace the " canStealOrPurge " variable with " debuffType=="Magic" " ',
        width = 'full',
    };

    return myOptionsTable;
end

function Module:SetupUI()

    if self:IsEnabled() and not self.db.enableForEveryone then

        local function UpdateAurasOnlyHostileTarget(self)
            if UnitIsEnemy("player","target") then
                for buff in self.auraPools:GetPool("TargetBuffFrameTemplate"):EnumerateActive() do
                    local data=C_UnitAuras.GetAuraDataByAuraInstanceID(buff.unit,buff.auraInstanceID);
                    buff.Stealable:SetShown(data.isStealable or data.dispelName=="Magic");
                end
            end
        end

        local function UpdateAurasOnlyHostileFocus(self)
            if UnitIsEnemy("player","focus") then
                for buff in self.auraPools:GetPool("TargetBuffFrameTemplate"):EnumerateActive() do
                    local data=C_UnitAuras.GetAuraDataByAuraInstanceID(buff.unit,buff.auraInstanceID);
                    buff.Stealable:SetShown(data.isStealable or data.dispelName=="Magic");
                end
            end
        end

        self:SecureHook(TargetFrame, "UpdateAuras", UpdateAurasOnlyHostileTarget);
        self:SecureHook(FocusFrame, "UpdateAuras", UpdateAurasOnlyHostileFocus);

    elseif self:IsEnabled() then

        local function UpdateAurasEveryone(self)
            for buff in self.auraPools:GetPool("TargetBuffFrameTemplate"):EnumerateActive() do
                local data=C_UnitAuras.GetAuraDataByAuraInstanceID(buff.unit,buff.auraInstanceID);
                buff.Stealable:SetShown(data.isStealable or data.dispelName=="Magic");
            end
        end

        self:SecureHook(TargetFrame, "UpdateAuras", UpdateAurasEveryone);
        self:SecureHook(FocusFrame, "UpdateAuras", UpdateAurasEveryone);

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