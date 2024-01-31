local _, XPM = ...;
local Main = XPM.Main;

local Module = Main:NewModule('ChangeFrameOpacity', 'AceHook-3.0', 'AceEvent-3.0');

function Module:OnEnable()
    if self.db.enableInArenaOnly then
        self:RegisterEvent("PLAYER_ENTERING_WORLD", "GetShownChatFrames");
        self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "GetShownChatFrames");
    end

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
    return 'This module allows you to change the opacity of specific UI elements. Setting the opacity to 0.0 hides the UI elements completely and makes them click-through.';
end

function Module:GetName()
    return 'Change Frame Opacity';
end

function Module:GetOptions(myOptionsTable, db)
    self.db = db;
    local defaults = {
        enableInArenaOnly = false,
        alpha = 0.6,
        bagsBarAlpha = 0.5,
        microButtonAlpha = 0.5,
        queueStatusButtonAlpha = 0.5,
        entireChatFrameAlpha = 0.6,
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

        if setting == 'alpha' then
            self:RefreshUI()
        end
        if setting == 'bagsBarAlpha' then
            self:RefreshUI()
        end
        if setting == 'microButtonAlpha' then
            self:RefreshUI()
        end
        if setting == 'entireChatFrameAlpha' then
            self:RefreshUI()
        end
        if setting == 'enableInArenaOnly' then
            self:RefreshUI()
        end
        if setting == 'queueStatusButtonAlpha' then
            self:RefreshUI()
        end
    end
    local counter = CreateCounter(5);

    local ChangeFrameOpacityImage = "|TInterface\\Addons\\XanaxgodPvpMods\\media\\moduleImages\\ChangeFrameOpacity:243:494:2:-8|t"

    myOptionsTable.args.enableInArenaOnly = {
        order = counter(),
        type = 'toggle',
        name = 'Disable module when not in a raid/dungeon/arena/battleground',
        desc = 'Disables the module when you are not in a raid/dungeon/arena/battleground',
        width = 'full',
        get = get,
        set = set,
    };
    myOptionsTable.args.empty3 = {
        order = counter(),
        type = 'description',
        name = '',
        width = 'full',
    };
    myOptionsTable.args.alpha = {
        type = 'range',
        name = 'Minimap Opacity',
        order = counter(),
        get = get,
        set = set,
        min = 0,
        max = 1,
        step = 0.1,
        width = 1.2,
    };
    myOptionsTable.args.queueStatusButtonAlpha = {
        type = 'range',
        name = 'LFG Eye Button Opacity',
        order = counter(),
        get = get,
        set = set,
        min = 0,
        max = 1,
        step = 0.1,
        width = 1.2,
    };
    myOptionsTable.args.empty5 = {
        order = counter(),
        type = 'description',
        name = '',
        width = 'full',
    };
    myOptionsTable.args.bagsBarAlpha = {
        type = 'range',
        name = 'BagsBar Opacity',
        order = counter(),
        get = get,
        set = set,
        min = 0,
        max = 1,
        step = 0.1,
        width = 1.2,
    };
    myOptionsTable.args.microButtonAlpha = {
        type = 'range',
        name = 'MicroMenu Opacity',
        order = counter(),
        get = get,
        set = set,
        min = 0,
        max = 1,
        step = 0.1,
        width = 1.2,
    };
    myOptionsTable.args.empty9 = {
        order = counter(),
        type = 'description',
        name = '',
        width = 'full',
    };
    myOptionsTable.args.entireChatFrameAlpha = {
        type = 'range',
        name = 'Entire Chat Frame Opacity',
        order = counter(),
        get = get,
        set = set,
        min = 0,
        max = 1,
        step = 0.1,
        width = 1.2,
    };
    myOptionsTable.args.art4 = {
        order = counter(),
        type = 'description',
        name = '' .. ChangeFrameOpacityImage,
        width = 'full',
    };

    return myOptionsTable;
end

function Module:UpdateMinimapOpacity(resetAlpha)
    local alpha = resetAlpha and 1 or self.db.alpha;

    Minimap:SetAlpha(alpha);
    MinimapCluster:SetAlpha(alpha);

    if not UnitAffectingCombat('player') then
        if alpha == 0 then
            Minimap:Hide();
            MinimapCluster:Hide();
        else
            Minimap:Show();
            MinimapCluster:Show();
        end
    end
end

function Module:UpdateBagsBarOpacity(resetAlpha)
    local alpha = resetAlpha and 1 or self.db.bagsBarAlpha;

    BagsBar:SetAlpha(alpha) -- Set opacity

    if not UnitAffectingCombat('player') then
        if alpha == 0 then
            BagsBar:Hide();
        else
            BagsBar:Show();
        end
    end

end

function Module:UpdateMicroButtonOpacity(resetAlpha)
    local alpha = resetAlpha and 1 or self.db.microButtonAlpha;

    MicroMenu:SetAlpha(alpha) -- Set opacity

    if not UnitAffectingCombat('player') then
        if alpha == 0 then
            MicroMenu:Hide();
        else
            MicroMenu:Show();
        end
    end
end

function Module:UpdateQueueStatusButtonOpacity(resetAlpha)
    local alpha = resetAlpha and 1 or self.db.queueStatusButtonAlpha;

    QueueStatusButton:SetAlpha(alpha) -- Set opacity

    --if alpha == 0 and QueueStatusButton:IsShown() then
        --QueueStatusButton:Hide();
    --else
        --QueueStatusButton:Show();
    --end
end

function Module:UpdateEntireChatFrameOpacity(resetAlpha)
    local alpha = resetAlpha and 1 or self.db.entireChatFrameAlpha;

    ChatFrame1:SetAlpha(alpha)
    ChatFrame2:SetAlpha(alpha)
    ChatFrame3:SetAlpha(alpha)
    ChatFrame4:SetAlpha(alpha)
    ChatFrame5:SetAlpha(alpha)
    ChatFrame6:SetAlpha(alpha)

    ChatFrame1Tab:SetAlpha(alpha/2)
    ChatFrame2Tab:SetAlpha(alpha/2)
    ChatFrame3Tab:SetAlpha(alpha/2)
    ChatFrame4Tab:SetAlpha(alpha/2)
    ChatFrame5Tab:SetAlpha(alpha/2)
    ChatFrame6Tab:SetAlpha(alpha/2)

    QuickJoinToastButton:SetAlpha(alpha)

    GeneralDockManagerOverflowButton:SetAlpha(alpha)

    if not UnitAffectingCombat('player') then
        if alpha == 0 then

            local a = 1;
            repeat
                if a == ShownChatWindows then
                    self:HideFrame(_G['ChatFrame'..a])
                end

                a = a + 1
            until( a > NUM_CHAT_WINDOWS )
            self:HideFrame(ChatFrame1Tab)
            self:HideFrame(ChatFrame2Tab)
            self:HideFrame(QuickJoinToastButton)

            self:HideFrame(GeneralDockManagerOverflowButton)

        else
            local a = 1;
            repeat
                if a == ShownChatWindows then
                    self:ShowFrame(_G['ChatFrame'..a])
                end
                a = a + 1
            until( a > NUM_CHAT_WINDOWS )

            self:ShowFrame(ChatFrame1Tab)
            self:ShowFrame(ChatFrame2Tab)
            self:ShowFrame(QuickJoinToastButton)

        end
    end
end

function Module:HideFrame(frame)
    if frame:IsShown() then
        frame:Hide();
        for i = 1, NUM_CHAT_WINDOWS do
            --if not i == 3 then
                _G["ChatFrame" .. i .. "Tab"]:Hide()
            --end
        end
    end
end

function Module:ShowFrame(frame)
    if not frame:IsShown() then
        frame:Show();
        for i = 1, NUM_CHAT_WINDOWS do
            if not i == 3 then
                _G["ChatFrame" .. i .. "Tab"]:Show()
            end
        end
    end
end

function Module:GetShownChatFrames()
    ShownChatWindows = 0;
    ShownChatTabs = 0;
    local a = 1;
    repeat
        if _G['ChatFrame'..a]:IsShown() then
            if ShownChatWindows == 0 then
                ShownChatWindows = a
            else
                ShownChatWindows = ShownChatWindows and a
            end
        end

        a = a + 1
    until( a > NUM_CHAT_WINDOWS )
end

function Module:SetupUI()
    if self.db.enableInArenaOnly and not self:IsPlayerInPvPZone() then
        self:UpdateMinimapOpacity(true);
        self:UpdateBagsBarOpacity(true);
        self:UpdateMicroButtonOpacity(true);
        self:UpdateQueueStatusButtonOpacity(true);
        self:UpdateEntireChatFrameOpacity(true);
    else
        self:UpdateMinimapOpacity();
        self:UpdateBagsBarOpacity();
        self:UpdateMicroButtonOpacity();
        self:UpdateQueueStatusButtonOpacity();
        self:UpdateEntireChatFrameOpacity();
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
        if not UnitAffectingCombat('player') then
            self:SetupUI()
        else
            C_Timer.After(2, function() self:SetupUI() end)
        end
    elseif not UnitAffectingCombat('player') then
        self:UpdateMinimapOpacity(true);
        self:UpdateBagsBarOpacity(true);
        self:UpdateMicroButtonOpacity(true);
        self:UpdateQueueStatusButtonOpacity(true);
        self:UpdateEntireChatFrameOpacity(true);
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