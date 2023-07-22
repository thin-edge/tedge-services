
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
    nfpm package --config ./packages/sysvinit/nfpm.yaml -p apk -t ./output/
    nfpm package --config ./packages/sysvinit/nfpm.yaml -p rpm -t ./output/
    nfpm package --config ./packages/sysvinit/nfpm.yaml -p deb -t ./output/

up:
    docker compose up --build
