include ../setup.mk

IMAGE_TAG = dev-fossil
CONTAINER_NAME = dev-fossil
HOST_NAME = fossil.$(DEV_DOMAIN)
IMAGE_ID := $(shell [ -e image.id ] && cat image.id)
RUN_ARGS = --detach
RUN_ARGS += --name $(CONTAINER_NAME)
RUN_ARGS += --hostname $(HOST_NAME)
RUN_ARGS += --network $(NETWORK_NAME)
RUN_ARGS += --publish $(PORT_HTTP_FOSSIL):8080
RUN_ARGS += --volume $(CURDIR)/repos:/var/fossil:Z

.PHONY : clean log flog ssh

container.id : image.id ../net.id
	docker run $(RUN_ARGS) $(IMAGE_TAG) > $@ || rm -f $@

image.id : Dockerfile
	docker build --tag $(IMAGE_TAG) .
	docker image ls $(IMAGE_TAG) | sed 1d | awk '{ print $$3 }' > $@

log : container.id
	docker container logs $(CONTAINER_NAME)

flog : container.id
	docker container logs --follow $(CONTAINER_NAME)

clean : 
	if [ -e container.id ]; then docker container kill $(CONTAINER_NAME) ; docker container rm $(CONTAINER_NAME) ; rm -f container.id ; fi
	if [ -e image.id ]; then docker image rm $(IMAGE_ID) ; rm -f image.id ; fi
