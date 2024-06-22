resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
ui_page "nui/ui.html"
client_scripts {
	"lang/br.lua",
	"lang/en.lua",
	
	"config.lua",
	"client.lua",
	"utils.lua",
}
shared_script '@es_extended/imports.lua'
server_scripts {
	"@oxmysql/lib/MySQL.lua",
	
	"lang/br.lua",
	"lang/en.lua",
	"config.lua",
	"server.lua"
}
files {
	"nui/lang/*",
	"nui/ui.html",
	"nui/panel.js",
	"nui/style.css",
	"nui/img/*"
}              