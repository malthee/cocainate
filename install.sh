#!/bin/sh
set -eu

if [ "$(/usr/bin/uname -s)" != Darwin ]; then
    printf 'cocainate: macOS is required\n' >&2
    exit 1
fi

case "${1-}" in
    '')
        project_dir=$(CDPATH= cd "$(dirname "$0")" && pwd -P)
        source_file=$project_dir/cocainate
        ;;
    --remote)
        source_file=$(/usr/bin/mktemp "${TMPDIR:-/tmp}/cocainate.XXXXXX")
        trap '/bin/rm -f "$source_file"' EXIT
        /usr/bin/curl -fsSL https://raw.githubusercontent.com/malthee/cocainate/main/cocainate -o "$source_file"
        ;;
    *)
        printf 'Usage: install.sh [--remote]\n' >&2
        exit 2
        ;;
esac

bin_dir=${HOME:?HOME must be set}/.local/bin

/bin/mkdir -p "$bin_dir"
/usr/bin/install -m 755 "$source_file" "$bin_dir/cocainate"
printf 'Installed cocainate to %s\n' "$bin_dir/cocainate"

case ":${PATH-}:" in
    *":$bin_dir:"*) exit 0 ;;
esac

case "${SHELL-}" in
    */zsh) profile=$HOME/.zshrc ;;
    */bash) profile=$HOME/.bash_profile ;;
    *)
        printf 'Add %s to your PATH to run cocainate by name.\n' "$bin_dir"
        exit 0
        ;;
esac

path_line='export PATH="$HOME/.local/bin:$PATH"'
if ! [ -f "$profile" ] || ! /usr/bin/grep -Fqx "$path_line" "$profile"; then
    printf '\n%s\n' "$path_line" >> "$profile"
    printf 'Added ~/.local/bin to %s. Open a new terminal to use cocainate.\n' "$profile"
fi
