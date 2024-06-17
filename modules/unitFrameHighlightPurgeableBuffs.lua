local _, XPM = ...
local Main = XPM.Main

local Module = Main:NewModule("UnitFrameHighlightPurgeableBuffs", "AceHook-3.0", "AceEvent-3.0")

function Module:OnEnable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:OnDisable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:GetDescription()
    return "This module allows you to highlight the purgeable buffs of your target and focus as if your current class/spec has an offensive dispell ability."
end

function Module:GetName()
    return "Unit Frame Highlight Purgeable Buffs"
end

function Module:GetOptions(myOptionsTable, db)
    self.db = db
    local defaults = {
        enableForEveryone = false,
        scaleFactor = 1.25,
        alphaFactor = 0.75
    }
    for key, value in pairs(defaults) do
        if self.db[key] == nil then
            self.db[key] = value
        end
    end

    local counter = CreateCounter(5)

    local get = function(info)
        return self.db[info[#info]]
    end
    local set = function(info, value)
        local setting = info[#info]
        self.db[setting] = value

        self:RefreshUI()
    end

    local UnitFrameHighlightPurgeableBuffsImage = "|TInterface\\Addons\\XanaxgodPvpMods\\media\\moduleImages\\UnitFrameHighlightPurgeableBuffs:176:342:92:-7|t"

    myOptionsTable.args.enableForEveryone = {
        order = counter(),
        type = "toggle",
        name = "Highlight purgeable buffs for friendly targets as well",
        desc = "Highlights purgeable buffs for friendly targets as well",
        width = "full",
        get = get,
        set = set
    }
    myOptionsTable.args.reloadExecute = {
        type = "execute",
        name = "/reload",
        desc = "",
        width = 0.45,
        func = function()
            ReloadUI()
        end,
        order = counter()
    }
    myOptionsTable.args.highlightSettingsGroup = {
        order = counter(),
        type = "group",
        name = "Highlight Settings",
        guiInline = true,
        args = {
            scaleFactor = {
                order = counter(),
                type = "range",
                name = "Scale",
                desc = "Adjust the scale of the purgeable buff highlight overlay",
                min = 1.0,
                max = 2.0,
                step = 0.01,
                get = get,
                set = set,
                width = 0.7
            },
            alphaFactor = {
                order = counter(),
                type = "range",
                name = "Opacity",
                desc = "Adjust the transparency of the purgeable buff highlight overlay",
                min = 0.1,
                max = 1.0,
                step = 0.05,
                get = get,
                set = set,
                width = 0.7
            },
            resetToDefault = {
                order = counter(),
                type = "execute",
                name = "Reset to Default",
                desc = "Reset scale and transparency to default values.",
                width = 0.75,
                func = function()
                    self.db.scaleFactor = defaults.scaleFactor
                    self.db.alphaFactor = defaults.alphaFactor
                    self:RefreshUI()
                end,
            }
        }
    }
    myOptionsTable.args.art3 = {
        order = counter(),
        type = "description",
        name = UnitFrameHighlightPurgeableBuffsImage,
        width = "full"
    }

    return myOptionsTable
end

function Module:SetupUI()
    local scaleFactor = self.db.scaleFactor
    local alphaFactor = self.db.alphaFactor

    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
        if IsAddOnLoaded("JaxClassicFrames") then
            JcfTargetFrame:HookScript("OnUpdate", function()
                self:UpdateAurasRetailJcf("target", scaleFactor, alphaFactor)
            end)
            JcfFocusFrame:HookScript("OnUpdate", function()
                self:UpdateAurasRetailJcf("focus", scaleFactor, alphaFactor)
            end)
        else
            TargetFrame:HookScript("OnUpdate", function()
                self:UpdateAurasRetail("target", scaleFactor, alphaFactor)
            end)
            FocusFrame:HookScript("OnUpdate", function()
                self:UpdateAurasRetail("focus", scaleFactor, alphaFactor)
            end)
        end
    elseif (WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC) or (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
        TargetFrame:HookScript("OnUpdate", function()
            self:UpdateAurasClassic("target", scaleFactor, alphaFactor)
        end)

        if WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC then
            FocusFrame:HookScript("OnUpdate", function()
                self:UpdateAurasClassic("focus", scaleFactor, alphaFactor)
            end)
        end

        --[[local eventHandlerFrame = CreateFrame("Frame", "EventHandlerFrame")
        eventHandlerFrame:RegisterEvent("UNIT_AURA")
        eventHandlerFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
        eventHandlerFrame:RegisterEvent("PLAYER_FOCUS_CHANGED")
        eventHandlerFrame:RegisterEvent("GROUP_ROSTER_UPDATE")

        eventHandlerFrame:SetScript("OnEvent", function(_, event, unit)
            if event == "PLAYER_TARGET_CHANGED" then
                Module:UpdateAurasClassic("target", scaleFactor, alphaFactor)
            elseif event == "PLAYER_FOCUS_CHANGED" then
                Module:UpdateAurasClassic("focus", scaleFactor, alphaFactor)
            elseif unit == "focus" then
                Module:UpdateAurasClassic(unit, scaleFactor, alphaFactor)
            end
        end)

        if not self:IsHooked("TargetFrame_UpdateAuras") then
            self:SecureHook("TargetFrame_UpdateAuras", function()
                self:UpdateAurasClassic("target", scaleFactor, alphaFactor)
            end)
        end
        if not self:IsHooked("UpdateAuras") then
            self:SecureHook("UpdateAuras", function()
                self:UpdateAurasClassic("focus", scaleFactor, alphaFactor)
            end)
        end
        ]]--
    end
end

function Module:UpdateAurasRetailJcf(unit, scaleFactor, alphaFactor)
    local prefix
    if unit == "target" then
        prefix = "JcfTargetFrameBuff"
    elseif unit == "focus" then
        prefix = "JcfFocusFrameBuff"
    end

    for i = 1, 40 do
        local buffFrameName = prefix .. i
        local buffFrame = _G[buffFrameName]
        local buffFrameStealable = _G[buffFrameName .. "Stealable"]
        local name, _, icon, debuffType = UnitAura(unit, i, "HELPFUL")

        if not buffFrame or not buffFrame:IsShown() then break end

        if buffFrameStealable then
            buffFrameStealable:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Stealable")
            buffFrameStealable:SetBlendMode("ADD")
            buffFrameStealable:SetPoint("CENTER", buffFrame, "CENTER")

            buffFrameStealable:SetSize(buffFrame:GetWidth() * scaleFactor, buffFrame:GetHeight() * scaleFactor)
            buffFrameStealable:SetAlpha(alphaFactor)
            buffFrameStealable:SetShown(debuffType == "Magic")
        else
            buffFrameStealable = buffFrame:CreateTexture(nil, "OVERLAY")
            buffFrameStealable:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Stealable")
            buffFrameStealable:SetBlendMode("ADD")
            buffFrameStealable:SetPoint("CENTER", buffFrame, "CENTER")

            buffFrameStealable:SetSize(buffFrame:GetWidth() * scaleFactor, buffFrame:GetHeight() * scaleFactor)
            buffFrameStealable:SetAlpha(alphaFactor)
            buffFrameStealable:SetShown(debuffType == "Magic")
        end

        -- Hide the Stealable texture for friendly targets if enableForEveryone is false
        if (not self.db.enableForEveryone) and (UnitIsFriend("player", unit)) then
            buffFrameStealable:Hide()
        end
    end
end

function Module:UpdateAurasRetail(unit, scaleFactor, alphaFactor)
    -- Function to update the Stealable texture for auras
    local function UpdateStealableTexture(buff, data)
        if not buff.Stealable then
            buff.Stealable = buff:CreateTexture(nil, "OVERLAY")
            buff.Stealable:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Stealable")
            buff.Stealable:SetBlendMode("ADD")
            buff.Stealable:SetPoint("CENTER", buff, "CENTER")
        end
        buff.Stealable:SetAlpha(alphaFactor)
        buff.Stealable:SetSize(buff:GetWidth() * scaleFactor, buff:GetHeight() * scaleFactor)
        buff.Stealable:SetShown(data.isStealable or data.dispelName == "Magic")
    end

    -- Update auras for the target
    if unit == "target" then
        for buff in TargetFrame.auraPools:GetPool("TargetBuffFrameTemplate"):EnumerateActive() do
            local data = C_UnitAuras.GetAuraDataByAuraInstanceID(buff.unit, buff.auraInstanceID)
            UpdateStealableTexture(buff, data)
        end
    end

    -- Update auras for the focus
    if unit == "focus" then
        for buff in FocusFrame.auraPools:GetPool("TargetBuffFrameTemplate"):EnumerateActive() do
            local data = C_UnitAuras.GetAuraDataByAuraInstanceID(buff.unit, buff.auraInstanceID)
            UpdateStealableTexture(buff, data)
        end
    end

    -- Hide the Stealable texture for friendly targets if enableForEveryone is false
    if (not self.db.enableForEveryone) and (UnitIsFriend("player", unit)) then
        if unit == "target" then
            for buff in TargetFrame.auraPools:GetPool("TargetBuffFrameTemplate"):EnumerateActive() do
                if buff.Stealable then
                    buff.Stealable:Hide()
                end
            end
        elseif unit == "focus" then
            for buff in FocusFrame.auraPools:GetPool("TargetBuffFrameTemplate"):EnumerateActive() do
                if buff.Stealable then
                    buff.Stealable:Hide()
                end
            end
        end
    end
end

function Module:UpdateAurasClassic(unit, scaleFactor, alphaFactor)
    local prefix
    if unit == "target" then
        prefix = "TargetFrameBuff"
    elseif unit == "focus" then
        prefix = "FocusFrameBuff"
    end

    for i = 1, 40 do
        local buffFrameName = prefix .. i
        local buffFrame = _G[buffFrameName]
        local buffFrameStealable = _G[buffFrameName .. "Stealable"]
        local name, _, icon, debuffType = UnitAura(unit, i, "HELPFUL")

        if not buffFrame or not buffFrame:IsShown() then break end

        if buffFrameStealable then
            buffFrameStealable:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Stealable")
            buffFrameStealable:SetBlendMode("ADD")
            buffFrameStealable:SetPoint("CENTER", buffFrame, "CENTER")

            buffFrameStealable:SetSize(buffFrame:GetWidth() * scaleFactor, buffFrame:GetHeight() * scaleFactor)
            buffFrameStealable:SetAlpha(alphaFactor)
            buffFrameStealable:SetShown(debuffType == "Magic")
        else
            buffFrameStealable = buffFrame:CreateTexture(nil, "OVERLAY")
            buffFrameStealable:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Stealable")
            buffFrameStealable:SetBlendMode("ADD")
            buffFrameStealable:SetPoint("CENTER", buffFrame, "CENTER")

            buffFrameStealable:SetSize(buffFrame:GetWidth() * scaleFactor, buffFrame:GetHeight() * scaleFactor)
            buffFrameStealable:SetAlpha(alphaFactor)
            buffFrameStealable:SetShown(debuffType == "Magic")
        end

        -- Hide the Stealable texture for friendly targets if enableForEveryone is false
        if (not self.db.enableForEveryone) and (UnitIsFriend("player", unit)) then
            buffFrameStealable:Hide()
        end
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
        return true -- retail
    elseif WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC then
        return true -- cata
    elseif WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        return true -- vanilla
    end
end
