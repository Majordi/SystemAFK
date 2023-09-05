fx_version 'adamant'

game 'gta5'

client_scripts {
    "client/*.lua",
}
shared_scripts {
    "shared/*.lua",
}
server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "server/*.lua",
}

ui_page "ui/index.html"

files {
    "ui/images/*.png",
    "ui/sounds/*.mp3",
    "ui/js/index.js",
    "ui/css/style.css",
    "ui/index.html",
}