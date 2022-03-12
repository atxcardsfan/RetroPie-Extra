#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="shadowwarrior"
rp_module_desc="Jfsw - Shadow warrior port"
rp_module_licence="GPL https://github.com/jonof/jfsw/blob/master/GPL.TXT"
rp_module_help="you need to put the game files in the shadowwarrior folder"
rp_module_repo="git https://github.com/jonof/jfsw.git master"
rp_module_section="exp"
rp_module_flags=""

function depends_shadowwarrior() {
    getDepends libgl1-mesa-dev libsdl2-dev libvorbis-dev timidity freepats rename
}

function sources_shadowwarrior() {
    gitPullOrClone
}

function build_shadowwarrior() {
    make DATADIR="$romdir/ports/shadowwarrior" RELEASE=1 USE_POLYMOST=1 USE_OPENGL=USE_GLES2 WITHOUT_GTK=1 OPTOPT="-march=armv8-a+crc -mtune=cortex-a53"
    md_ret_require="$md_build/sw"
}

function install_shadowwarrior() {
    md_ret_files='sw'
}

function gamedata_shadowwarrior() {
    local dest="$romdir/ports/shadowwarrior"
    mkUserDir "$dest"
    pushd "$dest"
    rename 'y/A-Z/a-z/' *
    popd
    if [[ ! -f "$dest/sw.grp" ]]; then
        # download shareware data
        local tempdir="$(mktemp -d)"
        download ftp://ftp.3drealms.com/share/3dsw12.zip "$tempdir"
        unzip -Lo "$tempdir/3dsw12.zip" swsw12.shr -d "$tempdir"
        unzip -Lo "$tempdir/swsw12.shr" sw.grp sw.rts -d "$dest"
        rm -rf "$tempdir"
    fi
    chown -R $user:$user "$dest"
}
	
function configure_shadowwarrior() {
    [[ "$md_mode" == "install" ]] && gamedata_shadowwarrior
    addPort "$md_id" "sw" "Jfsw - Shadow Warrior source port" "$md_inst/sw %ROM%" ""
    local gamedir="$romdir/ports/shadowwarrior"
    [[ -f "$gamedir/dragon.zip" ]] && addPort "$md_id" "sw" "Jfsw - Shadow Warrior: Twin Dragon" "$md_inst/sw %ROM%" "-gdragon.zip"
    [[ -f "$gamedir/wt.grp" ]] && addPort "$md_id" "sw" "Jfsw - Shadow Warrior: Wanton Destruction" "$md_inst/sw %ROM%" "-gwt.grp"
    moveConfigDir "$home/.jfsw" "$md_conf_root/sw"
}
