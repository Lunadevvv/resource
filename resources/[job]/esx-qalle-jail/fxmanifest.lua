fx_version 'adamant'
game 'gta5'
shared_script '@es_extended/imports.lua'

server_scripts {
	"@oxmysql/lib/MySQL.lua",
	"config.lua",
	"server/server.lua"
}
client_scripts {
	"config.lua",
	"client/utils.lua",
	"client/client.lua"
}