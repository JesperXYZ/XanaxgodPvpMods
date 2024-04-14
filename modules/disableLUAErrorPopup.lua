local _, XPM = ...;
local Main = XPM.Main;

local Module = Main:NewModule('DisableLUAErrorPopup', 'AceHook-3.0', 'AceEvent-3.0');

function Module:OnEnable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:OnDisable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:GetDescription()
    return 'This module disables the "your AddOns are experiencing a large number of errors..." popup that is so frequently occurring in Dragonflight.';
end

function Module:GetName()
    return 'Disable LUA Error Popup';
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

    local DisableLUAErrorPopupImage = "|TInterface\\Addons\\XanaxgodPvpMods\\media\\moduleImages\\DisableLUAErrorPopup:383:500:2:-1|t"

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

function Module:IsAvailableForCurrentVersion()
    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
        return true -- retail
    elseif WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC then
        return true -- wrath
    elseif WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        return true -- vanilla
    end
end