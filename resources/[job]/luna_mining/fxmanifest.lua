fx_version 'cerulean'
game 'gta5'
lua54 'yes'

game 'gta5'
shared_script {
	'@es_extended/imports.lua',
	'@ox_lib/init.lua',
}

server_scripts {
	'server/main.lua',
	'config.lua',
	"@oxmysql/lib/MySQL.lua"
}

client_scripts {
	'config.lua',
	'client/main.lua'
}