#!/bin/sh
set -e

TMPDIR=/tmp/tedge-services
LOGFILE=/tmp/tedge-services/install.log
PACKAGE_REPO="community"
INIT_SYSTEM="${INIT_SYSTEM:-}"

SUPPORTED_TYPES="openrc,s6_overlay,supervisord,sysvinit,sysvinit-yocto"

# Set shell used by the script (can be overwritten during dry run mode)
sh_c='sh -c'

usage() {
    cat <<EOF
Install thin-edge.io service definitions on Linux distributions that don't have SystemD installed

USAGE:
    $0 [openrc|s6_overlay|supervisord|sysvinit|sysvinit-yocto] [--package-manager <apt|apk|dnf|microdnf|zypper|tarball>]

    List available init system types
    $0 --list

OPTIONS:
    -p, --package-manager string  Package manager to use to install thin-edge.io. Defaults to auto detection
                                  Available: apt, apk, dnf, microdnf, zypper, tarball
    --dry-run                     Don't install anything, just let me know what it does
    -h, --help                    Show this help

EOF
}

log() {
    echo "$@" | tee -a "$LOGFILE"
}

debug() {
    echo "$@" >> "$LOGFILE" 2>&1
}

print_debug() {
    echo
    echo "--------------- machine details ---------------------"
    echo "date:           $(date || true)"
    echo "tedge:          $VERSION"
    echo "Machine:        $(uname -a || true)"
    echo "Architecture:   $(dpkg --print-architecture 2>/dev/null || true)"
    if command_exists "lsb_release"; then
        DISTRIBUTION=$(lsb_release -a 2>/dev/null | grep "Description" | cut -d: -f2- | xargs)
        echo "Distribution:   $DISTRIBUTION"
    elif [ -f /etc/os-release ]; then
        echo "os-release details:"
        head -4 /etc/os-release
    fi
    echo
    echo "--------------- error details ------------------------"

    if [ -f "$LOGFILE" ]; then
        cat "$LOGFILE"
    fi

    echo "------------------------------------------------------"
    echo
}

fail() {
    exit_code="$1"
    shift

    log "Failed to install thin-edge.io service definitions"
    echo
    log "Reason: $*"
    echo
    log "Please create a ticket using the following link and include the console output"
    log "    https://github.com/thin-edge/tedge-services/issues/new?assignees=&labels=bug&template=bug_report.md"

    exit "$exit_code"
}

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

is_dry_run() {
	if [ -z "$DRY_RUN" ]; then
		return 1
	else
		return 0
	fi
}

configure_shell() {
    # Check if has sudo rights or if it can be requested
    user="$(id -un 2>/dev/null || true)"
    sh_c='sh -c'
    if [ "$user" != 'root' ]; then
        if command_exists sudo; then
            sh_c='sudo -E sh -c'
        elif command_exists su; then
            sh_c='su -c'
        else
            cat >&2 <<-EOF
Error: this installer needs the ability to run commands as root.
We are unable to find either "sudo" or "su" available to make this happen.
EOF
            exit 1
        fi
    fi

    if is_dry_run; then
        sh_c="echo"
    fi
}

install_via_tarball() {
    #
    # Install tarballs 
    #
    name="$1"

    # Download tarball
    download_file "https://dl.cloudsmith.io/public/thinedge/${PACKAGE_REPO}/raw/names/${name}/versions/latest/${name}.tar.gz"
    DOWNLOADED_TARBALL="$TMPDIR/${name}.tar.gz"

    # Prefer gtar over tar, as gtar is guranteed to be GNU tar
    # where tar could also be bsdtar which has different options
    # and some systems only have gtar (e.g. rockylinux 9 minimal)
    tar_cmd="tar"
    if command_exists gtar; then
        tar_cmd="gtar"
    fi

    log "Expanding tar: $DOWNLOADED_TARBALL"
    $sh_c "$tar_cmd xzf '$DOWNLOADED_TARBALL' -C /"
}

