#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

pushd "$SCRIPT_DIR" || exit 1

execute_template() {
    input_file="$1"

    sed \
        -e "s|\\\$NAME|${NAME:-}|g" \
        -e "s|\\\$LOG_NAME|${NAME:-}|g" \
        -e "s|\\\$COMMAND_ARGS|${COMMAND_ARGS:-}|g" \
        -e "s|\\\$COMMAND_USER|${COMMAND_USER:-}|g" \
        -e "s|\\\$COMMAND|${COMMAND:-}|g" \
        -e "s|\\\$SHORTNAME|${SHORTNAME:-}|g" \
        -e "s|\\\$DESCRIPTION|${DESCRIPTION:-}|g" \
        "$input_file"
}

execute_template_inplace() {
    input_file="$1"

    sed -i \
        -e "s|\\\$NAME|${NAME:-}|g" \
        -e "s|\\\$LOG_NAME|${NAME:-}|g" \
        -e "s|\\\$COMMAND_ARGS|${COMMAND_ARGS:-}|g" \
        -e "s|\\\$COMMAND_USER|${COMMAND_USER:-}|g" \
        -e "s|\\\$COMMAND|${COMMAND:-}|g" \
        -e "s|\\\$SHORTNAME|${SHORTNAME:-}|g" \
        -e "s|\\\$DESCRIPTION|${DESCRIPTION:-}|g" \
        "$input_file"
}

generate_openrc() {
    mkdir -p openrc/conf.d
    mkdir -p openrc/init.d
    echo "[openrc]   Generating service file: $NAME"
    execute_template "openrc/conf.d.template" > "openrc/conf.d/$NAME"
    execute_template "openrc/init.d.template" > "openrc/init.d/$NAME"
    chmod a+x "openrc/init.d/$NAME"
}

generate_sysvinit() {
    mkdir -p sysvinit/init.d
    echo "[sysvinit] Generating service file: $NAME"
    execute_template "sysvinit/service-start-stop-daemon.template" > "sysvinit/init.d/$NAME"
    chmod a+x "sysvinit/init.d/$NAME"
}

generate_sysvinit_yocto() {
    mkdir -p sysvinit-yocto/init.d
    echo "[sysvinit-yocto] Generating service file: $NAME"
    execute_template "sysvinit-yocto/service-background.template" > "sysvinit-yocto/init.d/$NAME"
    chmod a+x "sysvinit-yocto/init.d/$NAME"
}

generate_s6_overlay() {
    shopt -s globstar

    mkdir -p s6-overlay/s6-rc.d
    echo "[s6-overlay] Generating service files: $NAME"

    rm -rf "s6-overlay/s6-rc.d/$NAME"
    rm -rf "s6-overlay/s6-rc.d/$NAME-log"

    cp -R s6-overlay/templates/service "s6-overlay/s6-rc.d/$NAME"
    for f in "s6-overlay/s6-rc.d/$NAME"/**/* ; do
        if [ -f "$f" ]; then
            execute_template_inplace "$f"
        fi
    done

    cp -R s6-overlay/templates/service-log "s6-overlay/s6-rc.d/$NAME-log"
    for f in "s6-overlay/s6-rc.d/$NAME-log"/**/* ; do
        if [ -f "$f" ]; then
            execute_template_inplace "$f"
        fi
    done

    mkdir -p s6-overlay/s6-rc.d/user/contents.d
    touch "s6-overlay/s6-rc.d/user/contents.d/$NAME-pipeline"

    find "s6-overlay/s6-rc.d" -name run -exec chmod +x {} \;
}

generate_supervisord() {
    mkdir -p supervisord/supervisord.d
    echo "[supervisord] Generating service file: $NAME"
    execute_template "supervisord/service.template" > "supervisord/conf.d/$NAME.conf"
}

generate_runit() {
    mkdir -p runit/runsvdir
    echo "[runit] Generating service files: $NAME"
    mkdir -p "runit/runsvdir/$NAME"
    execute_template "runit/run.template" > "runit/runsvdir/$NAME/run"
    chmod 755 "runit/runsvdir/$NAME/run"
}

for f in template-input/*
do
    if [ -f "$f" ]; then
        # Clear all values
        NAME=""
        COMMAND=""
        COMMAND_ARGS=""
        COMMAND_USER=""
        DESCRIPTION=""
        TEMPLATE_FOR=""
        SHORTNAME="${NAME:-}"

        # Source template variables
        # shellcheck disable=SC1090
        . "$f"

        # Set default name if not set
        SHORTNAME="${SHORTNAME:-$COMMAND}"

        if [ -z "$TEMPLATE_FOR" ]; then
            TEMPLATE_FOR="openrc sysvinit sysvinit s6_overlay runit supervisord"
        fi

        # Validate mandatory arguments
        if [ -n "$NAME" ] && [ -n "$COMMAND" ]; then
            echo -e "\nGenerating service files using: file = $f - name=$NAME, command=$COMMAND"

            for template_name in $TEMPLATE_FOR; do
                case "$template_name" in
                    openrc)
                        generate_openrc
                        ;;
                    sysvinit)
                        generate_sysvinit
                        ;;
                    sysvinit-yocto)
                        generate_sysvinit_yocto
                        ;;
                    s6_overlay)
                        generate_s6_overlay
                        ;;
                    runit)
                        generate_runit
                        ;;
                    supervisord)
                        generate_supervisord
                        ;;
                esac
            done
        else
            echo "Missing some mandatory variables. NAME and COMMAND must be set in template input file: $f" >&2
            exit 1
        fi

    fi
done

popd || exit 1
