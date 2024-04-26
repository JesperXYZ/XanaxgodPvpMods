local _, XPM = ...;
local Main = XPM.Main;

local Module = Main:NewModule('UnitFrameStatusText', 'AceHook-3.0', 'AceEvent-3.0');

function Module:OnEnable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:OnDisable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:GetDescription()
    return 'This module allows you to reformat the status text displayed on the health and mana bar of your unit frames (you should reload after altering this module).';
end

function Module:GetName()
    return 'Unit Frame Status Text';
end

function Module:GetOptions(myOptionsTable, db)
    self.db = db;
    local defaults = {
        numericValueToggle = false,
        percentageToggle = false,
        bothToggle = false,
        noneToggle = false,
        xanaxgodNumericValueToggle = true,
        xanaxgodBothToggle = false,
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

        if setting == 'numericValueToggle' then
            if not (self.db.numericValueToggle or self.db.percentageToggle or self.db.bothToggle or self.db.noneToggle or self.db.xanaxgodNumericValueToggle or self.db.xanaxgodBothToggle) then
                self.db.numericValueToggle = true;
            end

            if self.db.percentageToggle then
                self.db.percentageToggle =  false;
            end
            if self.db.bothToggle then
                self.db.bothToggle =  false;
            end
            if self.db.noneToggle then
                self.db.noneToggle =  false;
            end
            if self.db.xanaxgodNumericValueToggle then
                self.db.xanaxgodNumericValueToggle =  false;
            end
            if self.db.xanaxgodBothToggle then
                self.db.xanaxgodBothToggle =  false;
            end

            self:RefreshUI()
            self:RefreshUI()
        end
        if setting == 'percentageToggle' then
            if not (self.db.numericValueToggle or self.db.percentageToggle or self.db.bothToggle or self.db.noneToggle or self.db.xanaxgodNumericValueToggle or self.db.xanaxgodBothToggle) then
                self.db.percentageToggle = true;
            end

            if self.db.numericValueToggle then
                self.db.numericValueToggle =  false;
            end
            if self.db.bothToggle then
                self.db.bothToggle =  false;
            end
            if self.db.noneToggle then
                self.db.noneToggle =  false;
            end
            if self.db.xanaxgodNumericValueToggle then
                self.db.xanaxgodNumericValueToggle =  false;
            end
            if self.db.xanaxgodBothToggle then
                self.db.xanaxgodBothToggle =  false;
            end

            self:RefreshUI()
            self:RefreshUI()
        end
        if setting == 'bothToggle' then
            if not (self.db.numericValueToggle or self.db.percentageToggle or self.db.bothToggle or self.db.noneToggle or self.db.xanaxgodNumericValueToggle or self.db.xanaxgodBothToggle) then
                self.db.bothToggle = true;
            end

            if self.db.numericValueToggle then
                self.db.numericValueToggle =  false;
            end
            if self.db.percentageToggle then
                self.db.percentageToggle =  false;
            end
            if self.db.noneToggle then
                self.db.noneToggle =  false;
            end
            if self.db.xanaxgodNumericValueToggle then
                self.db.xanaxgodNumericValueToggle =  false;
            end
            if self.db.xanaxgodBothToggle then
                self.db.xanaxgodBothToggle =  false;
            end

            self:RefreshUI()
            self:RefreshUI()
        end
        if setting == 'noneToggle' then
            if not (self.db.numericValueToggle or self.db.percentageToggle or self.db.bothToggle or self.db.noneToggle or self.db.xanaxgodNumericValueToggle or self.db.xanaxgodBothToggle) then
                self.db.noneToggle = true;
            end

            if self.db.numericValueToggle then
                self.db.numericValueToggle =  false;
            end
            if self.db.percentageToggle then
                self.db.percentageToggle =  false;
            end
            if self.db.bothToggle then
                self.db.bothToggle =  false;
            end
            if self.db.xanaxgodNumericValueToggle then
                self.db.xanaxgodNumericValueToggle =  false;
            end
            if self.db.xanaxgodBothToggle then
                self.db.xanaxgodBothToggle =  false;
            end

            self:RefreshUI()
            self:RefreshUI()
        end
        if setting == 'xanaxgodNumericValueToggle' then
            if not (self.db.numericValueToggle or self.db.percentageToggle or self.db.bothToggle or self.db.noneToggle or self.db.xanaxgodNumericValueToggle or self.db.xanaxgodBothToggle) then
                self.db.xanaxgodNumericValueToggle = true;
            end

            if self.db.numericValueToggle then
                self.db.numericValueToggle =  false;
            end
            if self.db.percentageToggle then
                self.db.percentageToggle =  false;
            end
            if self.db.bothToggle then
                self.db.bothToggle =  false;
            end
            if self.db.noneToggle then
                self.db.noneToggle =  false;
            end
            if self.db.xanaxgodBothToggle then
                self.db.xanaxgodBothToggle =  false;
            end

            self:RefreshUI()
            self:RefreshUI()
        end
        if setting == 'xanaxgodBothToggle' then
            if not (self.db.numericValueToggle or self.db.percentageToggle or self.db.bothToggle or self.db.noneToggle or self.db.xanaxgodNumericValueToggle or self.db.xanaxgodBothToggle) then
                self.db.xanaxgodBothToggle = true;
            end

            if self.db.numericValueToggle then
                self.db.numericValueToggle =  false;
            end
            if self.db.percentageToggle then
                self.db.percentageToggle =  false;
            end
            if self.db.bothToggle then
                self.db.bothToggle =  false;
            end
            if self.db.noneToggle then
                self.db.noneToggle =  false;
            end
            if self.db.xanaxgodNumericValueToggle then
                self.db.xanaxgodNumericValueToggle =  false;
            end

            self:RefreshUI()
            self:RefreshUI()
        end

    end

    local counter = CreateCounter(5);

    local UnitFrameStatusTextImage = "|TInterface\\Addons\\XanaxgodPvpMods\\media\\moduleImages\\UnitFrameStatusText:132:499:1:-1|t"

    myOptionsTable.args.statusTextGroup1 = {
        order = counter(),
        name = "Change Status Text Format",
        type = "group",
        inline = true, --inline makes it a normal group. else it is a tab group (myOptionsTable in core.lua)
        args = {
            statusTextGroup2 = {
                order = counter(),
                name = "Blizzard Formats",
                type = "group",
                inline = true, --inline makes it a normal group. else it is a tab group (myOptionsTable in core.lua)
                args = {
                    numericValueToggle = {
                        type = 'toggle',
                        name = 'Numeric',
                        desc = '',
                        order = counter(),
                        width = 0.47,
                        get = get,
                        set = set,
                    },
                    percentageToggle = {
                        type = 'toggle',
                        name = 'Percentage',
                        desc = '',
                        order = counter(),
                        width = 0.57,
                        get = get,
                        set = set,
                    },
                    bothToggle = {
                        type = 'toggle',
                        name = 'Both',
                        desc = '',
                        order = counter(),
                        width = 0.33,
                        get = get,
                        set = set,
                    },
                    noneToggle = {
                        type = 'toggle',
                        name = 'None',
                        desc = '',
                        order = counter(),
                        width = 0.42,
                        get = get,
                        set = set,
                    },
                }
            },
            statusTextGroup3 = {
                order = counter(),
                name = "Xanaxgod Formats",
                type = "group",
                inline = true, --inline makes it a normal group. else it is a tab group (myOptionsTable in core.lua)
                args = {
                    xanaxgodNumericValueToggle = {
                        type = 'toggle',
                        name = 'Xanaxgod Numeric',
                        desc = '',
                        order = counter(),
                        width = 0.83,
                        get = get,
                        set = set,
                    },
                    xanaxgodBothToggle = {
                        type = 'toggle',
                        name = 'Xanaxgod Both',
                        desc = '',
                        order = counter(),
                        width = 0.69,
                        get = get,
                        set = set,
                    },
                    reloadExecute = {
                        type = 'execute',
                        name = '/reload',
                        desc = '',
                        width = 0.45,
                        func = function()
                            ReloadUI()
                        end,
                        order = counter(),
                    },
                }
            }
        }
    }
    myOptionsTable.args.art222 = {
        order = counter(),
        type = 'description',
        name = '' .. UnitFrameStatusTextImage,
        width = 'full',
    };

    return myOptionsTable;
end

function Module:SetupStatusText()

    --NumericValue
    if self:IsEnabled() and self.db.numericValueToggle then
        SetCVar("statusText")
        SetCVar("statusText",1)
        SetCVar("statusTextDisplay", "NUMERIC")
    end
    --Percentage
    if self:IsEnabled() and self.db.percentageToggle then
        SetCVar("statusText")
        SetCVar("statusText",1)
        SetCVar("statusTextDisplay", "PERCENT")
    end
    --Both
    if self:IsEnabled() and self.db.bothToggle then
        SetCVar("statusText")
        SetCVar("statusText",1)
        SetCVar("statusTextDisplay", "BOTH")
    end
    --None
    if self:IsEnabled() and self.db.noneToggle then
        SetCVar("statusText")
        SetCVar("statusTextDisplay", "NONE")
    end
    --XanaxgodNumericValue
    if self:IsEnabled() and self.db.xanaxgodNumericValueToggle then
        SetCVar("statusText")
        SetCVar("statusText",1)
        SetCVar("statusTextDisplay", "NUMERIC")
        if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
            if IsAddOnLoaded("JaxClassicFrames") then
                local function NumericUpdater()
                    --health bars (player target and focus)
                    if JcfPlayerFrameHealthBarText:GetText() then
                        JcfPlayerFrameHealthBarText:SetText(JcfPlayerFrameHealthBarText:GetText():match("[^/]+[^ /]"))
                    end
                    if JcfTargetFrameTextureFrame.HealthBarText:GetText() then
                        JcfTargetFrameTextureFrame.HealthBarText:SetText(JcfTargetFrameTextureFrame.HealthBarText:GetText():match("[^/]+[^ /]"))
                    end
                    if JcfFocusFrameTextureFrame.HealthBarText:GetText() then
                        JcfFocusFrameTextureFrame.HealthBarText:SetText(JcfFocusFrameTextureFrame.HealthBarText:GetText():match("[^/]+[^ /]"))
                    end
                    --Mana/power bars (player target and focus)
                    if JcfPlayerFrameManaBarText:GetText() then
                        JcfPlayerFrameManaBarText:SetText(JcfPlayerFrameManaBarText:GetText():match("[^/]+[^ /]"))
                    end
                    if JcfTargetFrameTextureFrame.ManaBarText:GetText() then
                        JcfTargetFrameTextureFrame.ManaBarText:SetText(JcfTargetFrameTextureFrame.ManaBarText:GetText():match("[^/]+[^ /]"))
                    end

                    if JcfFocusFrameTextureFrame.ManaBarText:GetText() then
                        JcfFocusFrameTextureFrame.ManaBarText:SetText(JcfFocusFrameTextureFrame.ManaBarText:GetText():match("[^/]+[^ /]"))
                    end
                    --pet bars
                    if JcfPetFrameHealthBarText:GetText() then
                        JcfPetFrameHealthBarText:SetText(JcfPetFrameHealthBarText:GetText():match("[^/]+[^ /]"))
                    end
                    if JcfPetFrameManaBarText:GetText() then
                        JcfPetFrameManaBarText:SetText(JcfPetFrameManaBarText:GetText():match("[^/]+[^ /]"))
                    end

                end

                if self:IsHooked('UnitFrameHealthBar_OnUpdate') or self:IsHooked('UnitFrameManaBar_OnUpdate') then
                    return
                end
                self:SecureHook('UnitFrameHealthBar_OnUpdate', function()
                    NumericUpdater()
                end);

                self:SecureHook('UnitFrameManaBar_OnUpdate', function()
                    NumericUpdater()
                end);

                NumericUpdater()
                C_Timer.After(1, function() NumericUpdater() end)
                C_Timer.After(2, function() NumericUpdater() end)
                C_Timer.After(3, function() NumericUpdater() end)

            else
                --normal retail ui
                local function NumericUpdater()
                    --health bars (player target and focus)
                    if PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar.HealthBarText:GetText() then
                        PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar.HealthBarText:SetText(PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar.HealthBarText:GetText():match("[^/]+[^ /]"))
                    end
                    if TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBar.TextString:GetText() then
                        TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBar.TextString:SetText(TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBar.TextString:GetText():match("[^/]+[^ /]"))
                    end
                    if FocusFrame.TargetFrameContent.TargetFrameContentMain.HealthBar.TextString:GetText() then
                        FocusFrame.TargetFrameContent.TargetFrameContentMain.HealthBar.TextString:SetText(FocusFrame.TargetFrameContent.TargetFrameContentMain.HealthBar.TextString:GetText():match("[^/]+[^ /]"))
                    end
                    --Mana/power bars (player target and focus)
                    if PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar.ManaBarText:GetText() then
                        PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar.ManaBarText:SetText(PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar.ManaBarText:GetText():match("[^/]+[^ /]"))
                    end
                    if TargetFrame.TargetFrameContent.TargetFrameContentMain.ManaBar.ManaBarText:GetText() then
                        TargetFrame.TargetFrameContent.TargetFrameContentMain.ManaBar.ManaBarText:SetText(TargetFrame.TargetFrameContent.TargetFrameContentMain.ManaBar.ManaBarText:GetText():match("[^/]+[^ /]"))
                    end
                    if FocusFrame.TargetFrameContent.TargetFrameContentMain.ManaBar.ManaBarText:GetText() then
                        FocusFrame.TargetFrameContent.TargetFrameContentMain.ManaBar.ManaBarText:SetText(FocusFrame.TargetFrameContent.TargetFrameContentMain.ManaBar.ManaBarText:GetText():match("[^/]+[^ /]"))
                    end
                    --pet bars
                    if PetFrameHealthBarText:GetText() then
                        PetFrameHealthBarText:SetText(PetFrameHealthBarText:GetText():match("[^/]+[^ /]"))
                    end
                    if PetFrameManaBarText:GetText() then
                        PetFrameManaBarText:SetText(PetFrameManaBarText:GetText():match("[^/]+[^ /]"))
                    end

                end

                if self:IsHooked('UnitFrameHealthBar_OnUpdate') or self:IsHooked('UnitFrameManaBar_OnUpdate') then
                    return
                end
                self:SecureHook('UnitFrameHealthBar_OnUpdate', function()
                    NumericUpdater()
                end);

                self:SecureHook('UnitFrameManaBar_OnUpdate', function()
                    NumericUpdater()
                end);

                NumericUpdater()
                C_Timer.After(1, function() NumericUpdater() end)
                C_Timer.After(2, function() NumericUpdater() end)
                C_Timer.After(3, function() NumericUpdater() end)
            end
        end
        if WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC then
            --normal classic ui
            local function NumericUpdater()
                --health bars (player target and focus)
                if PlayerFrameHealthBarText:GetText() then
                    PlayerFrameHealthBarText:SetText(PlayerFrameHealthBarText:GetText():match("[^/]+[^ /]"))
                end
                if TargetFrameTextureFrame.HealthBarText:GetText() then
                    TargetFrameTextureFrame.HealthBarText:SetText(TargetFrameTextureFrame.HealthBarText:GetText():match("[^/]+[^ /]"))
                end
                if FocusFrameTextureFrame.HealthBarText:GetText() then
                    FocusFrameTextureFrame.HealthBarText:SetText(FocusFrameTextureFrame.HealthBarText:GetText():match("[^/]+[^ /]"))
                end
                --Mana/power bars (player target and focus)
                if PlayerFrameManaBarText:GetText() then
                    PlayerFrameManaBarText:SetText(PlayerFrameManaBarText:GetText():match("[^/]+[^ /]"))
                end
                if TargetFrameTextureFrame.ManaBarText:GetText() then
                    TargetFrameTextureFrame.ManaBarText:SetText(TargetFrameTextureFrame.ManaBarText:GetText():match("[^/]+[^ /]"))
                end
                if FocusFrameTextureFrame.ManaBarText:GetText() then
                    FocusFrameTextureFrame.ManaBarText:SetText(FocusFrameTextureFrame.ManaBarText:GetText():match("[^/]+[^ /]"))
                end
                --pet bars
                if PetFrameHealthBarText:GetText() then
                    PetFrameHealthBarText:SetText(PetFrameHealthBarText:GetText():match("[^/]+[^ /]"))
                end
                if PetFrameManaBarText:GetText() then
                    PetFrameManaBarText:SetText(PetFrameManaBarText:GetText():match("[^/]+[^ /]"))
                end

            end

            if self:IsHooked('TextStatusBar_UpdateTextStringWithValues') then
                return
            end

            self:SecureHook('TextStatusBar_UpdateTextStringWithValues', function()
                NumericUpdater()
            end);

            NumericUpdater()
            C_Timer.After(1, function() NumericUpdater() end)
            C_Timer.After(2, function() NumericUpdater() end)
            C_Timer.After(3, function() NumericUpdater() end)
        end
        if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
            --normal classic ui
            local function NumericUpdater()
                --health bars (player target and focus)
                if PlayerFrameHealthBarText:GetText() then
                    PlayerFrameHealthBarText:SetText(PlayerFrameHealthBarText:GetText():match("[^/]+[^ /]"))
                end
                if TargetFrameHealthBarText then
                    if TargetFrameHealthBarText:GetText() then
                        TargetFrameHealthBarText:SetText(TargetFrameHealthBarText:GetText():match("[^/]+[^ /]"))
                    end
                end

                --Mana/power bars (player target and focus)
                if PlayerFrameManaBarText:GetText() then
                    PlayerFrameManaBarText:SetText(PlayerFrameManaBarText:GetText():match("[^/]+[^ /]"))
                end
                if TargetFrameManaBarText then
                    if TargetFrameManaBarText:GetText() then
                        TargetFrameManaBarText:SetText(TargetFrameManaBarText:GetText():match("[^/]+[^ /]"))
                    end
                end

                --pet bars
                if PetFrameHealthBarText:GetText() then
                    PetFrameHealthBarText:SetText(PetFrameHealthBarText:GetText():match("[^/]+[^ /]"))
                end
                if PetFrameManaBarText:GetText() then
                    PetFrameManaBarText:SetText(PetFrameManaBarText:GetText():match("[^/]+[^ /]"))
                end

            end

            if self:IsHooked('TextStatusBar_UpdateTextStringWithValues') then
                return
            end

            self:SecureHook('TextStatusBar_UpdateTextStringWithValues', function()
                NumericUpdater()
            end);

            NumericUpdater()
            C_Timer.After(1, function() NumericUpdater() end)
            C_Timer.After(2, function() NumericUpdater() end)
            C_Timer.After(3, function() NumericUpdater() end)
        end
    end
    --XanaxgodBoth
    if self:IsEnabled() and self.db.xanaxgodBothToggle then
        SetCVar("statusText")
        SetCVar("statusText",1)
        SetCVar("statusTextDisplay", "NUMERIC")

        local function FormatValue(val)
            if val<100000 then return ("%.0f"):format(val)
            elseif val<100000000 then return ("%.0f K"):format(val/1000)
            elseif val<100000000000 then return ("%.0f M"):format(val/1000000)
            else return ("%.0ft"):format(val/1000000000000) end
        end

        if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
            if IsAddOnLoaded("JaxClassicFrames") then

                local function NumericUpdater()
                    --health bars (player target and focus)
                    local playerHealth = tostring(FormatValue(UnitHealth("player"))).." ("..tostring(UnitHealth("player")/UnitHealthMax("player")*100-(UnitHealth("player")/UnitHealthMax("player")*100)%1).."%)"
                    local targetHealth = tostring(FormatValue(UnitHealth("target"))).." ("..tostring(UnitHealth("target")/UnitHealthMax("target")*100-(UnitHealth("target")/UnitHealthMax("target")*100)%1).."%)"
                    local focusHealth = tostring(FormatValue(UnitHealth("focus"))).." ("..tostring(UnitHealth("focus")/UnitHealthMax("focus")*100-(UnitHealth("focus")/UnitHealthMax("focus")*100)%1).."%)"

                    local playerMana = tostring(FormatValue(UnitPower("player"))).." ("..tostring(UnitPower("player")/UnitPowerMax("player")*100-(UnitPower("player")/UnitPowerMax("player")*100)%1).."%)"
                    local targetMana = tostring(FormatValue(UnitPower("target"))).." ("..tostring(UnitPower("target")/UnitPowerMax("target")*100-(UnitPower("target")/UnitPowerMax("target")*100)%1).."%)"
                    local focusMana = tostring(FormatValue(UnitPower("focus"))).." ("..tostring(UnitPower("focus")/UnitPowerMax("focus")*100-(UnitPower("focus")/UnitPowerMax("focus")*100)%1).."%)"


                    if JcfPlayerFrameHealthBarText:GetText() then
                        JcfPlayerFrameHealthBarText:SetText(playerHealth)
                    end
                    if JcfTargetFrameTextureFrame.HealthBarText:GetText() then
                        JcfTargetFrameTextureFrame.HealthBarText:SetText(targetHealth)
                    end
                    if JcfFocusFrameTextureFrame.HealthBarText:GetText() then
                        JcfFocusFrameTextureFrame.HealthBarText:SetText(focusHealth)
                    end
                    --Mana/power bars (player target and focus)
                    if JcfPlayerFrameManaBarText:GetText() then
                        JcfPlayerFrameManaBarText:SetText(playerMana)
                    end
                    if JcfTargetFrameTextureFrame.ManaBarText:GetText() then
                        JcfTargetFrameTextureFrame.ManaBarText:SetText(targetMana)
                    end

                    if JcfFocusFrameTextureFrame.ManaBarText:GetText() then
                        JcfFocusFrameTextureFrame.ManaBarText:SetText(focusMana)
                    end
                    --pet bars
                    if JcfPetFrameHealthBarText:GetText() then
                        JcfPetFrameHealthBarText:SetText(JcfPetFrameHealthBarText:GetText():match("[^/]+[^ /]"))
                    end
                    if JcfPetFrameManaBarText:GetText() then
                        JcfPetFrameManaBarText:SetText(JcfPetFrameManaBarText:GetText():match("[^/]+[^ /]"))
                    end

                end

                if self:IsHooked('UnitFrameHealthBar_OnUpdate') or self:IsHooked('UnitFrameManaBar_OnUpdate') then
                    return
                end
                self:SecureHook('UnitFrameHealthBar_OnUpdate', function()
                    NumericUpdater()
                end);

                self:SecureHook('UnitFrameManaBar_OnUpdate', function()
                    NumericUpdater()
                end);

                NumericUpdater()
                C_Timer.After(1, function() NumericUpdater() end)
                C_Timer.After(2, function() NumericUpdater() end)
                C_Timer.After(3, function() NumericUpdater() end)

            else
                --normal retail ui
                local function NumericUpdater()
                    --health bars (player target and focus)
                    local playerHealth
                    if UnitHealth("player") > 0 then
                        playerHealth = tostring(FormatValue(UnitHealth("player"))).." ("..tostring(UnitHealth("player")/UnitHealthMax("player")*100-(UnitHealth("player")/UnitHealthMax("player")*100)%1).."%)"
                    end
                    local targetHealth
                    if UnitHealth("target") > 0 then
                        targetHealth = tostring(FormatValue(UnitHealth("target"))).." ("..tostring(UnitHealth("target")/UnitHealthMax("target")*100-(UnitHealth("target")/UnitHealthMax("target")*100)%1).."%)"
                    end
                    local focusHealth
                    if UnitHealth("focus") > 0 then
                        focusHealth = tostring(FormatValue(UnitHealth("focus"))).." ("..tostring(UnitHealth("focus")/UnitHealthMax("focus")*100-(UnitHealth("focus")/UnitHealthMax("focus")*100)%1).."%)"
                    end


                    local playerMana
                    if UnitPower("player") > 0 then
                        playerMana = tostring(FormatValue(UnitPower("player"))).." ("..tostring(UnitPower("player")/UnitPowerMax("player")*100-(UnitPower("player")/UnitPowerMax("player")*100)%1).."%)"
                    end
                    local targetMana
                    if UnitPower("target") > 0 then
                        targetMana = tostring(FormatValue(UnitPower("target"))).." ("..tostring(UnitPower("target")/UnitPowerMax("target")*100-(UnitPower("target")/UnitPowerMax("target")*100)%1).."%)"
                    end
                    local focusMana
                    if UnitPower("focus") > 0 then
                        focusMana = tostring(FormatValue(UnitPower("focus"))).." ("..tostring(UnitPower("focus")/UnitPowerMax("focus")*100-(UnitPower("focus")/UnitPowerMax("focus")*100)%1).."%)"
                    end


                    --health bars (player target and focus)
                    if PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar.HealthBarText:GetText() then
                        PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar.HealthBarText:SetText(playerHealth)
                    end
                    if TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBar.TextString:GetText() then
                        TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBar.TextString:SetText(targetHealth)
                    end
                    if FocusFrame.TargetFrameContent.TargetFrameContentMain.HealthBar.TextString:GetText() then
                        FocusFrame.TargetFrameContent.TargetFrameContentMain.HealthBar.TextString:SetText(focusHealth)
                    end
                    --Mana/power bars (player target and focus)
                    if PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar.ManaBarText:GetText() then
                        PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar.ManaBarText:SetText(playerMana)
                    end
                    if TargetFrame.TargetFrameContent.TargetFrameContentMain.ManaBar.ManaBarText:GetText() then
                        TargetFrame.TargetFrameContent.TargetFrameContentMain.ManaBar.ManaBarText:SetText(targetMana)
                    end
                    if FocusFrame.TargetFrameContent.TargetFrameContentMain.ManaBar.ManaBarText:GetText() then
                        FocusFrame.TargetFrameContent.TargetFrameContentMain.ManaBar.ManaBarText:SetText(focusMana)
                    end
                    --pet bars
                    if PetFrameHealthBarText:GetText() then
                        PetFrameHealthBarText:SetText(PetFrameHealthBarText:GetText():match("[^/]+[^ /]"))
                    end
                    if PetFrameManaBarText:GetText() then
                        PetFrameManaBarText:SetText(PetFrameManaBarText:GetText():match("[^/]+[^ /]"))
                    end

                end

                if self:IsHooked('UnitFrameHealthBar_OnUpdate') or self:IsHooked('UnitFrameManaBar_OnUpdate') then
                    return
                end
                self:SecureHook('UnitFrameHealthBar_OnUpdate', function()
                    NumericUpdater()
                end);

                self:SecureHook('UnitFrameManaBar_OnUpdate', function()
                    NumericUpdater()
                end);

                NumericUpdater()
                C_Timer.After(1, function() NumericUpdater() end)
                C_Timer.After(2, function() NumericUpdater() end)
                C_Timer.After(3, function() NumericUpdater() end)
            end
        end
        if WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC then
            --normal classic ui
            local function NumericUpdater()
                --health bars (player target and focus)
                local playerHealth = tostring(FormatValue(UnitHealth("player"))).." ("..tostring(UnitHealth("player")/UnitHealthMax("player")*100-(UnitHealth("player")/UnitHealthMax("player")*100)%1).."%)"
                local targetHealth = tostring(FormatValue(UnitHealth("target"))).." ("..tostring(UnitHealth("target")/UnitHealthMax("target")*100-(UnitHealth("target")/UnitHealthMax("target")*100)%1).."%)"
                local focusHealth = tostring(FormatValue(UnitHealth("focus"))).." ("..tostring(UnitHealth("focus")/UnitHealthMax("focus")*100-(UnitHealth("focus")/UnitHealthMax("focus")*100)%1).."%)"

                local playerMana = tostring(FormatValue(UnitPower("player"))).." ("..tostring(UnitPower("player")/UnitPowerMax("player")*100-(UnitPower("player")/UnitPowerMax("player")*100)%1).."%)"
                local targetMana = tostring(FormatValue(UnitPower("target"))).." ("..tostring(UnitPower("target")/UnitPowerMax("target")*100-(UnitPower("target")/UnitPowerMax("target")*100)%1).."%)"
                local focusMana = tostring(FormatValue(UnitPower("focus"))).." ("..tostring(UnitPower("focus")/UnitPowerMax("focus")*100-(UnitPower("focus")/UnitPowerMax("focus")*100)%1).."%)"


                --health bars (player target and focus)
                if PlayerFrameHealthBarText:GetText() then
                    PlayerFrameHealthBarText:SetText(playerHealth)
                end
                if TargetFrameTextureFrame.HealthBarText:GetText() then
                    TargetFrameTextureFrame.HealthBarText:SetText(targetHealth)
                end
                if FocusFrameTextureFrame.HealthBarText:GetText() then
                    FocusFrameTextureFrame.HealthBarText:SetText(focusHealth)
                end
                --Mana/power bars (player target and focus)
                if PlayerFrameManaBarText:GetText() then
                    PlayerFrameManaBarText:SetText(playerMana)
                end
                if TargetFrameTextureFrame.ManaBarText:GetText() then
                    TargetFrameTextureFrame.ManaBarText:SetText(targetMana)
                end
                if FocusFrameTextureFrame.ManaBarText:GetText() then
                    FocusFrameTextureFrame.ManaBarText:SetText(focusMana)
                end
                --pet bars
                if PetFrameHealthBarText:GetText() then
                    PetFrameHealthBarText:SetText(PetFrameHealthBarText:GetText():match("[^/]+[^ /]"))
                end
                if PetFrameManaBarText:GetText() then
                    PetFrameManaBarText:SetText(PetFrameManaBarText:GetText():match("[^/]+[^ /]"))
                end

            end

            if self:IsHooked('TextStatusBar_UpdateTextStringWithValues') then
                return
            end

            self:SecureHook('TextStatusBar_UpdateTextStringWithValues', function()
                NumericUpdater()
            end);

            NumericUpdater()
            C_Timer.After(1, function() NumericUpdater() end)
            C_Timer.After(2, function() NumericUpdater() end)
            C_Timer.After(3, function() NumericUpdater() end)
        end
        if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
            --normal classic ui
            local function NumericUpdater()
                --health bars (player target and focus)
                local playerHealth = tostring(FormatValue(UnitHealth("player"))).." ("..tostring(UnitHealth("player")/UnitHealthMax("player")*100-(UnitHealth("player")/UnitHealthMax("player")*100)%1).."%)"

                local playerMana = tostring(FormatValue(UnitPower("player"))).." ("..tostring(UnitPower("player")/UnitPowerMax("player")*100-(UnitPower("player")/UnitPowerMax("player")*100)%1).."%)"

                --health bars (player target and focus)
                if PlayerFrameHealthBarText:GetText() then
                    PlayerFrameHealthBarText:SetText(playerHealth)
                end
                if TargetFrameHealthBarText then
                    if TargetFrameHealthBarText:GetText() then
                        TargetFrameHealthBarText:SetText(TargetFrameHealthBarText:GetText():match("[^/]+[^ /]"))
                    end
                end

                --Mana/power bars (player target and focus)
                if PlayerFrameManaBarText:GetText() then
                    PlayerFrameManaBarText:SetText(playerMana)
                end
                if TargetFrameManaBarText then
                    if TargetFrameManaBarText:GetText() then
                        TargetFrameManaBarText:SetText(TargetFrameManaBarText:GetText():match("[^/]+[^ /]"))
                    end
                end

                --pet bars
                if PetFrameHealthBarText:GetText() then
                    PetFrameHealthBarText:SetText(PetFrameHealthBarText:GetText():match("[^/]+[^ /]"))
                end
                if PetFrameManaBarText:GetText() then
                    PetFrameManaBarText:SetText(PetFrameManaBarText:GetText():match("[^/]+[^ /]"))
                end

            end

            if self:IsHooked('TextStatusBar_UpdateTextStringWithValues') then
                return
            end

            self:SecureHook('TextStatusBar_UpdateTextStringWithValues', function()
                NumericUpdater()
            end);

            NumericUpdater()
            C_Timer.After(1, function() NumericUpdater() end)
            C_Timer.After(2, function() NumericUpdater() end)
            C_Timer.After(3, function() NumericUpdater() end)
        end
    end
end

function Module:SetupUI()
    self:SetupStatusText()
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
        return true -- wrath
    elseif WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        return true -- vanilla
    end
end