download_file() {
    #
    # Download a file either using curl or wget (whatever is available)
    # The file is downloaded to the temp directory
    #
    # Usage
    #   download_file <url>
    #
    url="$1"

    echo
    printf 'Downloading %s...' "$url"

    if [ ! -d "$TMPDIR" ]; then
        mkdir -p "$TMPDIR"
    fi

    # Prefer curl over wget as docs instruct the user to download this script using curl
    if command_exists curl; then
        if ! (cd "$TMPDIR" && $sh_c "curl -1fsSLO '$url'" >> "$LOGFILE" 2>&1 ); then
            fail 2 "Could not download package from url: $url"
        fi
    elif command_exists wget; then
        if ! $sh_c "wget --quiet '$url' -P '$TMPDIR'" >> "$LOGFILE" 2>&1; then
            fail 2 "Could not download package from url: $url"
        fi
    else
        # This should not happen due to the pre-requisite check
        echo "FAILED"
        fail 1 "Could not download file because neither wget or curl is installed. Please install 'wget' or 'curl' and try again"
    fi
    if is_dry_run; then
        echo "OK (DRY-RUN)"
    else
        echo "OK"
    fi
}

is_root() {
    user="$(id -un 2>/dev/null || true)"
    [ "$user" = "root" ]
}

run_repo_setup() {
    filename="$1"

    # Use generic distribution version and codement to be compatable with different OSs
    if is_root; then
        env version=any-version codename="" bash "$filename"
    elif command_exists sudo; then
        sudo -E env version=any-version codename="" bash "$filename"
    fi
}

install_via_apk() {
    download_file "https://dl.cloudsmith.io/public/thinedge/${PACKAGE_REPO}/setup.alpine.sh"
    run_repo_setup "$TMPDIR/setup.alpine.sh"
    $sh_c "apk add --no-cache $*"
}

install_via_apt() {
    download_file "https://dl.cloudsmith.io/public/thinedge/${PACKAGE_REPO}/setup.deb.sh"
    run_repo_setup "$TMPDIR/setup.deb.sh"

    $sh_c "DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y $*"
}

install_via_dnf() {
    download_file "https://dl.cloudsmith.io/public/thinedge/${PACKAGE_REPO}/setup.rpm.sh"
    run_repo_setup "$TMPDIR/setup.rpm.sh"

    $sh_c "dnf install --best --refresh -y $*"
}

install_via_microdnf() {
    download_file "https://dl.cloudsmith.io/public/thinedge/${PACKAGE_REPO}/setup.rpm.sh"
    run_repo_setup "$TMPDIR/setup.rpm.sh"

    $sh_c "microdnf install --best --refresh -y $*"
}

install_via_zypper() {
    download_file "https://dl.cloudsmith.io/public/thinedge/${PACKAGE_REPO}/setup.rpm.sh"
    run_repo_setup "$TMPDIR/setup.rpm.sh"

    $sh_c "zypper install -y $*"
}

get_package_manager() {
    package_manager=
    if command_exists apt-get; then
        package_manager="apt"
    elif command_exists apk; then
        package_manager="apk"
    elif command_exists dnf; then
        package_manager="dnf"
    elif command_exists microdnf; then
        package_manager="microdnf"
    elif command_exists zypper; then
        package_manager="zypper"
    fi

    echo "$package_manager"
}

get_service_manager() {
    init_system=

    if command_exists systemctl; then
        init_system="systemd"
    elif command_exists rc-service; then
        init_system="openrc"
    elif command_exists update-rc.d; then
        init_system="sysvinit"
    elif [ -f /command/s6-rc ]; then
        init_system="s6_overlay"
    elif command_exists runsv; then
        init_system="runit"
    elif command_exists supervisorctl; then
        init_system="supervisord"
    fi
    echo "$init_system"
}

