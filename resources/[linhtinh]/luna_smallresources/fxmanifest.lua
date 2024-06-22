fx_version 'adamant'
game 'gta5'

shared_script '@es_extended/imports.lua'
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server/balo.lua',
    'server/*.lua',
}
client_scripts {
    'client/3dme.lua',
    'client/newbie.lua',
    'client/crouchprone.lua',
    'client/discord.lua',
    'client/handsup.lua',
    'client/lagxac.lua',
    'client/getout.lua',
    'client/healthbar.lua',
    'client/showdame.lua',
    'client/balo.lua',
    -- 'client/clearvehexplosion.lua',
    -- 'client/no_drive_by-client.lua',
    'client/no_vehicle_rewards-client.lua',
    'client/passager.lua',
    'client/point.lua',
    'client/reduceNPC.lua',
    'client/kill.lua',
    'client/roll.lua',
    'client/consumable.lua',
    -- 'client/seatbelt.lua',
    'client/vehiclepush.lua',
    'client/lockveh.lua',
    'config.lua',
    'client/safezone.lua',
    'client/contract.lua'
}
