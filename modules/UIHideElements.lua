local _, XPM = ...
local Main = XPM.Main

local Module = Main:NewModule("UIHideElements", "AceHook-3.0", "AceEvent-3.0")

function Module:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "CheckConditions")
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "CheckConditions")
    self:RegisterEvent("GROUP_ROSTER_UPDATE", "CheckConditions")

    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:OnDisable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:GetDescription()
    return "This module allows you to hide specific UI elements or parts of them."
end

function Module:GetName()
    return "UI Hide Elements"
end

function Module:GetOptions(myOptionsTable, db)
    self.db = db
    local defaults = {
        partyLabel = true,
        realmName = true,
        entireName = false,
        partyLabel2 = true,
        realmName2 = true,
        entireName2 = false,
        statusTrackingBarManager = true,
        statusTrackingBarManager2 = true,
        classicFramesPvpIcon = true,
        classicFramesPlayerGroupNumber = true,
        classicFramesNameBackground = true,
        classicFramesPvpIcon2 = true,
        classicFramesPlayerGroupNumber2 = true,
        classicFramesNameBackground2 = true
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

        if setting == "partyLabel" then
            self:RefreshUI()
        end
        if setting == "realmName" then
            if self.db.realmName then
                self.db.entireName = false
            end
            self:RefreshUI()
        end
        if setting == "entireName" then
            if self.db.entireName then
                self.db.realmName = false
            end
            self:RefreshUI()
        end
        if setting == "partyLabel2" then
            self:RefreshUI()
        end
        if setting == "realmName2" then
            if self.db.realmName2 then
                self.db.entireName2 = false
            end
            self:RefreshUI()
        end
        if setting == "entireName2" then
            if self.db.entireName2 then
                self.db.realmName2 = false
            end
            self:RefreshUI()
        end

        if setting == "classicFramesPvpIcon" then
            self:RefreshUI()
        end
        if setting == "classicFramesPlayerGroupNumber" then
            self:RefreshUI()
        end
        if setting == "classicFramesNameBackground" then
            self:RefreshUI()
        end
        if setting == "classicFramesPvpIcon2" then
            self:RefreshUI()
        end
        if setting == "classicFramesPlayerGroupNumber2" then
            self:RefreshUI()
        end
        if setting == "classicFramesNameBackground2" then
            self:RefreshUI()
        end

    end
    local counter = CreateCounter(5)

    --local UIHideElementsImage = "|TInterface\\Addons\\XanaxgodPvpMods\\media\\moduleImages\\UIHideElements:160:321:82:0|t"

    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
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
                            type = "toggle",
                            name = '"Party" Label',
                            desc = "This hides the CompactPartyFrameTitle above the PartyFrame",
                            order = counter(),
                            width = 0.66,
                            get = get,
                            set = set
                        },
                        realmName = {
                            type = "toggle",
                            name = "Realm Name",
                            desc = "This hides the realm names of your party members in the PartyFrame",
                            order = counter(),
                            width = 0.63,
                            get = get,
                            set = set
                        },
                        entireName = {
                            type = "toggle",
                            name = "Entire Name",
                            desc = "This hides the full names of your party members in the PartyFrame",
                            order = counter(),
                            width = 0.63,
                            get = get,
                            set = set
                        }
                    }
                },
                hideStatusTrackingBarGroup = {
                    order = counter(),
                    name = "Hide StatusTrackingBarManager",
                    type = "group",
                    inline = true, --inline makes it a normal group. else it is a tab group (myOptionsTable in core.lua)
                    args = {
                        statusTrackingBarManager = {
                            type = "toggle",
                            name = "Hide all experience/reputation/honor status bars",
                            desc = "This hides the StatusTrackingBarManager",
                            order = counter(),
                            width = "full",
                            get = get,
                            set = set
                        }
                    }
                }
            }
        }
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
                            type = "toggle",
                            name = '"Party" Label',
                            desc = "This hides the CompactPartyFrameTitle above the PartyFrame",
                            order = counter(),
                            width = 0.66,
                            get = get,
                            set = set
                        },
                        realmName2 = {
                            type = "toggle",
                            name = "Realm Name",
                            desc = "This hides the realm names of your party members in the PartyFrame",
                            order = counter(),
                            width = 0.63,
                            get = get,
                            set = set
                        },
                        entireName2 = {
                            type = "toggle",
                            name = "Entire Name",
                            desc = "This hides the full names of your party members in the PartyFrame",
                            order = counter(),
                            width = 0.63,
                            get = get,
                            set = set
                        }
                    }
                },
                hideStatusTrackingBarGroup2 = {
                    order = counter(),
                    name = "Hide StatusTrackingBarManager",
                    type = "group",
                    inline = true, --inline makes it a normal group. else it is a tab group (myOptionsTable in core.lua)
                    args = {
                        statusTrackingBarManager2 = {
                            type = "toggle",
                            name = "Hide all experience/reputation/honor status bars",
                            desc = "This hides the StatusTrackingBarManager",
                            order = counter(),
                            width = "full",
                            get = get,
                            set = set
                        }
                    }
                }
            }
        }

    elseif WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC or WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
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
                            type = "toggle",
                            name = '"Party" Label',
                            desc = "This hides the CompactPartyFrameTitle above the PartyFrame",
                            order = counter(),
                            width = 0.66,
                            get = get,
                            set = set
                        },
                        realmName = {
                            type = "toggle",
                            name = "Realm Name",
                            desc = "This hides the realm names of your party members in the PartyFrame",
                            order = counter(),
                            width = 0.63,
                            get = get,
                            set = set
                        },
                        entireName = {
                            type = "toggle",
                            name = "Entire Name",
                            desc = "This hides the full names of your party members in the PartyFrame",
                            order = counter(),
                            width = 0.63,
                            get = get,
                            set = set
                        }
                    }
                },
                hideClassicFramesElementsGroup = {
                    order = counter(),
                    name = "Hide Unit Frame Elements",
                    type = "group",
                    inline = true, --inline makes it a normal group. else it is a tab group (myOptionsTable in core.lua)
                    args = {
                        classicFramesPvpIcon = {
                            type = "toggle",
                            name = "PvP Icon",
                            desc = "This hides the pvp icon that indicates whether if you or your target/focus is pvp flagged or not",
                            order = counter(),
                            width = 0.6,
                            get = get,
                            set = set
                        },
                        classicFramesPlayerGroupNumber = {
                            type = "toggle",
                            name = "Player Group Number",
                            desc = "This hides the group number indicator that shows up when you are in a group",
                            order = counter(),
                            width = 1,
                            get = get,
                            set = set
                        },
                        classicFramesNameBackground = {
                            type = "toggle",
                            name = "Name Background",
                            desc = "This hides the colored background that indicates whether if you or your target/focus is friendly or hostile",
                            order = counter(),
                            width = 1,
                            get = get,
                            set = set
                        }
                    }
                }
            }
        }
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
                            type = "toggle",
                            name = '"Party" Label',
                            desc = "This hides the CompactPartyFrameTitle above the PartyFrame",
                            order = counter(),
                            width = 0.66,
                            get = get,
                            set = set
                        },
                        realmName2 = {
                            type = "toggle",
                            name = "Realm Name",
                            desc = "This hides the realm names of your party members in the PartyFrame",
                            order = counter(),
                            width = 0.63,
                            get = get,
                            set = set
                        },
                        entireName2 = {
                            type = "toggle",
                            name = "Entire Name",
                            desc = "This hides the full names of your party members in the PartyFrame",
                            order = counter(),
                            width = 0.63,
                            get = get,
                            set = set
                        }
                    }
                },
                hideClassicFramesElementsGroup2 = {
                    order = counter(),
                    name = "Hide Unit Frame Elements",
                    type = "group",
                    inline = true, --inline makes it a normal group. else it is a tab group (myOptionsTable in core.lua)
                    args = {
                        classicFramesPvpIcon2 = {
                            type = "toggle",
                            name = "PvP Icon",
                            desc = "This hides the pvp icon that indicates whether if you or your target/focus is pvp flagged or not",
                            order = counter(),
                            width = 0.6,
                            get = get,
                            set = set
                        },
                        classicFramesPlayerGroupNumber2 = {
                            type = "toggle",
                            name = "Player Group Number",
                            desc = "This hides the group number indicator that shows up when you are in a group",
                            order = counter(),
                            width = 1,
                            get = get,
                            set = set
                        },
                        classicFramesNameBackground2 = {
                            type = "toggle",
                            name = "Name Background",
                            desc = "This hides the colored background that indicates whether if you or your target/focus is friendly or hostile",
                            order = counter(),
                            width = 1,
                            get = get,
                            set = set
                        }
                    }
                }
            }
        }
    end

    return myOptionsTable
