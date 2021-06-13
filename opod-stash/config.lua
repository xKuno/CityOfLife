Config = {}

Config.SharedObject = 'esx:getSharedObject' -- ESX Shared Object / Change if using a custom version of ESX

Config.UseWeightLimits = true -- Enable this if you want some form of weight limitation to be considered
Config.UseESX_1_2 = true -- Enable if using ESX 1.2, disable if not

Config.UseVSync = true -- HIGHLY RECOMMENDED TO USE

Config.Locale = 'en'

-- NOTIFICATIONS --
Config.MythicNotify   = true      -- You need to disable pNotify if this is enabled

Config.pNotify        = false       -- You need to disable MythicNotify if this is enabled
Config.pNotifyOptions = {
    layout            = 'bottomCenter' -- options are: top, topLeft, topRight, topCenter, center, centerLeft, centerRight, bottom, bottomLeft, bottomRight, bottomCenter
}

Config.UseTextContext = false -- Instead of the top left ESX interact notification, use text
Config.Use3DText = true       -- Use a new 3D input notification, please not that you need UseTextContent disabled.
-- GENERAL SETTINGS --

Config.Shells = {
    -- You may add any other shell to this config, if you purchase K4MB1s Stash House Shell pack you can uncomment the top two
    -- And they will work straight out of the box, if you want to setup any other shell its fairly simple if you know what you
    -- are doing.

    ['stashhouse1_shell'] = { name = 'Supreme Stashhouse', heading = 90.0, limit = 300, exitPos = vector3(21.11758, -0.4798584, -2.070999), vaultPos = vector3(-19.21558, 1.34565, -2.070822), carPort = vector3(16.96301, -0.223175, -2.07845), upgrade = vector3(-2.880066, 6.852905, -2.07077) },
    ['container2_shell'] = { name = 'Basic Stashhouse', heading = 90.0, limit = 50, exitPos = vector3(-0.02474976, -5.390511, -0.2135364), vaultPos = vector3(0.01261902, -2.368011, -0.2136364), upgrade = vector3(0.4020081, -1.334534, -0.2137756) },
    ['stashhouse3_shell'] = { name = 'Upgraded Stashhouse', heading = 180.0, limit = 150, exitPos = vector3(-0.1431274, 4.799316, -1.011749), vaultPos = vector3(0.6660767, -3.606445, -1.011749), carPort = vector3(0.1116333, 2.24469, -1.01165), upgrade = vector3(-0.9750977, -2.735352, -1.011665) },
}

Config.ShellPrices = { -- Prices for each shell
    ['stashhouse1_shell'] = { buyPrice = 50000000, upgradePrice = 5000000, sellPrice = 3000000},
    ['container2_shell'] = { buyPrice = 2500000, upgradePrice = 2500000, sellPrice = 2000000},
    ['stashhouse3_shell'] = { buyPrice = 7000000, upgradePrice = 7000000, sellPrice = 5000000},
}

Config.PoliceJob = 'police' 

Config.BlipSettings = {
    enable = true, -- Disable of enable blips
    title = 'Stash House for Sale', -- Title of unowned stash houses
    sprite = 474,
    colour = 0,
    scale = 0.8,
    display = 4,
    shortRanged = false,
    civOnly = true, -- Civs can only see the blips
    onlyAvailable = true, -- Only shows the unowned stash house blips
    showOwned = true, -- Show someone the stash houses they own
    ownedSprite = 473,
    ownedTitle = 'Your Stash House',
}

Config.RaidSettings = {
    RaidLength = {
        ['stashhouse1_shell'] = 5000, -- 5 seconds to raid this shell
        ['container2_shell'] = 2000,
        ['stashhouse3_shell'] = 2000,
    },
    DoorOpenTime = 2, -- The door will be open for 2 minutes before the police can no longer walk in
    Cooldown = 20, -- Once a stash house is raided it'd take 20 minutes to raid another one
}

Config.BuilderSettings = {
    UseAce = true, -- Set this to true or false depending on if you want to use ace perms
    BuildAce = 'command', -- If UseAce is true, set this to the ace group name you want to allow building for
    WhitelistedBuilders = { 
        ['steam:110000111b448bc'] = true, -- If you want to whitelist builders set their identifier here
        ['steam:11000011c4031cb'] = true,
    }
}

-- POLICE RAIDING SETTINGS --
Config.OfflineRaid   = true   -- Set true if you want the police to raid offline players

-- Only enable one of the following options
Config.UseSkillbar  = false  -- Use my skillbar resource, its available on modit.store
Config.UseProgbar   = false  -- Use progress bar
Config.UseHacking   = true   -- Use mHacking

-- DONT TOUCH UNLESS YOU KNOW WHAT YOUR DOING --
Config.ShellClasses = {
    ['stashhouse1_shell'] = { [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true, [9] = true, [11] = true, [12] = true, [13] = true, [17] = true, [18] = true},
    ['stashhouse3_shell'] = { [8] = true },
}