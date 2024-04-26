local _, XPM = ...;
local Main = XPM.Main;

local Module = Main:NewModule('UIHideElements', 'AceHook-3.0', 'AceEvent-3.0');

function Module:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "CheckConditions");
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "CheckConditions");
    self:RegisterEvent("GROUP_ROSTER_UPDATE", "CheckConditions");

    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:OnDisable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:GetDescription()
    return 'This module allows you to hide specific UI elements or parts of them.';
end

function Module:GetName()
    return 'UI Hide Elements';
end

function Module:GetOptions(myOptionsTable, db)
    self.db = db;
    local defaults = {
        partyLabel = true,
        realmName = true,
        entireName = false,
        partyLabel2 = true,
        realmName2 = true,
        entireName2 = false,

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

        if setting == 'partyLabel' then
            self:RefreshUI()
        end
        if setting == 'realmName' then
            if self.db.realmName then
                self.db.entireName = false;
            end
            self:RefreshUI()
        end
        if setting == 'entireName' then
            if self.db.entireName then
                self.db.realmName = false;
            end
            self:RefreshUI()
        end
        if setting == 'partyLabel2' then
            self:RefreshUI()
        end
        if setting == 'realmName2' then
            if self.db.realmName2 then
                self.db.entireName2 = false;
            end
            self:RefreshUI()
        end
        if setting == 'entireName2' then
            if self.db.entireName2 then
                self.db.realmName2 = false;
            end
            self:RefreshUI()
        end

    end
    local counter = CreateCounter(5);

    local UIHideElementsImage = "|TInterface\\Addons\\XanaxgodPvpMods\\media\\moduleImages\\UIHideElements:160:321:82:0|t"

    myOptionsTable.args.outsideInstance = {
        order = counter(),
        name = "Outside Instance",
        type = "group",
        args = {
            hideCompactPartyFrameElementsGroup = {
                order = counter(),
                name = "Hide CompactPartyFrame Elements",
                type = "group",
                inline = true, --inline makes it a normal group. else it is a tab group (myOptionsTable in core.lua)
                args = {
                    partyLabel = {
                        type = 'toggle',
                        name = '"Party" Label',
                        desc = 'This hides the CompactPartyFrameTitle above the PartyFrame',
                        order = counter(),
                        width = 0.66,
                        get = get,
                        set = set,
                    },
                    realmName = {
                        type = 'toggle',
                        name = 'Realm Name',
                        desc = 'This hides the realm names of your party members in the PartyFrame',
                        order = counter(),
                        width = 0.63,
                        get = get,
                        set = set,
                    },
                    entireName = {
                        type = 'toggle',
                        name = 'Entire Name',
                        desc = 'This hides the full names of your party members in the PartyFrame',
                        order = counter(),
                        width = 0.63,
                        get = get,
                        set = set,
                    },
                }
            },

            art4 = {
                order = counter(),
                type = 'description',
                name = '' .. UIHideElementsImage,
                width = 'full',
            };
        },
    };
    myOptionsTable.args.insideInstance = {
        order = counter(),
        name = "Inside Raid/Dungeon/Arena/Battleground",
        type = "group",
        args = {
            hideCompactPartyFrameElementsGroup2 = {
                order = counter(),
                name = "Hide CompactPartyFrame Elements",
                type = "group",
                inline = true, --inline makes it a normal group. else it is a tab group (myOptionsTable in core.lua)
                args = {
                    partyLabel2 = {
                        type = 'toggle',
                        name = '"Party" Label',
                        desc = 'This hides the CompactPartyFrameTitle above the PartyFrame',
                        order = counter(),
                        width = 0.66,
                        get = get,
                        set = set,
                    },
                    realmName2 = {
                        type = 'toggle',
                        name = 'Realm Name',
                        desc = 'This hides the realm names of your party members in the PartyFrame',
                        order = counter(),
                        width = 0.63,
                        get = get,
                        set = set,
                    },
                    entireName2 = {
                        type = 'toggle',
                        name = 'Entire Name',
                        desc = 'This hides the full names of your party members in the PartyFrame',
                        order = counter(),
                        width = 0.63,
                        get = get,
                        set = set,
                    },
                }
            },

            art4 = {
                order = counter(),
                type = 'description',
                name = '' .. UIHideElementsImage,
                width = 'full',
            };

        },
    };

    return myOptionsTable;
end

function Module:HidePartyLabel()
    local enabled;
    if self:IsEnabled() then
        if self.IsPlayerInPvPZone() then
            enabled = self.db.partyLabel2;
        else
            enabled = self.db.partyLabel;
        end
    else
        enabled = false;
    end

    if GetNumGroupMembers()>0 then
        if enabled then
            CompactPartyFrameTitle:SetAlpha(0)
            CompactPartyFrameTitle:Hide()
        else
            CompactPartyFrameTitle:SetAlpha(1)
            CompactPartyFrameTitle:Show()
        end
    end
end

function Module:HideRealmName()

    local enabled;
    if self:IsEnabled() then
        if self.IsPlayerInPvPZone() then
            enabled = self.db.realmName2;
        else
            enabled = self.db.realmName;
        end
    else
        enabled = false;
    end

    if GetNumGroupMembers()>0 and GetNumGroupMembers()<6 then
        if enabled then

            if self:IsHooked('CompactUnitFrame_UpdateName') then
                return
                --self:UnHook('CompactUnitFrame_UpdateName')
            end

            self:SecureHook('CompactUnitFrame_UpdateName', function()
                Module:HideRealmNameHelperFunction()
            end);

            function Module:HideRealmNameHelperFunction()
                local num = 1;
                local partyCount = GetNumGroupMembers();
                repeat
                    local partyFrameName = _G["CompactPartyFrameMember"..num.."Name"]
                    local croppedName

                    if partyFrameName then
                        croppedName = partyFrameName:GetText();
                    end

                    if croppedName then
                        partyFrameName:SetText(croppedName:match("[^-]+"));
                    end

                    if partyFrameName then
                        partyFrameName:Show();
                    end

                    num = num + 1;
                until (num>partyCount)
            end

            Module:HideRealmNameHelperFunction()
        end
    end
end

function Module:HideEntireName()

    local enabled;
    if self:IsEnabled() then
        if self.IsPlayerInPvPZone() then
            enabled = self.db.entireName2;
        else
            enabled = self.db.entireName;
        end
    else
        enabled = false;
    end

    if GetNumGroupMembers()>0 and GetNumGroupMembers()<6 then
        if enabled then

            if self:IsHooked('CompactUnitFrame_UpdateName') then
                return
                --self:UnHook('CompactUnitFrame_UpdateName')
            end

            self:SecureHook('CompactUnitFrame_UpdateName', function()
                Module:HideEntireNameHelperFunction()
            end);

            function Module:HideEntireNameHelperFunction()
                local num = 1;
                local partyCount = GetNumGroupMembers();
                repeat
                    local partyFrameName = _G["CompactPartyFrameMember"..num.."Name"]

                    if partyFrameName then
                        partyFrameName:Hide();
                    end

                    num = num + 1;
                until (num>partyCount)
            end

            Module:HideEntireNameHelperFunction();
        end
    end
end

function Module:SetupUI()
    self:HidePartyLabel();
    self:HideRealmName();
    self:HideEntireName();
end

function Module:RefreshUI()
    if self:IsEnabled() then
        self:Disable();
        self:Enable();
    end
end

function Module:CheckConditions()
    if not UnitAffectingCombat('player') then
        self:SetupUI()
    else
        C_Timer.After(5, function() self:CheckConditions() end)
    end

end

function Module:IsPlayerInPvPZone()
    local zoneType = select(2, IsInInstance());
    -- Check if the player is in a PvP instance -- Check if the player is in a raid or 5-man instance
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
        return false -- wrath
    elseif WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        return false -- vanilla
    end
end