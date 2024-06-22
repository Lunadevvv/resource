fx_version 'cerulean'
game 'gta5'
lua54 'yes'

client_script "client.lua"
shared_script "config.lua"
shared_script {
    '@es_extended/imports.lua',
    "@ox_lib/init.lua"
}

server_script "server.lua"