fx_version 'cerulean'
game 'gta5'

client_scripts {
	'config.lua',
	'client/main.lua',
	'example.lua'
}
shared_script '@es_extended/imports.lua'
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	-- '@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/main.lua'
}

ui_page {
	'html/ui.html'
}

files {
	'html/ui.html',
	'html/font/*.ttf',
	'html/font/*.otf',
	'html/css/*.css',
	'html/images/*.jpg',
	'html/images/*.png',
	'html/js/*.js',
}

escrow_ignore {
	'config.lua',
	'example.lua',
	'server/server_config.lua',

	'client/main.lua',
	'server/main.lua'
}  


lua54 'on'
dependency '/assetpacks'