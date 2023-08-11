#!/bin/bash
set -e
# -----------------------------------------------
# Build service files
# -----------------------------------------------
help() {
  cat <<EOF
Build linux and tarballs containing services files for various linux init systems

For example, the following init systems are included (though more could be added later)
* openrc
* sysvinit
* runit (void linux)
* s6-overlay (for docker)
* supervisord (python based supervisor)

The tarball (.tar.gz) is also created by extracting the data tarball from the debian package (per init system).

Usage:
    $0

Flags:
    --output <string>           Output folder where the packages will be written to
    --help|-h                   Show this help

Optional Environment variables (instead of flags)

OUTPUT_DIR            Equivalent to --output flag

Examples:
    $0 --output dist

    \$ Build service definition and output them to the ./dist folder
EOF
}

OUTPUT_DIR="${OUTPUT_DIR:-dist}"

#
# Argument parsing
#
POSITIONAL=()
while [[ $# -gt 0 ]]
do
    case "$1" in
        # Output folder where the packages will be written to
        --output)
            OUTPUT_DIR="$2"
            shift
            ;;

        --help|-h)
            help
            exit 0
            ;;
        
        -*)
            echo "Unrecognized flag" >&2
            help
            exit 1
            ;;

        *)
            POSITIONAL+=("$1")
            ;;
    esac
    shift
done
set -- "${POSITIONAL[@]}"

PACKAGE_TYPES=(
    apk
    deb
    rpm
)

build() {
    nfpm_file="$1"
    output_dir="$2"

    PACKAGE_NAME=$(grep "name: " "$nfpm_file" | cut -d: -f2 | xargs)

    echo ""
    echo "----------------------------------------"
    echo "Packaging: $PACKAGE_NAME"
    echo "----------------------------------------"

    for package_type in "${PACKAGE_TYPES[@]}"; do
        nfpm package --config "$nfpm_file" -p "$package_type" -t "$output_dir"
    done

    # create tarball (use deb file as the reference)
    echo "using tarball packager..."
    DEB_FILE=$(find "$output_dir" -name "${PACKAGE_NAME}*.deb" | head -1)
    if [ -z "$DEB_FILE" ]; then
        echo "WARNING: Could not find the debian file. dir=$output_dir" >&2
    fi

    TARBALL="$(echo "${DEB_FILE%.*}.tar.gz" | sed 's/_all//g')"
    ar x "$DEB_FILE" data.tar.gz
    mv data.tar.gz "$TARBALL"
    echo "created tarball: $TARBALL"
}

# Create output folder
if [ -n "$OUTPUT_DIR" ] && [ "$OUTPUT_DIR" != "." ] && [ "$OUTPUT_DIR" != ".." ]; then
    rm -rf "$OUTPUT_DIR"
    mkdir -p "$OUTPUT_DIR"
fi

# Build packages for each init system
build ./packages/sysvinit/nfpm.yaml "$OUTPUT_DIR"
build ./packages/sysvinit-yocto/nfpm.yaml "$OUTPUT_DIR"
build ./packages/openrc/nfpm.yaml "$OUTPUT_DIR"
build ./packages/runit/nfpm.yaml "$OUTPUT_DIR"
build ./packages/s6-overlay/nfpm.yaml "$OUTPUT_DIR"
build ./packages/supervisord/nfpm.yaml "$OUTPUT_DIR"
