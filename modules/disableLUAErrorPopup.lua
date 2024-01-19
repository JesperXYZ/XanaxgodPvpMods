local _, XPM = ...;
local Main = XPM.Main;

local Module = Main:NewModule('DisableLUAErrorPopup', 'AceHook-3.0', 'AceEvent-3.0');

function Module:OnEnable()
    self:CheckConditions()
end

function Module:OnDisable()
    self:CheckConditions()
end

function Module:GetDescription()
    return 'This module disables the "your AddOns are experiencing a large number of errors..." popup that is so frequently occurring in Dragonflight.';
end

function Module:GetName()
    return 'Disable LUA Error Popup';
end

function Module:GetOptions(myOptionsTable, db)
    self.db = db;
    local defaults = {
        enableInArenaOnly = false,
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

        if setting == 'enableInArenaOnly' then
            self:RefreshUI();
        end

    end
    local counter = CreateCounter(5);

    local DisableLUAErrorPopupImage = "|TInterface\\Addons\\XanaxgodPvpMods\\media\\moduleImages\\DisableLUAErrorPopup:383:500:2:-1|t"

    myOptionsTable.args.enableInArenaOnly = {
        order = counter(),
        type = 'toggle',
        name = 'Disable module when not in a raid/dungeon/arena/battleground',
        desc = 'Disables the module when you are not in a raid/dungeon/arena/battleground',
        width = 'full',
        get = get,
        set = set,
    };
    myOptionsTable.args.empty7513 = {
        order = counter(),
        type = 'description',
        name = ' ',
        width = 'full',
    };
    myOptionsTable.args.art1 = {
        order = counter(),
        type = 'description',
        name = '' .. DisableLUAErrorPopupImage,
        width = 'full',
    };

    return myOptionsTable;
end

function Module:SetupUI()
    if self.db.enableInArenaOnly and not self:IsPlayerInPvPZone() then

        self:EnableLuaErrorsPopup()

    else

        local function SuppressLuaErrorsPopup()
            StaticPopupDialogs["TOO_MANY_LUA_ERRORS"].OnShow = function(self)
                self:Hide()
            end
            StaticPopupDialogs.TOO_MANY_LUA_ERRORS.OnShow = function(self)
                self:Hide()
            end
        end

        SuppressLuaErrorsPopup()

    end
end


function Module:EnableLuaErrorsPopup()
    StaticPopupDialogs["TOO_MANY_LUA_ERRORS"].OnShow = nil;
    StaticPopupDialogs.TOO_MANY_LUA_ERRORS.OnShow = nil;
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
        self:EnableLuaErrorsPopup();
    end
end

function Module:IsPlayerInPvPZone()
    local zoneType = select(2, IsInInstance());
    -- Check if the player is in a PvP instance. Check if the player is in a raid or 5-man instance
    if zoneType == "arena" or zoneType == "pvp" or zoneType == "party" or zoneType == "raid" then
        return true;
    else
        return false
    end
end

function Module:IsAvailableForCurrentVersion()
    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
        return true -- retail
    elseif WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC then
        return true -- wrath
    elseif WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        return true -- vanilla
    end
end