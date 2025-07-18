include ../setup.mk

HOST = $(notdir $(CURDIR))
IMAGE_TAG = dev-$(HOST)
CONTAINER_NAME = dev-$(HOST)
FQDN = $(HOST).$(DOMAIN)

BUILD_ARGS = --tag $(IMAGE_TAG) 
BUILD_ARGS += --build-arg REGULAR_USER=$(REGULAR_USER) 
BUILD_ARGS += --build-arg DOMAIN=$(DOMAIN)
BUILD_ARGS += --build-arg HOSTNAME=$(HOST)
BUILD_ARGS += --build-arg SUBNET=$(shell docker network inspect $(NETWORK) | jq -r '.[0].IPAM.Config[0].Subnet')

RUN_ARGS = --detach
RUN_ARGS += --name $(CONTAINER_NAME)
RUN_ARGS += --hostname $(FQDN)
RUN_ARGS += --network $(NETWORK)

IMAGE_ID := $(shell [ -e image.id ] && cat image.id)

.PHONY : clean log flog ssh clear-known

container.id : image.id ../net.id
	$(DOCKER) run $(RUN_ARGS) $(IMAGE_TAG) > $@ || rm -f $@

image.id : Dockerfile
	$(DOCKER) build $(BUILD_ARGS) .
	$(DOCKER) image ls $(IMAGE_TAG) | sed 1d | awk '{ print $$3 }' > $@

log : container.id
	$(DOCKER) container logs $(CONTAINER_NAME)

flog : container.id
	$(DOCKER) container logs --follow $(CONTAINER_NAME)

ssh : clear-known container.id
	ssh -o StrictHostKeyChecking=accept-new $(REGULAR_USER)@$(shell $(DOCKER) network inspect dev | jq -r '.[0].Containers | .[] | select(.Name == "$(CONTAINER_NAME)") | .IPv4Address' | sed 's|/.*||')

clear-known :
	-sed -i '/$(shell $(DOCKER) network inspect dev | jq -r '.[0].Containers | .[] | select(.Name == "$(CONTAINER_NAME)") | .IPv4Address' | sed 's|/.*||')/d' ~/.ssh/known_hosts

clean : 
	-$(DOCKER) container kill $(CONTAINER_NAME)
	-$(DOCKER) container rm $(CONTAINER_NAME) 
	if [ -e image.id ]; then $(DOCKER) image rm $(IMAGE_ID) ; fi
	rm -f container.id image.id