end

function Module:HidePartyLabel()
    local enabled
    if self:IsEnabled() then
        if self.IsPlayerInPvPZone() then
            enabled = self.db.partyLabel2
        else
            enabled = self.db.partyLabel
        end
    else
        enabled = false
    end

    if GetNumGroupMembers() > 0 then
        if enabled then
            if CompactPartyFrameTitle then
                CompactPartyFrameTitle:SetAlpha(0)
                CompactPartyFrameTitle:Hide()
            end
        else
            if CompactPartyFrameTitle then
                CompactPartyFrameTitle:SetAlpha(1)
                CompactPartyFrameTitle:Show()
            end
        end
    end
end

function Module:HideRealmName()
    local enabled
    if self:IsEnabled() then
        if self.IsPlayerInPvPZone() then
            enabled = self.db.realmName2
        else
            enabled = self.db.realmName
        end
    else
        enabled = false
    end

    if GetNumGroupMembers() > 0 and GetNumGroupMembers() < 6 then
        if enabled then
            if self:IsHooked("CompactUnitFrame_UpdateName") then
                return
                --self:UnHook('CompactUnitFrame_UpdateName')
            end

            self:SecureHook("CompactUnitFrame_UpdateName", function() Module:HideRealmNameHelperFunction() end)

            function Module:HideRealmNameHelperFunction()
                local num = 1
                local partyCount = GetNumGroupMembers()
                repeat
                    local partyFrameName
                    local croppedName

                    partyFrameName = _G["CompactPartyFrameMember" .. num .. "Name"]

                    if partyFrameName then
                        croppedName = partyFrameName:GetText()
                    end

                    if croppedName and partyFrameName then
                        partyFrameName:SetText(croppedName:match("[^-]+"))
                    end

                    if partyFrameName then
                        partyFrameName:Show()
                    end

                    partyFrameName = _G["CompactRaidFrame" .. num .. "Name"]

                    if partyFrameName then
                        croppedName = partyFrameName:GetText()
                    end

                    if croppedName and partyFrameName then
                        partyFrameName:SetText(croppedName:match("[^-]+"))
                    end

                    if partyFrameName then
                        partyFrameName:Show()
                    end

                    partyFrameName = _G["PartyMemberFrame" .. num .. "Name"]

                    if partyFrameName then
                        croppedName = partyFrameName:GetText()
                    end

                    if croppedName and partyFrameName then
                        partyFrameName:SetText(croppedName:match("[^-]+"))
                    end

                    if partyFrameName then
                        partyFrameName:Show()
                    end

                    num = num + 1
                until (num > partyCount)
            end

            Module:HideRealmNameHelperFunction()
        end
    end
