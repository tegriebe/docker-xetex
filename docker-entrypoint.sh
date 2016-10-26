#!/bin/bash
set -e

if [ "${1:0:1}" = '-' ]; then
	set -- xelatex "$@"
fi

if [ "$1" = 'xelatex' -a "$(id -u)" = '0' ]; then
    chown -R texlive:texlive "$LATEX_DATA"

    exec gosu texlive "$@"
fi

exec "$@"