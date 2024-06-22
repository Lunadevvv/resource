fx_version 'adamant'
games { 'gta5' }
version "4.2"
lua54 'yes'
shared_script '@es_extended/imports.lua'
client_scripts {
    "config.lua",
    "Code/Client.lua"
}

server_scripts {
    "config.lua",
    "Code/Server.lua"
}

ui_page "Interface/index.html"

files {
    "Interface/index.html",
    "Interface/**/*"
}