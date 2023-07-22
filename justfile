
generate:
    ./services/generate.sh

build:
    rm -rf output
    mkdir -p output
    just build-openrc
    just build-sysvinit

build-openrc:
    nfpm package --config ./packages/openrc/nfpm.yaml -p apk -t ./output/
    nfpm package --config ./packages/openrc/nfpm.yaml -p rpm -t ./output/
    nfpm package --config ./packages/openrc/nfpm.yaml -p deb -t ./output/

build-sysvinit:
    rm -rf output
    mkdir -p output
    nfpm package --config ./packages/sysvinit/nfpm.yaml -p apk -t ./output/
    nfpm package --config ./packages/sysvinit/nfpm.yaml -p rpm -t ./output/
    nfpm package --config ./packages/sysvinit/nfpm.yaml -p deb -t ./output/
