#!/usr/bin/bash
# run script providing MainLoop with

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 || exit 1; pwd -P )"
$GODOT_BINARY --deadless --quit --script "${SCRIPTPATH}/types.gd"
