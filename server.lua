# # # # # # # # # # # # # # # # # # # # # # # # # # #
#    ___ _____  __  _    ___ ___   _   _____   __   #
#   | __/ __\ \/ / | |  | __/ __| /_\ / __\ \ / /   #
#   | _|\__ \>  <  | |__| _| (_ |/ _ \ (__ \ V /    #
#   |___|___/_/\_\ |____|___\___/_/ \_\___| |_|     #
#                                                   #
#     Discord: https://discord.gg/esx-framework     #
#     Website: https://esx-framework.org/           #
#     CFG Docs: https://aka.cfx.re/server-commands  #
# # # # # # # # # # # # # # # # # # # # # # # # # # #


## You CAN edit the following:
endpoint_add_tcp "0.0.0.0:30120"
endpoint_add_udp "0.0.0.0:30120"

sets tags "default, deployer, esx, esx legacy, legacy, official, roleplay"

## You MAY edit the following:
sv_licenseKey "cfxk_djguRO79lHBGsQV1uK3X_3eZ8eD"
sv_hostname "test sv | ESX Legacy Server"
sets sv_projectName " test sv | [ESX Legacy]"
sets sv_projectDesc "The official recipe of the most popular FiveM RP framework, containing Jobs, Housing, Vehicles & more!"
set mysql_connection_string "mysql://root@localhost/ESXLegacy_A19E53?charset=utf8mb4"
set sv_enforceGameBuild 2189
set steam_webApiKey "9676AF84F3CA7CFD909B974568E1BB05"
load_server_icon logo.png

sv_maxclients 10
## Add system admins
add_principal group.admin group.user
add_ace group.admin command allow # allow all commands
add_ace group.admin command.quit deny # but don't allow quit
add_ace resource.es_extended command.add_ace allow
add_ace resource.es_extended command.add_principal allow
add_ace resource.es_extended command.remove_principal allow
add_ace resource.es_extended command.stop allow
add_ace group.admin command.addXP allow
add_principal identifier.steam:11000011a57116a group.admin #Zenda_Gaming
add_principal identifier.steam:1100001356691e5 group.admin
add_principal identifier.steam:110000135e3e2ee group.admin
add_principal identifier.steam:11000014037664d group.admin
## pma-voice config
setr voice_enableRadioAnim 1
setr voice_useNativeAudio true
setr voice_useSendingRangeOnly true

## ESX Translation convar (edit to change the language of ESX 
setr esx:locale "en"

## inventory setting
setr inventory:giveplayerlist true
set inventory:randomprices false
set inventory:randomloot false

## Default & Standalone resources
ensure spawnmanager
ensure hardcap
ensure oxmysql
ensure bob74_ipl
#ensure loadingscreen # enables the default Plume Loadingscreen

## ESX Legacy
start oxmysql   # this should be one of the first resources
start ox_lib
ensure es_extended
start ox_target
exec @ox_inventory/config.cfg
start ox_inventory
ensure [core]

## ESX Addons
ensure [standalone]
ensure [esx_addons]
ensure [shop]
ensure [job]
ensure [hud]
ensure [map]
ensure [linhtinh]
ensure [gas]
ensure pma-voice
