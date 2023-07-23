
generate:
    ./services/generate.sh

build:
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

stop:
    docker compose down