main() {
    if [ -d "$TMPDIR" ]; then
        rm -Rf "$TMPDIR"
    fi
    mkdir -p "$TMPDIR"

    configure_shell

    echo "Welcome to the thin-edge.io community!"
    echo

    # Detect package manager
    if [ -z "$PACKAGE_MANAGER" ]; then
        package_manager=$(get_package_manager)
        PACKAGE_MANAGER="$package_manager"
        if [ -z "$package_manager" ]; then
            package_manager="tarball"
        fi
    fi

    # Fallback to tarball if curl or bash is not available
    if [ "$PACKAGE_MANAGER" != "tarball" ]; then
        if command_exists bash && command_exists curl; then
            log "Package management dependencies met" >/dev/null
        else
            log "Fallback to installing from tarball as curl and bash were not found. curl and bash are required to install thin-edge.io using a package manager"
            PACKAGE_MANAGER="tarball"
        fi
    fi

    INIT_SYSTEM=
    if [ -z "$INIT_SYSTEM" ]; then
        INIT_SYSTEM=$(get_service_manager)
    fi

    if [ -z "$INIT_SYSTEM" ]; then
        fail 1 "Could not detect the init system. Please try specifying one manually ($SUPPORTED_TYPES), or adding new definitions via a Pull Request to https://github.com/thin-edge/tedge-services"
    fi

    case "$INIT_SYSTEM" in
        systemd)
            log "systemd is supported out-of-the-box so there is no need to manually install the service definitions"
            exit 0
            ;;
        sysvinit) PACKAGES="tedge-sysvinit" ;;
        sysvinit-yocto) PACKAGES="tedge-sysvinit-yocto" ;;
        openrc) PACKAGES="tedge-openrc" ;;
        runit) PACKAGES="tedge-runit" ;;
        s6_overlay) PACKAGES="tedge-s6overlay" ;;
        supervisord) PACKAGES="tedge-supervisord" ;;
        *)
            log "Unsupported argument init system."
            exit 1
            ;;
    esac

    log "Detected init system: $INIT_SYSTEM"

    log "Detected package manager: $PACKAGE_MANAGER"

    case "$PACKAGE_MANAGER" in
        tarball)
            # shellcheck disable=SC2086
            install_via_tarball $PACKAGES
            ;;
        apk)
            install_via_apk $PACKAGES
            ;;
        apt)
            install_via_apt $PACKAGES
            ;;
        dnf)
            install_via_dnf $PACKAGES
            ;;
        microdnf)
            install_via_microdnf $PACKAGES
            ;;
        zypper)
            install_via_zypper $PACKAGES
            ;;
        *)
            # Should only happen if there is a bug in the script
            fail 1 "Unknown package manager: $PACKAGE_MANAGER"
            ;;
    esac

    if is_dry_run; then
        echo
        echo "Dry run complete"
    # Test if tedge command is there and working
    else
        # remove error handler
        trap - EXIT

        # Only delete when everything was ok to help with debugging
        rm -Rf "$TMPDIR"

        echo
        echo "The $INIT_SYSTEM service definitions for thin-edge.io have been installed on your system!"
        echo
        echo "You can manage the services via the tedgectl utility"
        echo
        echo "Enable a service"
        echo "  tedgectl enable mosquitto"
        echo
        echo "Start a service"
        echo "  tedgectl start mosquitto"
        echo
        echo "Stop a service"
        echo "  tedgectl stop mosquitto"
        echo
        echo "You can go to our documentation to find next steps: https://thin-edge.github.io/thin-edge.io/start/getting-started"
    fi
}


# Support reading setting from environment variables
DRY_RUN=${DRY_RUN:-}
VERSION=${VERSION:-}
PACKAGE_MANAGER="${PACKAGE_MANAGER:-}"

while [ $# -gt 0 ]; do
    case $1 in
        # Allow user to specify which packages manager they would like
        # e.g. they might opt for the 'tarball' option even if they are on debian
        --package-manager|-p)
            PACKAGE_MANAGER="$2"
            shift
            ;;
        --list)
            echo "Available service definitions:"
            echo
            echo "  $SUPPORTED_TYPES"
            echo
            exit 0
            ;;
        --dry-run)
            DRY_RUN=1
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        --*|-*)
            log "Unknown option: $1"
            usage
            exit 1
            ;;
        *)
            INIT_SYSTEM="$1"
            ;;
    esac
    shift $(( $# > 0 ? 1 : 0 ))
done

# Enable print of info if something unexpected happens
trap print_debug EXIT

# wrapped up in a function so that we have some protection against only getting
# half the file during "curl | sh"
main
