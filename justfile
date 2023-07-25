set dotenv-load

package_dir := "dist"

# Generate service files from templates
generate:
    ./services/generate.sh

# Build packages
build: generate
    ./ci/build.sh --output "{{package_dir}}"

# Publish packages
publish *args="":
    ./ci/publish.sh --path "{{package_dir}}" {{args}}

# Start docker compose test image
start:
    docker compose up --build -d

# Open shell to sysvinit container
shell-sysvinit:
    docker compose exec tedge-sysvinit bash

# Open shell to openrc container
shell-openrc:
    docker compose exec tedge-openrc ash

# Open shell to s6-overlay container
shell-s6-overlay:
    docker compose exec tedge-s6-overlay ash

# Open shell to runit container
shell-runit:
    docker compose exec tedge-runit ash

# Stop docker compose test image
stop:
    docker compose down
