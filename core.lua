local name, XPM = ...

local XanaxgodPvpMods = LibStub("AceAddon-3.0"):NewAddon(name, "AceConsole-3.0", "AceHook-3.0", "AceEvent-3.0")
if not (XanaxgodPvpMods) then
    return
end
XPM.Main = XanaxgodPvpMods

function XanaxgodPvpMods:OnInitialize()
    XPMDB = XPMDB or {}
    self.db = XPMDB

    self:InitializeDefaults()

    for moduleName, module in self:IterateModules() do
        if (self.db.modules[moduleName] == false) or (module:IsAvailableForCurrentVersion() == false) then
            module:Disable()
        end
    end

    self:InitializeConfig()
end

function XanaxgodPvpMods:InitializeDefaults()
    local defaults = {
        modules = {
            UIFrameOpacity = false,
            UIHideElements = false,
            SnowfallKeyPress = true,
            DisableLUAErrorPopup = true,
            DisableBlizzardButtonEffects = false,
            DisableBlizzardArenaFrames = false,
            MuteArenaDialog = false,
            NameplateSize = false,
            EssentialCVarSettings = false,
            UnitFrameCastBarSize = false,
            UnitFrameCastBarColors = false,
            UnitFrameStatusText = false,
            UnitFrameDarkness = false,
            UnitFrameCombatTracker = true,
            UnitFrameHighlightPurgeableBuffs = true,
            UnitFrameRangeTracker = false
        },
        moduleDb = {}
    }

    for key, value in pairs(defaults) do
        self.db[key] = self.db[key] or value
    end
end

