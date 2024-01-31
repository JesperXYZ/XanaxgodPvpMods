local _, XPM = ...;
local Main = XPM.Main;

local Module = Main:NewModule('DisableBlizzardButtonEffects', 'AceHook-3.0', 'AceEvent-3.0');

function Module:OnEnable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:OnDisable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:GetDescription()
    return 'This module disables all the ActionButton glows/effects/animations Blizzard added in 10.1.5.';
end

function Module:GetName()
    return 'Disable Blizzard Button Effects';
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

    local DisableBlizzardButtonEffectsImage = "|TInterface\\Addons\\XanaxgodPvpMods\\media\\moduleImages\\DisableBlizzardButtonEffects:120:360:68:-15|t"

    myOptionsTable.args.art3 = {
        order = counter(),
        type = 'description',
        name = '' .. DisableBlizzardButtonEffectsImage,
        width = 'full',
    };

    return myOptionsTable;
end

function Module:SetupUI()
    local events = {
        "UNIT_SPELLCAST_INTERRUPTED",
        "UNIT_SPELLCAST_SUCCEEDED",
        "UNIT_SPELLCAST_FAILED",
        "UNIT_SPELLCAST_START",
        "UNIT_SPELLCAST_STOP",
        "UNIT_SPELLCAST_CHANNEL_START",
        "UNIT_SPELLCAST_CHANNEL_STOP",
        "UNIT_SPELLCAST_RETICLE_TARGET",
        "UNIT_SPELLCAST_RETICLE_CLEAR",
        "UNIT_SPELLCAST_EMPOWER_START",
        "UNIT_SPELLCAST_EMPOWER_STOP",
    }

    if self:IsEnabled() then
        for _,e in ipairs(events) do
            ActionBarActionEventsFrame:UnregisterEvent(e)
        end
    else
        for _,e in ipairs(events) do
            ActionBarActionEventsFrame:RegisterEvent(e)
        end
    end

    if self:IsEnabled() then
        self:SecureHook('ActionButtonCooldown_OnCooldownDone', function (self)
            local cooldownFlash = self:GetParent().CooldownFlash
            if cooldownFlash and cooldownFlash.FlashAnim:IsPlaying() then
                cooldownFlash.FlashAnim:Stop()
                cooldownFlash:Hide()
            end
        end)
    end

    if self:IsEnabled() then
        self:SecureHook("StartChargeCooldown", function(parent)
            if parent.chargeCooldown then
                parent.chargeCooldown:SetEdgeTexture("Interface\\Cooldown\\edge")
            end
        end)
    end

    if self:IsEnabled() then
        self:SecureHook("ActionButton_ShowOverlayGlow", function(button)
            if button.SpellActivationAlert.ProcStartAnim:IsPlaying() then
                button.SpellActivationAlert:SetAlpha(0)
                C_Timer.After(0.26, function()
                    button.SpellActivationAlert:SetAlpha(1)
                end)
            end
        end)
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
        self:SetupUI()
    else
        self:SetupUI()
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