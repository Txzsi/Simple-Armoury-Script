fx_version 'cerulean'
games { 'gta5' }
description 'Simple armory script with a decent UI :)'


ui_page 'web/web.html'

client_scripts {
    'client.lua',
}

shared_script 'config/config.lua'

server_scripts {
    'server.lua',
    'config/webhooks.lua'
}

files {
    'web/web.html',
}
