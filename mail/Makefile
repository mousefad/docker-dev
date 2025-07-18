include ../setup.mk

IMAGE_TAG = dev-mail
CONTAINER_NAME = dev-mail
HOST_NAME = mail.$(DEV_DOMAIN)
IMAGE_ID := $(shell [ -e image.id ] && cat image.id)
RUN_ARGS = --detach
RUN_ARGS += --name $(CONTAINER_NAME)
RUN_ARGS += --hostname $(HOST_NAME)
RUN_ARGS += --network $(NETWORK_NAME)

.PHONY : clean log flog ssh

container.id : image.id ../net.id
	docker run $(RUN_ARGS) $(IMAGE_TAG) > $@ || rm -f $@

image.id : Dockerfile ssh_key.pub
	docker build --tag $(IMAGE_TAG) .
	docker image ls $(IMAGE_TAG) | sed 1d | awk '{ print $$3 }' > $@

ssh_key.pub : 
	cp $(SSH_PUB_KEY) $@

log : container.id
	docker container logs $(CONTAINER_NAME)

flog : container.id
	docker container logs --follow $(CONTAINER_NAME)

ssh :
	ssh mng@$(shell docker network inspect dev | jq '.[0].Containers.[].Name, .[0].Containers.[].IPv4Address' | tr -d '"' | perl -npe 'if (%. % 2 == 0) { chomp; $$_ .= " " }' | awk -F '[ /]' '/dev-mail / { print $$2 }')

clean : 
	if [ -e container.id ]; then docker container kill $(CONTAINER_NAME) ; docker container rm $(CONTAINER_NAME) ; rm -f container.id ; fi
	if [ -e image.id ]; then docker image rm $(IMAGE_ID) ; rm -f image.id ; fi
	rm -f ssh_key.pub
