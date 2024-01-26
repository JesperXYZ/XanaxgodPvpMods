local _, XPM = ...;
local Main = XPM.Main;

local Module = Main:NewModule('DisableBlizzardArenaFrames', 'AceHook-3.0', 'AceEvent-3.0');

function Module:OnEnable()

    self:RegisterEvent("PLAYER_ENTERING_WORLD", "CheckConditions");
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "CheckConditions");
    self:RegisterEvent("GROUP_ROSTER_UPDATE", "CheckConditions");
    self:RegisterEvent("ACTIVE_COMBAT_CONFIG_CHANGED", "CheckConditions");
    self:RegisterEvent("PVP_MATCH_STATE_CHANGED", "CheckConditions");
    self:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS", "CheckConditions");

    self:CheckConditions()

end

function Module:OnDisable()
    CompactArenaFrame:SetAlpha(1)
    CompactArenaFrame:SetScale(1)
end

function Module:GetDescription()
    return 'This module allows you to hide the default arena frames Blizzard added in 10.1.5. Arena frame AddOns such as Gladius will not be affected by this.';
end

function Module:GetName()
    return 'Disable Blizzard Arena Frames';
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

    local counter = CreateCounter(5);

    local DisableBlizzardArenaFramesImage = "|TInterface\\Addons\\XanaxgodPvpMods\\media\\moduleImages\\DisableBlizzardArenaFrames:165:440:29:-15|t"

    myOptionsTable.args.art3 = {
        order = counter(),
        type = 'description',
        name = '' .. DisableBlizzardArenaFramesImage,
        width = 'full',
    };

    return myOptionsTable;
end

function Module:SetupUI()

    local arenaFrameCluster = CreateFrame("Frame")

    CompactArenaFrame:SetParent(arenaFrameCluster)
    CompactArenaFrameTitle:SetParent(arenaFrameCluster)

    local function changeArenaFrameSize()
        if not UnitAffectingCombat('player') then
            arenaFrameCluster:SetScale(0.001)
        end
    end

    local function attemptHideArenaFrame()
        if not UnitAffectingCombat('player') then
            arenaFrameCluster:Hide()
        end
    end

    -- I dont even know if this actually does anything or it insta resets wtf
    local function moveArenaFrame()
        if not UnitAffectingCombat('player') then
            arenaFrameCluster:SetClampedToScreen(false)
            arenaFrameCluster:SetMovable(true)
            arenaFrameCluster:ClearAllPoints()
            arenaFrameCluster:SetPoint("LEFT", Minimap, "RIGHT", 350, 0)
        end
    end

    local function arenaFrameAlpha()
        arenaFrameCluster:SetAlpha(0)

        for i = 1, CompactArenaFrame:GetNumChildren() do
            local child = select(i, CompactArenaFrame:GetChildren())
            if child then
                child:SetAlpha(0)
            end
        end
    end

    CompactArenaFrame:SetScript("OnShow", arenaFrameAlpha)
    CompactArenaFrameTitle:SetScript("OnShow", arenaFrameAlpha)
    CompactArenaFrame:SetScript("OnShow", moveArenaFrame)
    CompactArenaFrameTitle:SetScript("OnShow", moveArenaFrame)
    CompactArenaFrame:SetScript("OnShow", attemptHideArenaFrame)
    CompactArenaFrameTitle:SetScript("OnShow", attemptHideArenaFrame)
    CompactArenaFrame:SetScript("OnShow", changeArenaFrameSize)
    CompactArenaFrameTitle:SetScript("OnShow", changeArenaFrameSize)

    if not UnitAffectingCombat('player') then
        CompactArenaFrame:Hide()
        CompactArenaFrameTitle:Hide()
    end

    arenaFrameAlpha()
    moveArenaFrame()
    changeArenaFrameSize()
    attemptHideArenaFrame()
end

function Module:CheckConditions()
    if self:IsPlayerInPvPZone() then
        self:SetupUI()
    else
        return
    end
end

function Module:IsPlayerInPvPZone()
    local zoneType = select(2, IsInInstance());
    -- Check if the player is in a PvP instance.
    if zoneType == "arena" then
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