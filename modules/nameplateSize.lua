local _, XPM = ...
local Main = XPM.Main

local Module = Main:NewModule("NameplateSize", "AceHook-3.0", "AceEvent-3.0")

function Module:OnEnable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:OnDisable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:GetDescription()
    return "This module allows you to change the size of your nameplates."
end

function Module:GetName()
    return "Nameplate Size"
end

function Module:GetOptions(myOptionsTable, db)
    self.db = db
    local defaults = {
        friendlyNameplateSize = 0.6,
        hostileNameplateSize = 1
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

        if setting == "friendlyNameplateSize" then
            self:RefreshUI()
        end
        if setting == "hostileNameplateSize" then
            self:RefreshUI()
        end
    end

    local counter = CreateCounter(5)

    local NameplateSizeImage =
    "|TInterface\\Addons\\XanaxgodPvpMods\\media\\moduleImages\\NameplateSize:242:495:1:-10|t"

    myOptionsTable.args.nameplateSizeGroup = {
        order = counter(),
        name = "Change Nameplate Size",
        type = "group",
        inline = true, --inline makes it a normal group. else it is a tab group (myOptionsTable in core.lua)
        args = {
            friendlyNameplateSize = {
                type = "range",
                name = "Friendly Nameplate Size",
                order = counter(),
                get = get,
                set = set,
                min = 0.1,
                max = 2,
                step = 0.1,
                width = 1.1
            },
            hostileNameplateSize = {
                type = "range",
                name = "Hostile Nameplate Size",
                order = counter(),
                get = get,
                set = set,
                min = 0.1,
                max = 2,
                step = 0.1,
                width = 1.1
            }
        }
    }

    myOptionsTable.args.art53 = {
        order = counter(),
        type = "description",
        name = "" .. NameplateSizeImage,
        width = "full"
    }
    myOptionsTable.args.empty315222 = {
        order = counter(),
        type = "description",
        name = " ",
        width = "full"
    }
    myOptionsTable.args.note = {
        order = counter(),
        type = "description",
        name = 'For further customization, I recommended using the "BetterBlizzPlates" AddOn. If you already have this addon, this module will be automatically disabled and unavailable.',
        width = "full"
    }

    return myOptionsTable
end

function Module:SetupUI()
    if not UnitAffectingCombat("player") then
        if self:IsEnabled() then
            C_NamePlate.SetNamePlateFriendlySize(154 * self.db.friendlyNameplateSize, 100)
            C_NamePlate.SetNamePlateEnemySize(154 * self.db.hostileNameplateSize, 100)
        else
            C_NamePlate.SetNamePlateFriendlySize(154, 100)
            C_NamePlate.SetNamePlateEnemySize(154, 100)
        end
    else
        C_Timer.After(10, function() self:SetupUI() end)
    end
end

function Module:RefreshUI()
    if self:IsEnabled() then
        self:Disable()
        self:Enable()
    end
end

function Module:CheckConditions()
    self:SetupUI()
end

function Module:IsAvailableForCurrentVersion()
    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
        if IsAddOnLoaded("BetterBlizzPlates") then
            return false
        else
            return true -- retail
        end
    elseif WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC then
        return false -- cata
    elseif WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        return false -- vanilla
    end
end
