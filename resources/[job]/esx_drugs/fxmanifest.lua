fx_version 'adamant'
game 'gta5'
shared_script '@es_extended/imports.lua'
server_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/es.lua',
	'config.lua',
	'server/main.lua',
	'server/mahoan.lua',
	'server/coke.lua',
	'server/weed.lua',
	'server/heroin.lua',
}
client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/es.lua',
	'config.lua',
	'client/main.lua',
	'client/weed.lua',
	'client/mahoan.lua',
	'client/coke.lua',
	'client/heroin.lua',
}
dependencies {
	'es_extended'
}
