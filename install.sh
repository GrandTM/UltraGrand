#!/usr/bin/env bash

    make_progress() {
exe=`lua <<-EOF
    print(tonumber($1)/tonumber($2)*100)
EOF
`
    echo ${exe:0:4}
}
    install() {
            sudo apt update --force-yes &>> /dev/null
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
                apt install ${LIB[$i]} &>> /dev/null
            done
    }
    install_Rocks(){ 
        wget -O LuaRocks.tar.gz "http://luarocks.org/releases/luarocks-2.2.2.tar.gz"
        tar zxpf LuaRocks.tar.gz
        cd luarocks-2.2.2/
        ./configure; sudo make bootstrap 
        #####################
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
    }
    download_tgcli(){  
        wget https://valtman.name/files/telegram-cli-1222
mv telegram-cli-1222 tg
        chmod +x tg
    }

install 
install_Rocks
download_tgcli