include ../setup.mk

HOST = $(notdir $(CURDIR))
IMAGE_TAG = dev-$(HOST)
CONTAINER_NAME = dev-$(HOST)
FQDN = $(HOST).$(DOMAIN)

BUILD_ARGS = --tag $(IMAGE_TAG) 
BUILD_ARGS += --build-arg REGULAR_USER=$(REGULAR_USER) 
BUILD_ARGS += --build-arg DOMAIN=$(DOMAIN)
BUILD_ARGS += --build-arg HOSTNAME=$(HOST)
BUILD_ARGS += --build-arg TZ=$(TZ)

RUN_ARGS = --detach
RUN_ARGS += --name $(CONTAINER_NAME)
RUN_ARGS += --hostname $(FQDN)
RUN_ARGS += --network $(NETWORK)
RUN_ARGS += --publish $(PORT_GITLAB_SSH):22
RUN_ARGS += --publish $(PORT_GITLAB_HTTP):80
RUN_ARGS += --publish $(PORT_GITLAB_HTTPS):443
RUN_ARGS += --volume $(CURDIR)/config:/etc/gitlab:z
RUN_ARGS += --volume $(CURDIR)/logs:/var/log/gitlab:z
RUN_ARGS += --volume $(CURDIR)/data:/var/opt/gitlab:z
RUN_ARGS += --shm-size 256m

IMAGE_ID := $(shell [ -e image.id ] && cat image.id)

.PHONY : clean log flog clear-known

container.id : image.id ../net.id
	for d in config logs data; do if [ ! -e $$d ]; then mkdir $$d ; fi; done
	$(DOCKER) run $(RUN_ARGS) $(IMAGE_TAG) > $@ || rm -f $@

image.id : Dockerfile
	$(DOCKER) build $(BUILD_ARGS) .
	$(DOCKER) image ls $(IMAGE_TAG) | sed 1d | awk '{ print $$3 }' > $@

log : container.id
	$(DOCKER) container logs $(CONTAINER_NAME)

flog : container.id
	$(DOCKER) container logs --follow $(CONTAINER_NAME)

ssh : clear-known
	ssh -o StrictHostKeyChecking=accept-new $(REGULAR_USER)@$(shell $(DOCKER) network inspect dev | jq -r '.[0].Containers | .[] | select(.Name == "$(CONTAINER_NAME)") | .IPv4Address' | sed 's|/.*||')

clear-known :
	-sed -i '/$(shell $(DOCKER) network inspect dev | jq -r '.[0].Containers | .[] | select(.Name == "$(CONTAINER_NAME)") | .IPv4Address' | sed 's|/.*||')/d' ~/.ssh/known_hosts

clean : 
	if [ -e container.id ]; then $(DOCKER) container kill $(CONTAINER_NAME) ; $(DOCKER) container rm $(CONTAINER_NAME) ; rm -f container.id ; fi
	if [ -e image.id ]; then $(DOCKER) image rm $(IMAGE_ID) ; rm -f image.id ; fi
