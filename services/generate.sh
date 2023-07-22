#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

pushd "$SCRIPT_DIR" || exit 1

execute_template() {
    input_file="$1"
    shift

    NAME="$1"
    COMMAND="$2"
    COMMAND_ARGS="$3"
    DESCRIPTION="$4"

    sed \
        -e "s/\\\$NAME/$NAME/g" \
        -e "s/\\\$COMMAND_ARGS/$COMMAND_ARGS/g" \
        -e "s/\\\$COMMAND/$COMMAND/g" \
        -e "s/\\\$DESCRIPTION/$DESCRIPTION/g" \
        "$input_file"
}

generate_openrc() {
    NAME="$1"

    mkdir -p openrc/conf.d
    mkdir -p openrc/init.d
    echo "[openrc]   Generating service file: $NAME"
    execute_template "openrc/conf.d.template" "$@" > "openrc/conf.d/$NAME"
    execute_template "openrc/init.d.template" "$@" > "openrc/init.d/$NAME"
    chmod a+x "openrc/init.d/$NAME"
}

generate_sysvinit() {
    NAME="$1"

    mkdir -p sysvinit/init.d
    echo "[sysvinit] Generating service file: $NAME"
    execute_template "sysvinit/service.template" "$@" > "sysvinit/init.d/$NAME"
    chmod a+x "sysvinit/init.d/$NAME"
}

i=0
while read -r line
do
    # ignore header
    if [ "$i" -eq 0 ]; then
        i=$(( i + 1))
        continue
    fi

    i_name=$(echo "$line" | cut -d, -f1 )
    i_cmd=$(echo "$line" | cut -d, -f2 )
    i_cmd_args=$(echo "$line" | cut -d, -f3 )
    i_cmd_description=$(echo "$line" | cut -d, -f4 )

    generate_openrc "$i_name" "$i_cmd" "$i_cmd_args" "$i_cmd_description"
    generate_sysvinit "$i_name" "$i_cmd" "$i_cmd_args" "$i_cmd_description"
    i=$(( i + 1 ))

done < template_input.csv

popd || exit 1
