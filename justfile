
generate:
    ./services/generate.sh

build: generate
    rm -rf output
    mkdir -p output
    just build-openrc
    just build-sysvinit
    just build-s6-overlay

build-openrc:
    nfpm package --config ./packages/openrc/nfpm.yaml -p apk -t ./output/
    nfpm package --config ./packages/openrc/nfpm.yaml -p rpm -t ./output/
    nfpm package --config ./packages/openrc/nfpm.yaml -p deb -t ./output/

build-sysvinit:
    nfpm package --config ./packages/sysvinit/nfpm.yaml -p apk -t ./output/
    nfpm package --config ./packages/sysvinit/nfpm.yaml -p rpm -t ./output/
    nfpm package --config ./packages/sysvinit/nfpm.yaml -p deb -t ./output/

build-s6-overlay:
    nfpm package --config ./packages/s6-overlay/nfpm.yaml -p apk -t ./output/
    nfpm package --config ./packages/s6-overlay/nfpm.yaml -p rpm -t ./output/
    nfpm package --config ./packages/s6-overlay/nfpm.yaml -p deb -t ./output/

start:
    docker compose up --build -d

shell-sysvinit:
    docker compose exec tedge-sysvinit bash

shell-openrc:
    docker compose exec tedge-openrc ash

shell-s6-overlay:
    docker compose exec tedge-s6-overlay bash

stop:
    docker compose down