function XanaxgodPvpMods:InitializeConfig()
    local icon = "|TInterface\\Addons\\XanaxgodPvpMods\\media\\icon:14:14|t"
    local icon2 = "|TInterface\\Addons\\XanaxgodPvpMods\\media\\icon:16:16:-2:-1|t"
    local text = "|cdf1fd288Xanaxgod PvP Mods|r"
    local space = " "
    local addonDisplayName = icon .. space .. text
    local addonDisplayName2 = icon2 .. text

    local count = 1
    local function increment()
        count = count + 1
        return count
    end
    self.options = {
        type = "group",
        name = addonDisplayName,
        childGroups = "tab",
        args = {
            modules = {
                order = increment(),
                type = "group",
                name = "PvP Mods",
                childGroups = "tree",
                args = {
                    desc = {
                        order = increment(),
                        type = "description",
                        name = "For requests and bug fixes, go harass via Twitter/Twitch at twitter.com/xanaxgod1337 or twitch.tv/xanaxgod1337."
                    }
                }
            }
        }
    }

    local function GetColoredModuleName(moduleName)
        local module = self:GetModule(moduleName)
        local realName = module.GetName and module:GetName() or moduleName

        local isModuleAvailable = module and module:IsAvailableForCurrentVersion()
        if not (isModuleAvailable) then
            return "|cff808080" .. realName .. "|r" -- |cff808080 is the grey color code
        end

        local isModuleEnabled = module and module:IsEnabled()
        if not (isModuleEnabled) then
            return "|cffff0000" .. realName .. "|r" -- |cffff0000 is the red color code
        end

        return module:IsEnabled() and realName
    end

    local myOptionsTable = {
        type = "group",
        childGroups = "tab",
        name = function(info)
            local moduleName = info[#info]
            return GetColoredModuleName(moduleName)
        end,
        desc = function(info)
            local moduleName = info[#info]
            local module = self:GetModule(moduleName)
            if (module and not module:IsAvailableForCurrentVersion()) then
                return "This module is unavailable (incompatible with game version or other AddOns)"
            end
            if (module and not module:IsEnabled()) then
                return "This module is disabled"
            end
            return "This module is enabled"
        end,
        args = {
            name = {
                order = 1,
                type = "header",
                name = function(info)
                    local moduleName = info[#info - 1]
                    return GetColoredModuleName(moduleName)
                end
            },
            description = {
                order = 2,
                type = "description",
                name = function(info)
                    local module = self:GetModule(info[#info - 1])
                    return module.GetDescription and module:GetDescription() or ""
                end
            },
            enable = {
                order = 3,
                name = "Enable module",
                desc = "Enables this module",
                type = "toggle",
                width = 1.5,
                get = function(info)
                    local moduleName = info[#info - 1]
                    local module = self:GetModule(moduleName)
                    if (module and not module:IsAvailableForCurrentVersion()) then
                        self:SetModuleState(moduleName, false)
                    else
                        return module:IsEnabled()
                    end
                end,
                set = function(info, enabled)
                    local moduleName = info[#info - 1]
                    local module = self:GetModule(moduleName)
                    if (module and not module:IsAvailableForCurrentVersion()) then
                        self:SetModuleState(moduleName, false)
                    else
                        self:SetModuleState(moduleName, enabled)
                    end
                end
            }
        }
    }

    -- Define tables to store module names for different states
    local enabledModules = {}
    local disabledModules = {}
    local unavailableModules = {}

    for moduleName, module in self:IterateModules() do
        local isModuleAvailable = module and module:IsAvailableForCurrentVersion()
        local isModuleEnabled = module and module:IsEnabled()

        -- Categorize modules based on their state
        if not (isModuleAvailable) then
            table.insert(unavailableModules, moduleName)
        elseif not (isModuleEnabled) then
            table.insert(disabledModules, moduleName)
        else
            table.insert(enabledModules, moduleName)
        end
    end

    -- Sort the tables alphabetically
    table.sort(enabledModules)
    table.sort(disabledModules)
    table.sort(unavailableModules)

    -- Helper function to add module to options table
    function XanaxgodPvpMods:AddModuleToOptionsTable(moduleName, orderFunction)
        local module = self:GetModule(moduleName)

        local defaultsCopy = CopyTable(myOptionsTable)
        self.db.moduleDb[moduleName] = self.db.moduleDb[moduleName] or {}
        local moduleOptions =
        module.GetOptions and module:GetOptions(defaultsCopy, self.db.moduleDb[moduleName]) or defaultsCopy
        moduleOptions.order = orderFunction()
        self.options.args.modules.args[moduleName] = moduleOptions
    end

    -- Add enabled modules to options table
    for _, moduleName in ipairs(enabledModules) do
        XanaxgodPvpMods:AddModuleToOptionsTable(moduleName, increment)
    end

    -- Add disabled modules to options table
    for _, moduleName in ipairs(disabledModules) do
        XanaxgodPvpMods:AddModuleToOptionsTable(moduleName, increment)
    end

    -- Add unavailable modules to options table
    for _, moduleName in ipairs(unavailableModules) do
        XanaxgodPvpMods:AddModuleToOptionsTable(moduleName, increment)
    end

    self.configCategory = addonDisplayName2

    local function OpenConfig()
        Settings.OpenToCategory(self.configCategory)
    end

    LibStub("AceConfig-3.0"):RegisterOptionsTable(self.configCategory, self.options)
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions(self.configCategory)

    self:RegisterChatCommand("xpm", function() OpenConfig() end)
    self:RegisterChatCommand("xanaxgodpvpmods", function() OpenConfig() end)
end

function XanaxgodPvpMods:SetModuleState(moduleName, enabled)
    if (enabled) then
        self:EnableModule(moduleName)
    else
        self:DisableModule(moduleName)
    end
    self.db.modules[moduleName] = enabled
end

function XanaxgodPvpMods:ReinitializeOptionsMenu()
    local count = 1
    local function increment()
        count = count + 1
        return count
    end

    local enabledModules = {}
    local disabledModules = {}
    local unavailableModules = {}

    for moduleName, module in self:IterateModules() do
        local isModuleAvailable = module and module:IsAvailableForCurrentVersion()
        local isModuleEnabled = module and module:IsEnabled()

        -- Categorize modules based on their state
        if not (isModuleAvailable) then
            table.insert(unavailableModules, moduleName)
        elseif not (isModuleEnabled) then
            table.insert(disabledModules, moduleName)
        else
            table.insert(enabledModules, moduleName)
        end
    end

    -- Sort the tables alphabetically
    table.sort(enabledModules)
    table.sort(disabledModules)
    table.sort(unavailableModules)

    -- Add enabled modules to options table
    for _, moduleName in ipairs(enabledModules) do
        self:AddModuleToOptionsTable(moduleName, increment)
    end

    -- Add disabled modules to options table
    for _, moduleName in ipairs(disabledModules) do
        self:AddModuleToOptionsTable(moduleName, increment)
    end

    -- Add unavailable modules to options table
    for _, moduleName in ipairs(unavailableModules) do
        self:AddModuleToOptionsTable(moduleName, increment)
    end

    -- Refresh the configuration options
    LibStub("AceConfigRegistry-3.0"):NotifyChange(self.configCategory)
end
