local _, XPM = ...;
local Main = XPM.Main;

local Module = Main:NewModule('ShadowSightHelper', 'AceHook-3.0', 'AceEvent-3.0');

local rc = LibStub("LibRangeCheck-3.0")

function Module:OnEnable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:OnDisable()
    if not rangeFrame == nil then
        rangeFrame:Hide()
    end
    Main:ReinitializeOptionsMenu()
end

function Module:GetDescription()
    return 'This module displays a frame that shows the distance between you and your target when affected by the Shadow Sight debuff (the stealth detection eye). The range-frame is anchored to the target-frame.';
end

function Module:GetName()
    return 'Shadow Sight Helper';
end

function Module:GetOptions(myOptionsTable, db)
    self.db = db;
    local defaults = {
        enableEverywhere = false,
        iconOpacity = 1,
        iconSize = 1.3,
        fontSize = 1.7,
        fontOpacity = 1,
        xPosition = 0,
        yPosition = 0,

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

        if setting == 'enableEverywhere' then
            self:RefreshUI()
        end
        if setting == 'iconOpacity' then
            self:RefreshUI()
        end
        if setting == 'iconSize' then
            self:RefreshUI()
        end
        if setting == 'fontOpacity' then
            self:RefreshUI()
        end
        if setting == 'fontSize' then
            self:RefreshUI()
        end
        if setting == 'xPosition' then
            self:RefreshUI()
        end
        if setting == 'yPosition' then
            self:RefreshUI()
        end

    end
    local counter = CreateCounter(5);

    local ShadowSightHelperImage = "|TInterface\\Addons\\XanaxgodPvpMods\\media\\moduleImages\\ShadowSightHelper:204:504:1:-1|t"

    myOptionsTable.args.empty711 = {
        order = counter(),
        type = 'description',
        name = '',
        width = 'full',
    };
    myOptionsTable.args.enableEverywhere = {
        order = counter(),
        type = 'toggle',
        name = 'Always show the range-frame',
        desc = 'Enables the range-frame at all times',
        width = 'full',
        get = get,
        set = set,
    };
    myOptionsTable.args.empty395 = {
        order = counter(),
        type = 'description',
        name = '',
        width = 'full',
    };
    myOptionsTable.args.iconSize = {
        type = 'range',
        name = 'Icon Size',
        order = counter(),
        get = get,
        set = set,
        min = 0,
        max = 3,
        step = 0.1,
        width = 1.2,
    };
    myOptionsTable.args.iconOpacity = {
        type = 'range',
        name = 'Icon Opacity',
        order = counter(),
        get = get,
        set = set,
        min = 0,
        max = 1,
        step = 0.1,
        width = 1.2,
    };
    myOptionsTable.args.empty331 = {
        order = counter(),
        type = 'description',
        name = '',
        width = 'full',
    };
    myOptionsTable.args.fontSize = {
        type = 'range',
        name = 'Font Size',
        order = counter(),
        get = get,
        set = set,
        min = 0,
        max = 3,
        step = 0.1,
        width = 1.2,
    };
    myOptionsTable.args.fontOpacity = {
        type = 'range',
        name = 'Font Opacity',
        order = counter(),
        get = get,
        set = set,
        min = 0,
        max = 1,
        step = 0.1,
        width = 1.2,
    };
    myOptionsTable.args.empty337 = {
        order = counter(),
        type = 'description',
        name = '',
        width = 'full',
    };
    myOptionsTable.args.xPosition = {
        type = 'range',
        name = 'x-Position',
        order = counter(),
        get = get,
        set = set,
        min = -500,
        max = 500,
        step = 5,
        width = 1.2,
    };
    myOptionsTable.args.yPosition = {
        type = 'range',
        name = 'y-Position',
        order = counter(),
        get = get,
        set = set,
        min = -500,
        max = 500,
        step = 5,
        width = 1.2,
    };
    myOptionsTable.args.art7 = {
        order = counter(),
        type = 'description',
        name = '' .. ShadowSightHelperImage,
        width = 'full',
    };

    return myOptionsTable;
end

function Module:ShowEyeDuration()
    if self:IsPlayerInPvPZone() then
        if not rangeFrame:IsShown() then
            for i=1,15 do
                local D = UnitDebuff("player",i);
                if D == "Shadow Sight" then

                    local a = 0
                    repeat
                        C_Timer.After(a, function() self:UpdateRange() end)
                        a = a + 0.1
                    until a>14.5
                    rangeFrame:Show()

                    C_Timer.After(14.7, function() rangeFrame:Hide() end)
                end
            end
        end
    end
end

function Module:ShowEverywhere()
    if self:IsEnabled() and self.db.enableEverywhere then

        local a = 0
        repeat
            C_Timer.After(a, function() self:UpdateRange() end)
            a = a + 0.1
        until a>60*10


    else
        rangeFrame:Hide()
    end
end

function Module:UpdateRange()

    if not self:IsEnabled() then
        rangeFrame:Hide()
    elseif UnitExists('target') then
        local minRange, maxRange = rc:GetRange('target')
        if minRange == nil then
            minRange = 0
        end
        if maxRange == nil then
            maxRange = 1
        end

        if minRange>100 then
            return
        else

            local bestRange = (minRange + maxRange)/2

            local restOfBestRange = bestRange % 1

            local realRange = bestRange - restOfBestRange

            if realRange > 40 then
                rangeFrameText:SetTextColor(1,0.5,0)
            elseif realRange < 20 then
                rangeFrameText:SetTextColor(0.6,1,0)
            else
                rangeFrameText:SetTextColor(1,1,0)
            end

            rangeFrameText:SetFormattedText(realRange)

        end
    end
end

function Module:SetupUI()

    local minRange, maxRange = rc:GetRange('target')
    if minRange == nil then
        minRange = 0
    end

    if rangeFrame == nil then
        if IsAddOnLoaded("JaxClassicFrames") then
            rangeFrame = CreateFrame('Frame','RangeFrame', JcfTargetFrame)
        else
            rangeFrame = CreateFrame('Frame','RangeFrame', TargetFrame)
        end
        rangeFrame:SetFrameStrata("BACKGROUND")
        rangeFrame:SetWidth(128)
        rangeFrame:SetHeight(64)

        rangeFrame:SetPoint('RIGHT', 110, 0)

        rangeFrameIcon = rangeFrame:CreateTexture("RangeFrameIcon", "ARTWORK")
        rangeFrameIcon:SetTexture("Interface\\Icons\\spell_shadow_evileye")  -- Replace with the desired ability icon path
        rangeFrameIcon:SetSize(32, 32)
        rangeFrameIcon:SetPoint("LEFT", rangeFrame, 0, 0)

        rangeFrameText = rangeFrame:CreateFontString("RangeFrameText", "ARTWORK", "GameFontNormal")
        rangeFrameText:SetFont(GameFontNormal:GetFont(), 24, 'black')
        rangeFrameText:SetJustifyH("CENTER")
        rangeFrameText:SetPoint("LEFT", rangeFrameIcon, "RIGHT", 2, 0)
        rangeFrameText:SetFormattedText(minRange)

        rangeFrame:Hide()
    end
end

function Module:Adjustments()

    rangeFrameText:SetTextColor(1,1,1,self.db.fontOpacity)
    rangeFrameText:SetScale(self.db.fontSize)

    rangeFrameIcon:SetAlpha(self.db.iconOpacity)
    rangeFrameIcon:SetScale(self.db.iconSize)

    rangeFrame:SetPoint('RIGHT', 110+self.db.xPosition, 0+self.db.yPosition)

end

function Module:RefreshUI()
    if self:IsEnabled() then
        self:Disable();
        self:Enable();
    end
end

function Module:CheckConditions()
    if self:IsEnabled() and not self.db.enableEverywhere then

        self:SetupUI()
        self:Adjustments()
        self:RegisterEvent("PLAYER_TARGET_CHANGED", "ShowEyeDuration");
        rangeFrame:Hide()

    elseif self:IsEnabled() and self.db.enableEverywhere then

        self:SetupUI()
        self:Adjustments()
        self:ShowEverywhere()
        if not rangeFrame:IsShown() then
            rangeFrame:Show()
        end
        if hasBeenShownEverywhere ~= true then
            C_Timer.After(60*10*1, function() self:ShowEverywhere() end)
            C_Timer.After(60*10*2, function() self:ShowEverywhere() end)
            C_Timer.After(60*10*3, function() self:ShowEverywhere() end)
            C_Timer.After(60*10*4, function() self:ShowEverywhere() end)
            C_Timer.After(60*10*5, function() self:ShowEverywhere() end)
            C_Timer.After(60*10*6, function() self:ShowEverywhere() end)

            hasBeenShownEverywhere = true
        end
    else

        rangeFrameText:SetFormattedText('')
        rangeFrame:Hide()
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
        return false -- wrath
    elseif WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        return false -- vanilla
    end
end