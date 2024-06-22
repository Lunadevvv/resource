fx_version   'cerulean'
lua54        'yes'
game         'gta5'
shared_script '@es_extended/imports.lua'
client_script {
	'config.lua',
	'client.lua'
}
server_script {
	'@oxmysql/lib/mysql.lua',
	'config.lua',
	'main.lua'
	}
ui_page 'html/ui.html'
files {
	'html/style.css',
	'html/app.js',
	'html/ui.html',
}
