fx_version 'cerulean'
game 'gta5'
version 'legacy'

client_scripts{
    '@es_extended/locale.lua',
    'locales/*.lua',
    'config.lua',
    'client/client.lua'
}

shared_script {
    '@es_extended/imports.lua',
}

server_scripts{
    '@es_extended/locale.lua',
    'locales/*.lua',
    'config.lua',
    'server/server.lua'
}

dependencies {
	'es_extended',
}