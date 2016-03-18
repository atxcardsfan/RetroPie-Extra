#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="chromium"
rp_module_desc="chromium - Open Source Web Browser"
rp_module_menus="4+"
rp_module_flags="!mali !x86"

function depends_chromium() {
    getDepends git omxplayer libgnome-keyring-common libgnome-keyring0 libnspr4 libnss3 xdg-utils matchbox xorg
}

function sources_chromium() {
    if [[ "$__raspbian_ver" -lt 8 ]]; then
        sleep 1
    else
        git clone https://github.com/rg3/youtube-dl.git "youtube-dl"
        git clone https://github.com/kusti8/Rpi-youtube.git "rpi-youtube"
        git clone https://github.com/kusti8/Rpi-chromium.git "chromium"
    fi
}

function install_chromium() {
    if [[ "$__raspbian_ver" -lt 8 ]]; then
        sleep 1
    else
        dpkg -i "$md_build/chromium/chromium/chromium-codecs-ffmpeg-extra_48.0.2564.82-0ubuntu0.15.04.1.1193_armhf.deb"
        dpkg -i "$md_build/chromium/chromium/chromium-browser-l10n_48.0.2564.82-0ubuntu0.15.04.1.1193_all.deb" "$md_build/chromium/chromium/chromium-browser_48.0.2564.82-0ubuntu0.15.04.1.1193_armhf.deb"
    fi
    
    #./debinstall
    #cd ..
    #cp -R youtube-dl/ "$md_inst"
    #ln -s "$md_inst/youtube-dl/youtube_dl/__main__.py" /usr/bin/youtube-dl
    #chmod 755 /usr/bin/youtube-dl
}

function configure_chromium() {
    mkRomDir "ports"
    mkdir -p "$md_inst"
    cat >"$md_inst/chromium.sh" << _EOF_
#!/bin/bash
xset -dpms s off s noblank
matchbox-window-manager -use_titlebar no &
/usr/bin/chromium-browser
_EOF_
    chmod +x "$md_inst/chromium.sh"

    addPort "$md_id" "chromium" "Chromium - Open Source Web Browser" "xinit $md_inst/chromium.sh"
}