end

function Module:HideEntireName()
    local enabled
    if self:IsEnabled() then
        if self.IsPlayerInPvPZone() then
            enabled = self.db.entireName2
        else
            enabled = self.db.entireName
        end
    else
        enabled = false
    end

    if GetNumGroupMembers() > 0 and GetNumGroupMembers() < 6 then
        if enabled then
            if self:IsHooked("CompactUnitFrame_UpdateName") then
                return
                --self:UnHook('CompactUnitFrame_UpdateName')
            end

            self:SecureHook("CompactUnitFrame_UpdateName", function() Module:HideEntireNameHelperFunction() end)

            function Module:HideEntireNameHelperFunction()
                local num = 1
                local partyCount = GetNumGroupMembers()
                repeat
                    local partyFrameName

                    partyFrameName = _G["CompactPartyFrameMember" .. num .. "Name"]

                    if partyFrameName then
                        partyFrameName:Hide()
                    end

                    partyFrameName = _G["CompactRaidFrame" .. num .. "Name"]

                    if partyFrameName then
                        partyFrameName:Hide()
                    end

                    partyFrameName = _G["PartyMemberFrame" .. num .. "Name"]

                    if partyFrameName then
                        partyFrameName:Hide()
                    end

                    num = num + 1
                until (num > partyCount)
            end

            Module:HideEntireNameHelperFunction()
        end
    end
end

