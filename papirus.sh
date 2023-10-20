#!/bin/sh

set -e

gh_repo="papirus-icon-theme"
gh_desc="Papirus icon theme"

cat <<- EOF

$gh_desc
https://github.com/PapirusDevelopmentTeam/$gh_repo

EOF

: "${DESTDIR:=${HOME}/.icons}"
: "${ICON_THEMES:=Papirus Papirus-Dark}"
: "${TAG:=master}"
: "${uninstall:=false}"

_msg() {
    echo "=>" "$@"
}

_rm() {
    # removes parent directories if empty
     rm -rf "$1"
     rmdir -p "$(dirname "$1")" 2>/dev/null || true
}

# {
#     if [ -w "$DESTDIR" ] || [ -w "$(dirname "$DESTDIR")" ]; then
#         "$@"
#     else
#         sudo "$@"
#     fi
# }

_download() {
    _msg "Getting the latest version from GitHub ..."
     wget -q --show-progress -O "$temp_file" \
        "https://github.com/PapirusDevelopmentTeam/$gh_repo/archive/$TAG.tar.gz"
    _msg "Unpacking archive ..."
    tar -xzf "$temp_file" -C "$temp_dir"
}

_uninstall() {
    eval set -- "$@"  # split args by space

    for theme in "$@"; do
        test -d "$DESTDIR/$theme" || continue
        _msg "Deleting '$theme' ..."
        _rm "$DESTDIR/$theme"
    done
}

_install() {
     mkdir -p "$DESTDIR"

    eval set -- "$@"  # split args by space

    for theme in "$@"; do
        test -d "$temp_dir/$gh_repo-$TAG/$theme" || continue
        _msg "Installing '$theme' ..."
         cp -R "$temp_dir/$gh_repo-$TAG/$theme" "$DESTDIR"
         cp -f \
            "$temp_dir/$gh_repo-$TAG/AUTHORS" \
            "$temp_dir/$gh_repo-$TAG/LICENSE" \
            "$DESTDIR/$theme" || true
         gtk-update-icon-cache -q "$DESTDIR/$theme" || true
    done

    # Try to restore the color of folders from a config
    if command -v papirus-folders >/dev/null; then
        papirus-folders -R || true
    fi
}

_cleanup() {
    _msg "Clearing cache ..."
    rm -rf "$temp_file" "$temp_dir"
    rm -f "$HOME/.cache/icon-cache.kcache"
    _msg "Done!"
}

trap _cleanup EXIT HUP INT TERM

temp_file="$(mktemp -u)"
temp_dir="$(mktemp -d)"

if [ "$uninstall" = "false" ]; then
    _download
    _uninstall "$ICON_THEMES"
    _install "$ICON_THEMES"
else
    _uninstall "$ICON_THEMES"
fi
