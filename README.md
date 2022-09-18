# esx_t_proshops
A highly customizable shop script, no database needed

INSTRUCTIONS

-------->>>>   SHOP OPTIONS   <<<<--------  Data inserted in 'config.lua' file, in chart 'Cfg.ShopSettings'

    ['Shop'] = {                                    --  Name of the shop, only shows in logs (if enabled) and helps identifying shop type in Config <-> REQUIRED
        Locations = {                               --  Shop locations <-> REQUIRED

            vector3(-1820.523, 792.518, 137.118),
            vector3( 1698.388, 4924.404, 41.063)
        },

        Items = {                                   --  Shop items for sale <-> REQUIRED
            { name = 'water', price = 15 },
            { name = 'bread', price = 30 }
        },

        BlackMoneyPayment = false,                  --  Defines if player pays with bank balance or black money; (false = pay by bank) <-> REQUIRED       
        OpenControl = 'E',                          --  Key control for opening this specific shop type's shops <-> REQUIRED
        TextPrompt = '~g~[E] ~w~- Open shop',       --  Text prompt shown when inside activation area <-> REQUIRED
 
        BlipEnabled = true,                         --  Defines if this specific shop type has its shop blips enabled <-> REQUIRED
        MarkerEnabled = true,                       --  If this row doesn't exist, this specific shop type's markers won't show at all <-> REQUIRED

                                                    --  <-> OPTIONAL SETTINGS, !! --> IF SETTING NOT NEEDED, DELETE WHOLE ROW FROM THE STORES CONFIG <-- !!

        BlipName = '24/7',                        --  Overrides default blip name <-> OPTIONAL <-> DEPENDENCY: BlipEnabled = true, ROW CAN BE DELETED
        MarkerType = 27,                            --  Overrides default marker type <-> OPTIONAL <-> DEPENDENCY: MarkerEnabled = true, ROW CAN BE DELETED
        MarkerColour = {r = 235, g = 180, b = 52},  --  Overrides default marker colour <-> OPTIONAL <-> DEPENDENCY: MarkerEnabled = true, ROW CAN BE DELETED
        AuthJobs = {'police', 'mechanic'},          --  Jobs that are allowed to see and use this specific shop type's shops <-> OPTIONAL, ROW CAN BE DELETED
        AccountJob = 'ambulance'                    --  Defines which whitelist-job's society account gets this specific shop type's shop profits <-> OPTIONAL,                                                                 REQUIRES 'ESX_ADDONACCOUNT' & 'ESX_SOCIETY', ROW CAN BE DELETED

    }

