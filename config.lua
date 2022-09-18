Cfg = {}

Cfg.DiscordLogWebhook = ''                          -- Discord webhook <-> OPTIONAL, !IF NOT WANTED, DON'T TOUCH!

Cfg.Localization = {                                -- Locales for texts in this script
    ['gps_set'] = 'GPS-Location: Set!',
    ['want_to_buy'] = 'Do you want to buy x%s item %s for %s$ ?',
    ['no'] = 'No',
    ['yes'] = 'Yes',
    ['buy_inv_full'] = "~r~You don't have enough space!",
    ['buy_bought'] = 'You bought x%s %s for %s$',
    ['buy_no_money'] = "You don't have enough money! You are missing %s$",
    ['log_title'] = 'Shop log',
    ['log_footer'] = 'SERVER NAME',
    ['log_bot_name'] = 'Shop log bot',
    ['log_bought'] = '%s Bought:\nShop: %s\nItem: %s/%s\nCount: %s\nPrice: %s$'
}

Cfg.BlipSettings = {                                -- Default settings for blips <-> ONLY CHOSEN SHOPS
    Sprite = 59,
    Scale = 0.8,
    Display = 4,
    Colour = 38,
    DefaultName = 'Shop'
}

Cfg.MarkerSettings = {                              -- Default settings for markers <-> ONLY CHOSEN SHOPS
    DrawDistance = 20.0,
    MarkerColour = {r = 52, g = 180, b = 235},
    MarkerType = 27,
    MarkerSize = 1.5                                -- Same scale for every direction
}

Cfg.ShopSettings = {
    ['Shop'] = {                                  --  Name of the shop, only shows in logs (if enabled) and helps identifying shop type in Config <-> REQUIRED
        Locations = {                               --  Shop locations <-> REQUIRED
            vector3( 1397.529, 3610.59, 34.981),
            vector3( -711.74, -915.15, 19.22),
            vector3( 373.875, 325.896, 102.566),
            vector3( 2557.458, 382.282, 107.622),
            vector3( -3038.939, 585.954, 6.908),
            vector3(-3241.927, 1001.462, 11.830),
            vector3( 547.431, 2671.710, 41.156),
            vector3( 1961.464, 3740.672, 31.343),
            vector3( 2678.916, 3280.671, 54.241),
            vector3( 1729.216, 6414.131, 34.037),
            vector3( -201.13, 6353.73, 30.49),
            vector3( 1135.808,-982.281, 45.415),
            vector3( -1222.915, -906.983, 11.326),
            vector3( -1487.553, -379.107, 39.163),
            vector3( -2968.243, 390.910,14.043),
            vector3( 1166.024, 2708.930, 37.157),
            vector3( -48.519, -1757.514, 28.421),
            vector3( 26.08, -1347.15, 28.51),
            vector3( 1593.91, 6454.73, 25.01),
            vector3( -201.13, 6353.73, 30.49),
            vector3( 1163.373,-323.801, 68.205),
            vector3(-1820.523, 792.518, 137.118),
            vector3( 1698.388, 4924.404, 41.063)
        },

        Items = {                                   --  Shop items for sale <-> REQUIRED
            { name = "water", price = 15 },
            { name = "bread", price = 30 }
        },

        BlackMoneyPayment = false,                  --  Defines if player pays with bank balance or black money; (false = pay by bank) <-> REQUIRED       
        OpenControl = 'E',                          --  Key control for opening this specific shop type's shops <-> REQUIRED
        TextPrompt = '~g~[E] ~w~- Open shop',       --  Text prompt shown when inside activation area <-> REQUIRED
 
        BlipEnabled = true,                         --  Defines if this specific shop type has its shop blips enabled <-> REQUIRED
        MarkerEnabled = true,                       --  If this row doesn't exist, this specific shop type's markers won't show at all <-> REQUIRED
    },

    ['Pharmacy'] = {                                --  Name of the shop, only shows in logs (if enabled) and helps identifying shop type in Config <-> REQUIRED
        Locations = {                               --  Shop locations <-> REQUIRED
            vector3(312.39855957031, -592.93756103516, 42.30405380249),
            vector3(350.34487915039, -589.64343261719, 27.816836853027)
        },

        Items = {                                   --  Shop items for sale <-> REQUIRED
            { name = 'medikit', price = 1200 },
            { name = 'bandage', price = 600 }
        },

        BlackMoneyPayment = false,                  --  Defines if player pays with bank balance or black money; (false = pay by bank) <-> REQUIRED       
        OpenControl = 'E',                          --  Key control for opening this specific shop type's shops <-> REQUIRED
        TextPrompt = '~r~[E] ~w~- Open pharmacy',   --  Text prompt shown when inside activation area <-> REQUIRED
 
        BlipEnabled = false,                        --  Defines if this specific shop type has its shop blips enabled <-> REQUIRED
        MarkerEnabled = true,                       --  If this row doesn't exist, this specific shop type's markers won't show at all <-> REQUIRED
        MarkerColour = {r = 255, g = 50, b = 50},
        AccountJob = 'ambulance'                    --  Defines which whitelist-job's society account gets this specific shop type's shop profits <-> OPTIONAL, REQUIRES 'ESX_ADDONACCOUNT' & 'ESX_SOCIETY'

    }
}