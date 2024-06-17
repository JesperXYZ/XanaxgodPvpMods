local _, XPM = ...
local Main = XPM.Main

local Module = Main:NewModule("UIFrameOpacity", "AceHook-3.0", "AceEvent-3.0")

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
    return "This module allows you to change the opacity of specific UI elements. Setting the opacity to 0.0 hides the UI elements completely and makes them click-through."
end

function Module:GetName()
    return "UI Frame Opacity"
end

function Module:GetOptions(myOptionsTable, db)
    self.db = db
    local defaults = {
        minimapAlpha = 0.7,
        minimapClusterAlpha = 0.7,
        bagsBarAlpha = 0.6,
        microButtonAlpha = 0.6,
        queueStatusButtonAlpha = 0.6,
        entireChatFrameAlpha = 0.8,
        minimapAlpha2 = 0.6,
        minimapClusterAlpha2 = 0.5,
        bagsBarAlpha2 = 0.4,
        microButtonAlpha2 = 0.4,
        queueStatusButtonAlpha2 = 0.4,
        entireChatFrameAlpha2 = 0.6
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

        if setting == "minimapAlpha" then
            self:RefreshUI()
        end
        if setting == "minimapClusterAlpha" then
            self:RefreshUI()
        end
        if setting == "bagsBarAlpha" then
            self:RefreshUI()
        end
        if setting == "microButtonAlpha" then
            self:RefreshUI()
        end
        if setting == "entireChatFrameAlpha" then
            self:RefreshUI()
        end
        if setting == "queueStatusButtonAlpha" then
            self:RefreshUI()
        end
        if setting == "minimapAlpha2" then
            self:RefreshUI()
        end
        if setting == "minimapClusterAlpha2" then
            self:RefreshUI()
        end
        if setting == "bagsBarAlpha2" then
            self:RefreshUI()
        end
        if setting == "microButtonAlpha2" then
            self:RefreshUI()
        end
        if setting == "entireChatFrameAlpha2" then
            self:RefreshUI()
        end
        if setting == "queueStatusButtonAlpha2" then
            self:RefreshUI()
        end
    end
    local counter = CreateCounter(5)

    local UIFrameOpacityImage =
    "|TInterface\\Addons\\XanaxgodPvpMods\\media\\moduleImages\\UIFrameOpacity:230:460:1:0|t"
    --local UIFrameOpacityImage = "|TInterface\\Addons\\XanaxgodPvpMods\\media\\moduleImages\\UIFrameOpacity:235:474:2:0|t"

    myOptionsTable.args.outsideInstance = {
        order = counter(),
        name = "Outside Instance",
        type = "group",
        args = {
            changeFrameOpacityGroup = {
                order = counter(),
                name = "Change Frame Opacity",
                type = "group",
                inline = true, --inline makes it a normal group. else it is a tab group (myOptionsTable in core.lua)
                args = {
                    minimapAlpha = {
                        type = "range",
                        name = "Minimap",
                        order = counter(),
                        get = get,
                        set = set,
                        min = 0,
                        max = 1,
                        step = 0.1,
                        width = 0.7
                    },
                    minimapClusterAlpha = {
                        type = "range",
                        name = "MinimapCluster",
                        order = counter(),
                        get = get,
                        set = set,
                        min = 0,
                        max = 1,
                        step = 0.1,
                        width = 0.7
                    },
                    queueStatusButtonAlpha = {
                        type = "range",
                        name = "LFG Eye Button",
                        order = counter(),
                        get = get,
                        set = set,
                        min = 0,
                        max = 1,
                        step = 0.1,
                        width = 0.7
                    },
                    entireChatFrameAlpha = {
                        type = "range",
                        name = "Entire Chat Frame",
                        order = counter(),
                        get = get,
                        set = set,
                        min = 0,
                        max = 1,
                        step = 0.1,
                        width = 0.7
                    },
                    bagsBarAlpha = {
                        type = "range",
                        name = "BagsBar",
                        order = counter(),
                        get = get,
                        set = set,
                        min = 0,
                        max = 1,
                        step = 0.1,
                        width = 0.7
                    },
                    microButtonAlpha = {
                        type = "range",
                        name = "MicroMenu",
                        order = counter(),
                        get = get,
                        set = set,
                        min = 0,
                        max = 1,
                        step = 0.1,
                        width = 0.7
                    }
                }
            },
            art4 = {
                order = counter(),
                type = "description",
                name = "" .. UIFrameOpacityImage,
                width = "full"
            }
        }
    }
    myOptionsTable.args.insideInstance = {
        order = counter(),
        name = "Inside Raid/Dungeon/Arena/Battleground",
        type = "group",
        args = {
            changeFrameOpacityGroup2 = {
                order = counter(),
                name = "Change Frame Opacity",
                type = "group",
                inline = true, --inline makes it a normal group. else it is a tab group (myOptionsTable in core.lua)
                args = {
                    minimapAlpha2 = {
                        type = "range",
                        name = "Minimap",
                        order = counter(),
                        get = get,
                        set = set,
                        min = 0,
                        max = 1,
                        step = 0.1,
                        width = 0.7
                    },
                    minimapClusterAlpha2 = {
                        type = "range",
                        name = "MinimapCluster",
                        order = counter(),
                        get = get,
                        set = set,
                        min = 0,
                        max = 1,
                        step = 0.1,
                        width = 0.7
                    },
                    queueStatusButtonAlpha2 = {
                        type = "range",
                        name = "LFG Eye Button",
                        order = counter(),
                        get = get,
                        set = set,
                        min = 0,
                        max = 1,
                        step = 0.1,
                        width = 0.7
                    },
                    entireChatFrameAlpha2 = {
                        type = "range",
                        name = "Entire Chat Frame",
                        order = counter(),
                        get = get,
                        set = set,
                        min = 0,
                        max = 1,
                        step = 0.1,
                        width = 0.7
                    },
                    bagsBarAlpha2 = {
                        type = "range",
                        name = "BagsBar",
                        order = counter(),
                        get = get,
                        set = set,
                        min = 0,
                        max = 1,
                        step = 0.1,
                        width = 0.7
                    },
                    microButtonAlpha2 = {
                        type = "range",
                        name = "MicroMenu",
                        order = counter(),
                        get = get,
                        set = set,
                        min = 0,
                        max = 1,
                        step = 0.1,
                        width = 0.7
                    }
                }
            },
            art4 = {
                order = counter(),
                type = "description",
                name = "" .. UIFrameOpacityImage,
                width = "full"
            }
        }
    }

    return myOptionsTable
end

function Module:UpdateMinimapOpacity()
    local alpha
    if self:IsEnabled() then
        if self.IsPlayerInPvPZone() then
            alpha = self.db.minimapAlpha2
        else
            alpha = self.db.minimapAlpha
        end
    else
        alpha = 1
    end

    Minimap:SetAlpha(alpha)

    if not UnitAffectingCombat("player") then
        if alpha == 0 then
            Minimap:Hide()
        else
            Minimap:Show()
        end
    end
end

function Module:UpdateMinimapClusterOpacity()
    local alpha
    if self:IsEnabled() then
        if self.IsPlayerInPvPZone() then
            alpha = self.db.minimapClusterAlpha2
        else
            alpha = self.db.minimapClusterAlpha
        end
    else
        alpha = 1
    end

    MinimapCluster:SetAlpha(alpha)

    if not UnitAffectingCombat("player") then
        if alpha == 0 then
            MinimapCluster:Hide()
        else
            MinimapCluster:Show()
        end
    end
end

function Module:UpdateBagsBarOpacity()
    local alpha
    if self:IsEnabled() then
        if self.IsPlayerInPvPZone() then
            alpha = self.db.bagsBarAlpha2
        else
            alpha = self.db.bagsBarAlpha
        end
    else
        alpha = 1
    end

    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
        BagsBar:SetAlpha(alpha)
    elseif (WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC) or (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
        MainMenuBarBackpackButton:SetAlpha(alpha)
        CharacterBag0SlotIconTexture:SetAlpha(alpha)
        CharacterBag1SlotIconTexture:SetAlpha(alpha)
        CharacterBag2SlotIconTexture:SetAlpha(alpha)
        CharacterBag3SlotIconTexture:SetAlpha(alpha)
        CharacterBag0SlotNormalTexture:SetAlpha(alpha)
        CharacterBag1SlotNormalTexture:SetAlpha(alpha)
        CharacterBag2SlotNormalTexture:SetAlpha(alpha)
        CharacterBag3SlotNormalTexture:SetAlpha(alpha)
    end

    if not UnitAffectingCombat("player") then
        if alpha == 0 then
            if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
                BagsBar:Hide()
            elseif (WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC) or (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
                MainMenuBarBackpackButton:Hide()
                CharacterBag0SlotIconTexture:Hide()
                CharacterBag1SlotIconTexture:Hide()
                CharacterBag2SlotIconTexture:Hide()
                CharacterBag3SlotIconTexture:Hide()
            end
        else
            if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
                BagsBar:Show()
            elseif (WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC) or (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
                MainMenuBarBackpackButton:Show()
                CharacterBag0SlotIconTexture:Show()
                CharacterBag1SlotIconTexture:Show()
                CharacterBag2SlotIconTexture:Show()
                CharacterBag3SlotIconTexture:Show()
            end
        end
    end
end

function Module:UpdateMicroButtonOpacity()
    local alpha
    if self:IsEnabled() then
        if self.IsPlayerInPvPZone() then
            alpha = self.db.microButtonAlpha2
        else
            alpha = self.db.microButtonAlpha
        end
    else
        alpha = 1
    end

    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
        MicroMenu:SetAlpha(alpha) -- Set opacity
    elseif (WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC) or (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
        CharacterMicroButton:SetAlpha(alpha)
        SpellbookMicroButton:SetAlpha(alpha)
        TalentMicroButton:SetAlpha(alpha)
        QuestLogMicroButton:SetAlpha(alpha)
        MainMenuMicroButton:SetAlpha(alpha)
        HelpMicroButton:SetAlpha(alpha)
        if (WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC) then
            AchievementMicroButton:SetAlpha(alpha)
            GuildMicroButton:SetAlpha(alpha)
            CollectionsMicroButton:SetAlpha(alpha)
            PVPMicroButton:SetAlpha(alpha)
            LFGMicroButton:SetAlpha(alpha)
            EJMicroButton:SetAlpha(alpha)
        end
        if (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
            SocialsMicroButton:SetAlpha(alpha)
            WorldMapMicroButton:SetAlpha(alpha)
        end
    end


    if not UnitAffectingCombat("player") then
        if alpha == 0 then

            if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
                MicroMenu:Hide()
            elseif (WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC) or (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
                CharacterMicroButton:Hide()
                SpellbookMicroButton:Hide()
                TalentMicroButton:Hide()
                QuestLogMicroButton:Hide()
                MainMenuMicroButton:Hide()
                HelpMicroButton:Hide()
                if (WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC) then
                    AchievementMicroButton:Hide()
                    GuildMicroButton:Hide()
                    CollectionsMicroButton:Hide()
                    PVPMicroButton:Hide()
                    LFGMicroButton:Hide()
                    EJMicroButton:Hide()
                end
                if (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
                    SocialsMicroButton:Hide()
                    WorldMapMicroButton:Hide()
                end
            end
        else
            if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
                MicroMenu:Show()
            elseif (WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC) or (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
                CharacterMicroButton:Show()
                SpellbookMicroButton:Show()
                TalentMicroButton:Show()
                QuestLogMicroButton:Show()
                MainMenuMicroButton:Show()
                HelpMicroButton:Show()
                if (WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC) then
                    AchievementMicroButton:Show()
                    GuildMicroButton:Show()
                    CollectionsMicroButton:Show()
                    PVPMicroButton:Show()
                    LFGMicroButton:Show()
                    EJMicroButton:Show()
                end
                if (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
                    SocialsMicroButton:Show()
                    WorldMapMicroButton:Show()
                end
            end
        end
    end
end

function Module:UpdateQueueStatusButtonOpacity()
    local alpha
    if self:IsEnabled() then
        if self.IsPlayerInPvPZone() then
            alpha = self.db.queueStatusButtonAlpha2
        else
            alpha = self.db.queueStatusButtonAlpha
        end
    else
        alpha = 1
    end
    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
        QueueStatusButton:SetAlpha(alpha)
    end
end

function Module:UpdateEntireChatFrameOpacity()
    local alpha
    if self:IsEnabled() then
        if self.IsPlayerInPvPZone() then
            alpha = self.db.entireChatFrameAlpha2
        else
            alpha = self.db.entireChatFrameAlpha
        end
    else
        alpha = 1
    end

    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
        ChatFrame1:SetAlpha(alpha)
        ChatFrame2:SetAlpha(alpha)
        ChatFrame3:SetAlpha(alpha)
        ChatFrame4:SetAlpha(alpha)
        ChatFrame5:SetAlpha(alpha)
        ChatFrame6:SetAlpha(alpha)

        ChatFrame1Tab:SetAlpha(alpha / 2)
        ChatFrame2Tab:SetAlpha(alpha / 2)
        ChatFrame3Tab:SetAlpha(alpha / 2)
        ChatFrame4Tab:SetAlpha(alpha / 2)
        ChatFrame5Tab:SetAlpha(alpha / 2)
        ChatFrame6Tab:SetAlpha(alpha / 2)

        QuickJoinToastButton:SetAlpha(alpha)

        GeneralDockManagerOverflowButton:SetAlpha(alpha)

        if not UnitAffectingCombat("player") then
            if alpha == 0 then
                local a = 1
                repeat
                    if a == ShownChatWindows then
                        self:HideFrame(_G["ChatFrame" .. a])
                    end

                    a = a + 1
                until (a > NUM_CHAT_WINDOWS)
                self:HideFrame(ChatFrame1Tab)
                self:HideFrame(ChatFrame2Tab)
                self:HideFrame(QuickJoinToastButton)

                self:HideFrame(GeneralDockManagerOverflowButton)
            else
                local a = 1
                repeat
                    if a == ShownChatWindows then
                        self:ShowFrame(_G["ChatFrame" .. a])
                    end
                    a = a + 1
                until (a > NUM_CHAT_WINDOWS)

                self:ShowFrame(ChatFrame1Tab)
                self:ShowFrame(ChatFrame2Tab)
                self:ShowFrame(QuickJoinToastButton)
            end
        end
    elseif (WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC) or (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
        ChatFrame1:SetAlpha(alpha)
        ChatFrame2:SetAlpha(alpha)
        ChatFrame3:SetAlpha(alpha)
        ChatFrame4:SetAlpha(alpha)
        ChatFrame5:SetAlpha(alpha)
        ChatFrame6:SetAlpha(alpha)

        ChatFrame1Tab:SetAlpha(alpha / 2)
        ChatFrame2Tab:SetAlpha(alpha / 2)
        ChatFrame3Tab:SetAlpha(alpha / 2)
        ChatFrame4Tab:SetAlpha(alpha / 2)
        ChatFrame5Tab:SetAlpha(alpha / 2)
        ChatFrame6Tab:SetAlpha(alpha / 2)

        ChatFrameChannelButton:SetAlpha(alpha)
        ChatFrameMenuButton:SetAlpha(alpha)
        ChatFrame1ButtonFrameUpButton:SetAlpha(alpha)
        ChatFrame1ButtonFrameDownButton:SetAlpha(alpha)
        ChatFrame1ButtonFrameBottomButton:SetAlpha(alpha)
        if (WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC) then
            FriendsMicroButton:SetAlpha(alpha)
        end

        if not UnitAffectingCombat("player") then
            if alpha == 0 then
                ChatFrameChannelButton:Hide()
                ChatFrameMenuButton:Hide()
                ChatFrame1ButtonFrameUpButton:Hide()
                ChatFrame1ButtonFrameDownButton:Hide()
                ChatFrame1ButtonFrameBottomButton:Hide()
                if (WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC) then
                    FriendsMicroButton:Hide()
                end
            else
                ChatFrameChannelButton:Show()
                ChatFrameMenuButton:Show()
                ChatFrame1ButtonFrameUpButton:Show()
                ChatFrame1ButtonFrameDownButton:Show()
                ChatFrame1ButtonFrameBottomButton:Show()
                if (WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC) then
                    FriendsMicroButton:Show()
                end
            end
        end
    end

end

function Module:HideFrame(frame)
    if frame:IsShown() then
        frame:Hide()
        for i = 1, NUM_CHAT_WINDOWS do
            --if not i == 3 then
            _G["ChatFrame" .. i .. "Tab"]:Hide()
            --end
        end
    end
end

function Module:ShowFrame(frame)
    if not frame:IsShown() then
        frame:Show()
        for i = 1, NUM_CHAT_WINDOWS do
            if not i == 3 then
                _G["ChatFrame" .. i .. "Tab"]:Show()
            end
        end
    end
end

function Module:GetShownChatFrames() --no usage
    --ShownChatWindows = 0;
    --ShownChatTabs = 0;
    local a = 1
    repeat
        if _G["ChatFrame" .. a]:IsShown() then
            if ShownChatWindows == 0 or nil then
                ShownChatWindows = a
            else
                ShownChatWindows = ShownChatWindows and a
            end
        end

        a = a + 1
    until (a > NUM_CHAT_WINDOWS)
end

function Module:SetupUI()
    self:UpdateMinimapOpacity()
    self:UpdateMinimapClusterOpacity()
    self:UpdateBagsBarOpacity()
    self:UpdateMicroButtonOpacity()
    self:UpdateQueueStatusButtonOpacity()
    self:UpdateEntireChatFrameOpacity()
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
        return true -- vanilla
    end
end
