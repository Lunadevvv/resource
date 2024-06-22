fx_version   'cerulean'
lua54        'yes'
game         'gta5'

shared_script '@es_extended/imports.lua'
server_scripts {
    'server/main.lua',
}
client_script {
	'client/main.lua',
}
ui_page "html/index.html"
files {
   "html/index.css",
   "html/index.html",
   "html/index.js",
}