DEPS_MIKROTIK_VERSION=7.20.7 7.21.2 7.20.8

VRNETLAB_DIR=vrnetlab
VRNETLAB_URL=https://github.com/srl-labs/vrnetlab.git

APT_DEPS=unzip vim curl traceroute dnsutils

sudo-nopass:
	sudo sed '/^%sudo/s/ ALL$/ NOPASSWD:ALL/' /etc/sudoers -i

install-ubuntu-deps:
	sudo apt update
	sudo apt install -y ${APT_DEPS}

add-groups:
	sudo usermod -ag docker $$USER

install-clab: install-ubuntu-deps
	curl -sL https://containerlab.dev/setup | sudo -E bash -s "all"
	make add-groups


get-vrnetlab:
	@if [ ! -d "$(VRNETLAB_DIR)" ]; then \
		git clone $(VRNETLAB_URL) $(VRNETLAB_DIR); \
	else \
		echo "$(VRNETLAB_DIR) already exists, skipping clone"; \
		( cd $(VRNETLAB_DIR) && git pull ); \
	fi

build-mikrotik:
	for v in $(DEPS_MIKROTIK_VERSION); do \
		curl -L -o - https://download.mikrotik.com/routeros/$${v}/chr-$${v}.vmdk.zip | \
			funzip > $(VRNETLAB_DIR)/mikrotik/routeros/chr-$${v}.vmdk; \
		done
	cd $(VRNETLAB_DIR)/mikrotik/routeros && \
		make docker-image

build: get-vrnetlab build-mikrotik

update: install-ubuntu-deps build
