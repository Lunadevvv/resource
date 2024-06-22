fx_version 'adamant'
game 'gta5'
description 'ESX Tattoo Shop'
version '1.4.2'
shared_script '@es_extended/imports.lua'
server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua'
}
client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/tattooList.lua',
	'client/main.lua'
}
dependencies {
	'es_extended',
	'skinchanger',
	'esx_skin'
}
--
--