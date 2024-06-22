fx_version 'cerulean'
game { 'gta5' }
lua54 'yes'
ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/main.css',
	'html/app.js',
}
shared_script '@es_extended/imports.lua'
client_scripts {
	'client.lua'
}
server_scripts {
	'server.lua'
}
dependencies {
	'es_extended'
}
