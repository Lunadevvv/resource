fx_version 'adamant'
game 'gta5'
-- UI
ui_page "ui/index.html"

shared_script '@es_extended/imports.lua'
files {
	"ui/index.html",
	"ui/script.js",
	"ui/style.css",
	"ui/debounce.min.js",
	"ui/bootstrap.min.css"
}
server_scripts {
	"@oxmysql/lib/MySQL.lua",
	"config.lua",
	"server/server.lua"
}
client_scripts {
	"config.lua",
	"client/client.lua"
}
