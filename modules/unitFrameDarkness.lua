local _, XPM = ...
local Main = XPM.Main

local Module = Main:NewModule("UnitFrameDarkness", "AceHook-3.0", "AceEvent-3.0")

function Module:OnEnable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:OnDisable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:GetDescription()
    return "This module allows you to darken your unit frames."
end

function Module:GetName()
    return "Unit Frame Darkness"
end

function Module:GetOptions(myOptionsTable, db)
    self.db = db
    local defaults = {
        frameDarknessRange = 0.5,
        castBarDarknessRange = 0.7
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

        if setting == "frameDarknessRange" then
            self:RefreshUI()
        end
        if setting == "castBarDarknessRange" then
            self:RefreshUI()
        end
    end

    local counter = CreateCounter(5)

    local UnitFrameDarknessImage =
    "|TInterface\\Addons\\XanaxgodPvpMods\\media\\moduleImages\\UnitFrameDarkness:134:499:1:-1|t"

    myOptionsTable.args.frameDarknessGroup1 = {
        order = counter(),
        name = "Set Unit Frame Darkness",
        type = "group",
        inline = true, --inline makes it a normal group. else it is a tab group (myOptionsTable in core.lua)
        args = {
            frameDarknessRange = {
                type = "range",
                name = "Frame Texture Darkness",
                order = counter(),
                get = get,
                set = set,
                min = 0,
                max = 1,
                step = 0.1,
                width = 1.1
            },
            castBarDarknessRange = {
                type = "range",
                name = "Cast Bar Darkness",
                order = counter(),
                get = get,
                set = set,
                min = 0,
                max = 1,
                step = 0.1,
                width = 1.1
            }
        }
    }
    myOptionsTable.args.art2222 = {
        order = counter(),
        type = "description",
        name = "" .. UnitFrameDarknessImage,
        width = "full"
    }
    return myOptionsTable
end

function Module:SetupFrameDarkness()
    local unitFrameTextureDarkness = self.db.frameDarknessRange
    local unitFrameCastBarDarkness = self.db.castBarDarknessRange

    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
        if C_AddOns.IsAddOnLoaded("JaxClassicFrames") then
            for i, v in pairs(
                    {
                        JcfPlayerFrameTexture,
                        JcfTargetFrameTextureFrameTexture,
                        JcfFocusFrameTextureFrameTexture,
                        JcfPetFrameTexture
                    }
            ) do
                if self:IsEnabled() then
                    if v then
                        v:SetVertexColor(unitFrameTextureDarkness, unitFrameTextureDarkness, unitFrameTextureDarkness)
                    end
                else
                    if v then
                        v:SetVertexColor(1, 1, 1)
                    end
                end
            end

            for i, v in pairs(
                    {
                        JcfTargetFrameSpellBar.Background,
                        JcfTargetFrameSpellBar.Border,
                        JcfTargetFrameSpellBar.TextBorder,
                        JcfTargetFrameSpellBar.BorderShield,
                        JcfFocusFrameSpellBar.Background,
                        JcfFocusFrameSpellBar.Border,
                        JcfFocusFrameSpellBar.TextBorder,
                        JcfFocusFrameSpellBar.BorderShield
                    }
            ) do
                if self:IsEnabled() then
                    if v then
                        v:SetVertexColor(unitFrameCastBarDarkness, unitFrameCastBarDarkness, unitFrameCastBarDarkness)
                    end
                else
                    if v then
                        v:SetVertexColor(1, 1, 1)
                    end
                end
            end
        elseif C_AddOns.IsAddOnLoaded("ClassicFrames") then
            for i, v in pairs(
                    {
                        PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.FrameTexture,
                        PlayerFrame.PlayerFrameContainer.AlternatePowerFrameTexture,
                        PlayerFrame.PlayerFrameContainer.FrameTexture,

                        TargetFrame.TargetFrameContainer.FrameTexture,
                        FocusFrame.TargetFrameContainer.FrameTexture,
                        PetFrameTexture
                    }
            ) do
                if self:IsEnabled() then
                    if v then
                        v:SetVertexColor(unitFrameTextureDarkness, unitFrameTextureDarkness, unitFrameTextureDarkness)
                    end
                else
                    if v then
                        v:SetVertexColor(1, 1, 1)
                    end
                end
            end

            for i, v in pairs(
                    {
                        TargetFrameSpellBar.Background,
                        TargetFrameSpellBar.Border,
                        TargetFrameSpellBar.TextBorder,
                        TargetFrameSpellBar.BorderShield,
                        FocusFrameSpellBar.Background,
                        FocusFrameSpellBar.Border,
                        FocusFrameSpellBar.TextBorder,
                        FocusFrameSpellBar.BorderShield
                    }
            ) do
                if self:IsEnabled() then
                    if v then
                        v:SetVertexColor(unitFrameCastBarDarkness, unitFrameCastBarDarkness, unitFrameCastBarDarkness)
                    end
                else
                    if v then
                        v:SetVertexColor(1, 1, 1)
                    end
                end
            end

        else
            --normal retail ui
            for i, v in pairs(
                    {
                        PlayerFrame.PlayerFrameContainer.FrameTexture,
                        TargetFrame.TargetFrameContainer.FrameTexture,
                        FocusFrame.TargetFrameContainer.FrameTexture,
                        PetFrameTexture
                    }
            ) do
                if self:IsEnabled() then
                    if v then
                        v:SetVertexColor(unitFrameTextureDarkness, unitFrameTextureDarkness, unitFrameTextureDarkness)
                    end
                else
                    if v then
                        v:SetVertexColor(1, 1, 1)
                    end
                end
            end

            for i, v in pairs(
                    {
                        TargetFrameSpellBar.Background,
                        TargetFrameSpellBar.Border,
                        TargetFrameSpellBar.TextBorder,
                        TargetFrameSpellBar.BorderShield,
                        FocusFrameSpellBar.Background,
                        FocusFrameSpellBar.Border,
                        FocusFrameSpellBar.TextBorder,
                        FocusFrameSpellBar.BorderShield
                    }
            ) do
                if self:IsEnabled() then
                    if v then
                        v:SetVertexColor(unitFrameCastBarDarkness, unitFrameCastBarDarkness, unitFrameCastBarDarkness)
                    end
                else
                    if v then
                        v:SetVertexColor(1, 1, 1)
                    end
                end
            end
        end
    end
    if WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC then
        --normal classic ui
        for i, v in pairs(
                {
                    PlayerFrameTexture,
                    TargetFrameTextureFrameTexture,
                    FocusFrameTextureFrameTexture,
                    PetFrameTexture
                }
        ) do
            if self:IsEnabled() then
                if v then
                    v:SetVertexColor(unitFrameTextureDarkness, unitFrameTextureDarkness, unitFrameTextureDarkness)
                end
            else
                if v then
                    v:SetVertexColor(1, 1, 1)
                end
            end
        end

        for i, v in pairs(
                {
                    TargetFrameSpellBar.Background,
                    TargetFrameSpellBar.Border,
                    TargetFrameSpellBar.TextBorder,
                    TargetFrameSpellBar.BorderShield,
                    FocusFrameSpellBar.Background,
                    FocusFrameSpellBar.Border,
                    FocusFrameSpellBar.TextBorder,
                    FocusFrameSpellBar.BorderShield
                }
        ) do
            if self:IsEnabled() then
                if v then
                    v:SetVertexColor(unitFrameCastBarDarkness, unitFrameCastBarDarkness, unitFrameCastBarDarkness)
                end
            else
                if v then
                    v:SetVertexColor(1, 1, 1)
                end
            end
        end
    end
    if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        --normal classic ui
        for i, v in pairs(
                {
                    PlayerFrameTexture,
                    TargetFrameTextureFrameTexture,
                    PetFrameTexture
                }
        ) do
            if self:IsEnabled() then
                if v then
                    v:SetVertexColor(unitFrameTextureDarkness, unitFrameTextureDarkness, unitFrameTextureDarkness)
                end
            else
                if v then
                    v:SetVertexColor(1, 1, 1)
                end
            end
        end

        for i, v in pairs(
                {
                    TargetFrameSpellBar.Background,
                    TargetFrameSpellBar.Border,
                    TargetFrameSpellBar.TextBorder,
                    TargetFrameSpellBar.BorderShield
                }
        ) do
            if self:IsEnabled() then
                if v then
                    v:SetVertexColor(unitFrameCastBarDarkness, unitFrameCastBarDarkness, unitFrameCastBarDarkness)
                end
            else
                if v then
                    v:SetVertexColor(1, 1, 1)
                end
            end
        end
    end
end

function Module:SetupUI()
    self:SetupFrameDarkness()
end

function Module:RefreshUI()
    if self:IsEnabled() then
        self:Disable()
        self:Enable()
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
    elseif WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC then
        return true -- cata
    elseif WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        return true -- vanilla
    end
end
