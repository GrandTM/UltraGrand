#!/usr/bin/env bash

            LIB=(
            'libreadline-dev'
            'libconfig-dev' 
            'libssl-dev' 
            'lua5.2'
            'liblua5.2-dev'
            'libevent-dev'
            'libjansson*'
            'libpython-dev'
            'make'
            'autoconf'
            'unzip'
            'git'
            'redis-server'
            'g++'
            'liblua5.2-dev'
            'git'
            'make'
            'unzip'
            'curl'
            'libcurl4-gnutls-dev'
            )
            local i
            for ((i=0;i<${#LIB[@]};i++)); do
               sudo apt install ${LIB[$i]} 
done
          wget https://valtman.name/files/telegram-cli-1222
mv telegram-cli-1222 tg
        chmod +x tg
        wget -O LuaRocks.tar.gz "http://luarocks.org/releases/luarocks-2.2.2.tar.gz"
        tar zxpf LuaRocks.tar.gz
        cd luarocks-2.2.2/
        ./configure; sudo make bootstrap 
        lualibs=(
        'luasec'
        'luasocket'
        'redis-lua'
        'json-lua'
        'lua-term'
        'serpent'
        'dkjson'
        'lua-cjson'
        'cjson'
        'luautf8'
        'xml'
        'multipart-post'
        'fakeredis'
        'Lua-cURL'
        )
        local i
        for ((i=0;i<${#lualibs[@]};i++)); do
           sudo luarocks install ${lualibs[$i]}
done