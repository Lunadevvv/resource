fx_version 'cerulean'
game 'gta5'

author 'RoyaleWind'

description 'DEV RW'

lua54 'yes'

ui_page 'html/ui.html'
 

files {
	'html/progressbar.js',
	'html/script.js',
	'html/ui.html',
	'html/css/*.css',
	'html/images/icons/*.png',
	'html/css/fonts/*.ttf'
}

shared_scripts {
	'@es_extended/imports.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server.lua',
}

client_scripts {
	'client.lua',
}
escrow_ignore {
	'config.lua'
  }