function Module:HideStatusTrackingBarManager()
    local enabled
    if self:IsEnabled() then
        if self.IsPlayerInPvPZone() then
            enabled = self.db.statusTrackingBarManager2
        else
            enabled = self.db.statusTrackingBarManager
        end
    else
        enabled = false
    end

    if enabled then
        if StatusTrackingBarManager then
            if StatusTrackingBarManager:IsShown() then
                StatusTrackingBarManager:SetScale(0.00001)
            end
        end
    else
        if StatusTrackingBarManager then
            if StatusTrackingBarManager:IsShown() then
                StatusTrackingBarManager:SetScale(1)
            end
        end
    end
end

function Module:HideClassicFramesPvpIcon()
    local enabled
    if self:IsEnabled() then
        if self.IsPlayerInPvPZone() then
            enabled = self.db.classicFramesPvpIcon2
        else
            enabled = self.db.classicFramesPvpIcon
        end
    else
        enabled = false
    end

    if enabled then
        if PlayerPVPIcon then
            PlayerPVPIcon:SetAlpha(0)
        end
        if TargetFrameTextureFramePVPIcon then
            TargetFrameTextureFramePVPIcon:SetAlpha(0)
        end
        if FocusFrameTextureFramePVPIcon then
            FocusFrameTextureFramePVPIcon:SetAlpha(0)
        end
    else
        if PlayerPVPIcon then
            PlayerPVPIcon:SetAlpha(1)
        end
        if TargetFrameTextureFramePVPIcon then
            TargetFrameTextureFramePVPIcon:SetAlpha(1)
        end
        if FocusFrameTextureFramePVPIcon then
            FocusFrameTextureFramePVPIcon:SetAlpha(1)
        end
    end
end

function Module:HideClassicFramesPlayerGroupNumber()
    local enabled
    if self:IsEnabled() then
        if self.IsPlayerInPvPZone() then
            enabled = self.db.classicFramesPlayerGroupNumber2
        else
            enabled = self.db.classicFramesPlayerGroupNumber
        end
    else
        enabled = false
    end

    if enabled then
        if PlayerFrameGroupIndicator then
            PlayerFrameGroupIndicator:SetAlpha(0)
        end
    else
        if PlayerFrameGroupIndicator then
            PlayerFrameGroupIndicator:SetAlpha(1)
        end
    end
end

function Module:HideClassicFramesNameBackground()
    local function enabled()
        if self:IsEnabled() then
            if self.IsPlayerInPvPZone() then
                return self.db.classicFramesNameBackground2
            else
                return self.db.classicFramesNameBackground
            end
        else
            return false
        end
    end

    local frame = CreateFrame("FRAME")
    local function eventHandler(self, event, ...)
        if TargetFrameNameBackground and enabled() then
            TargetFrameNameBackground:SetVertexColor(0, 0, 0, 0.6)
        end
        if FocusFrameNameBackground and enabled() then
            FocusFrameNameBackground:SetVertexColor(0, 0, 0, 0.6)
        end
    end

    frame:RegisterEvent("GROUP_ROSTER_UPDATE")
    frame:RegisterEvent("PLAYER_TARGET_CHANGED")
    frame:RegisterEvent("PLAYER_FOCUS_CHANGED")
    frame:RegisterEvent("UNIT_FACTION")

    frame:SetScript("OnEvent", eventHandler)
end

function Module:SetupUI()
    self:HidePartyLabel()
    self:HideRealmName()
    self:HideEntireName()
    self:HideStatusTrackingBarManager()
end

function Module:SetupUIClassic()
    self:HidePartyLabel()
    self:HideRealmName()
    self:HideEntireName()
    self:HideClassicFramesPvpIcon()
    self:HideClassicFramesPlayerGroupNumber()
    self:HideClassicFramesNameBackground()
end

function Module:RefreshUI()
    if self:IsEnabled() then
        self:Disable()
        self:Enable()
    end
end

function Module:CheckConditions()
    if not UnitAffectingCombat("player") then
        if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
            self:SetupUI()
        elseif WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC or WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
            self:SetupUIClassic()
        end
    else
        C_Timer.After(5, function() self:CheckConditions() end)
    end
end

function Module:IsPlayerInPvPZone()
    local zoneType = select(2, IsInInstance())
    -- Check if the player is in a PvP instance -- Check if the player is in a raid or 5-man instance
    if zoneType == "arena" or zoneType == "pvp" or zoneType == "party" or zoneType == "raid" then
        return true
    else
        return false
    end
end

function Module:IsAvailableForCurrentVersion()
    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
        return true -- retail
    elseif WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC then
        return true -- cata
    elseif WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        return false -- vanilla
    end
end
