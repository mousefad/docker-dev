include ../setup.mk

HOST = $(notdir $(CURDIR))
IMAGE_TAG = dev-$(HOST)
CONTAINER_NAME = dev-$(HOST)
FQDN = $(HOST).$(DOMAIN)

BUILD_ARGS = --tag $(IMAGE_TAG) 
BUILD_ARGS += --build-arg MAIL_USER=$(MAIL_USER) 
BUILD_ARGS += --build-arg TZ=$(TZ) 
BUILD_ARGS += --build-arg DOMAIN=$(DOMAIN)
BUILD_ARGS += --build-arg HOSTNAME=$(HOST)

RUN_ARGS = --detach
RUN_ARGS += --name $(CONTAINER_NAME)
RUN_ARGS += --hostname $(FQDN)
RUN_ARGS += --network $(NETWORK)

IMAGE_ID := $(shell [ -e image.id ] && cat image.id)

.PHONY : clean log flog ssh clear-known

container.id : image.id ../net.id
	docker run $(RUN_ARGS) $(IMAGE_TAG) > $@ || rm -f $@

image.id : Dockerfile ssh/authorized_keys
	docker build $(BUILD_ARGS) .
	docker image ls $(IMAGE_TAG) | sed 1d | awk '{ print $$3 }' > $@

ssh/authorized_keys : 
	cp $(SSH_PUB_KEY) $@

log : container.id
	docker container logs $(CONTAINER_NAME)

flog : container.id
	docker container logs --follow $(CONTAINER_NAME)

ssh : clear-known
	ssh -o StrictHostKeyChecking=accept-new $(MAIL_USER)@$(shell docker network inspect dev | jq -r '.[0].Containers | .[] | select(.Name == "dev-mail") | .IPv4Address' | sed 's|/.*||')

clear-known :
	-sed -i '/$(shell docker network inspect dev | jq -r '.[0].Containers | .[] | select(.Name == "dev-mail") | .IPv4Address' | sed 's|/.*||')/d' ~/.ssh/known_hosts

clean : 
	if [ -e container.id ]; then docker container kill $(CONTAINER_NAME) ; docker container rm $(CONTAINER_NAME) ; rm -f container.id ; fi
	if [ -e image.id ]; then docker image rm $(IMAGE_ID) ; rm -f image.id ; fi
	rm -f ssh/authorized_keys
