local _, XPM = ...;
local Main = XPM.Main;

local Module = Main:NewModule('SnowfallKeyPress', 'AceHook-3.0', 'AceEvent-3.0');

function Module:OnEnable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:OnDisable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:GetDescription()
    return 'This module is a reiteration of the Snowfall Key Press addon released in 2009. It is exclusively designed for cosmetic purposes and only makes your ActionButtons glow upon keypress.';
end

function Module:GetName()
    return 'Snowfall Key Press';
end

function Module:GetOptions(myOptionsTable, db)
    self.db = db;
    local defaults = {
        size = 1.1,
        girth = 2,
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

        if setting == 'size' then
            self:RefreshUI()
        end
        if setting == 'girth' then
            self:RefreshUI()
        end

    end
    local counter = CreateCounter(5);

    local SnowfallKeyPressImage = "|TInterface\\Addons\\XanaxgodPvpMods\\media\\moduleImages\\SnowfallKeyPress:102:232:132:-30|t"

    myOptionsTable.args.empty12 = {
        order = counter(),
        type = 'description',
        name = '',
        width = 'full',
    };
    myOptionsTable.args.size = {
        type = 'range',
        name = 'Glow Size',
        order = counter(),
        get = get,
        set = set,
        min = 0,
        max = 2,
        step = 0.1,
        width = 'full',
    };
    myOptionsTable.args.empty22 = {
        order = counter(),
        type = 'description',
        name = '',
        width = 'full',
    };
    myOptionsTable.args.girth = {
        type = 'range',
        name = 'Glow Girth',
        order = counter(),
        get = get,
        set = set,
        min = 0,
        max = 5,
        step = 1,
        width = 'full',
    };
    myOptionsTable.args.art2 = {
        order = counter(),
        type = 'description',
        name = '' .. SnowfallKeyPressImage,
        width = 'full',
    };

    return myOptionsTable;
end

function Module:SetupUI()
    local animationsCount, animations = 5, {}
    local animationNum = 1
    local frame, texture, alpha1, scale1, scale2, rotation2, animationGroup
    for i = 1, animationsCount do
        frame = CreateFrame("Frame")
        texture = frame:CreateTexture() texture:SetTexture('Interface\\Cooldown\\star4') texture:SetAlpha(0) texture:SetAllPoints() texture:SetBlendMode("ADD")
        animationGroup = texture:CreateAnimationGroup()
        alpha1 = animationGroup:CreateAnimation("Alpha") alpha1:SetFromAlpha(0) alpha1:SetToAlpha(1) alpha1:SetDuration(0) alpha1:SetOrder(1)
        scale1 = animationGroup:CreateAnimation("Scale") scale1:SetScale(1.0*snowfallKeyPressSize, 1.0*snowfallKeyPressSize) scale1:SetDuration(0) scale1:SetOrder(1)
        scale2 = animationGroup:CreateAnimation("Scale") scale2:SetScale(1.5*snowfallKeyPressSize, 1.5*snowfallKeyPressSize) scale2:SetDuration(0.3) scale2:SetOrder(2)
        rotation2 = animationGroup:CreateAnimation("Rotation") rotation2:SetDegrees(90) rotation2:SetDuration(0.3) rotation2:SetOrder(2)
        animations[i] = {frame = frame, animationGroup = animationGroup}
    end

    local AnimateButton = function(self)
        if snowfallKeyPressSize>0 and snowfallKeyPressGirth>0 then
            if not self:IsVisible() then
                return true
            end
            local a = 1;
            repeat
                local animation = animations[animationNum]
                frame = animation.frame
                animationGroup = animation.animationGroup
                frame:SetFrameStrata("HIGH")
                frame:SetFrameLevel(20)
                frame:SetAllPoints(self)
                animationGroup:Stop()
                animationGroup:Play()
                animationNum = (animationNum % animationsCount) + 1
                a = a + 1

            until( a > snowfallKeyPressGirth )
        end
    end

    if snowfallKeyPressSize>0 and snowfallKeyPressGirth>0 then

        self:SecureHook('ActionButtonDown', function(id)
            local button
            if not WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC and not WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
                if C_PetBattles.IsInBattle() then
                    if PetBattleFrame then
                        if id > NUM_BATTLE_PET_HOTKEYS then return end button = PetBattleFrame.BottomFrame.abilityButtons[id]
                        if id == BATTLE_PET_ABILITY_SWITCH then
                            button = PetBattleFrame.BottomFrame.SwitchPetButton;
                        elseif id == BATTLE_PET_ABILITY_CATCH then
                            button = PetBattleFrame.BottomFrame.CatchButton;
                        end
                        if not button then return end
                    end
                    return
                end
                if OverrideActionBar:IsShown() then
                    if id > NUM_OVERRIDE_BUTTONS then return end
                    button = _G["OverrideActionBarButton"..id]
                else
                    button = _G["ActionButton"..id]
                end
            else
                button = _G["ActionButton"..id]
            end
            if not button then return end
            AnimateButton(button)
        end)

        self:SecureHook('MultiActionButtonDown', function(bname, id)
            AnimateButton(_G[bname..'Button'..id])
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
        snowfallKeyPressSize = self.db.size;
        snowfallKeyPressGirth = self.db.girth;
        self:SetupUI()
    else
        snowfallKeyPressSize = 0;
        snowfallKeyPressGirth = 0;
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