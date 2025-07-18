include ../setup.mk

HOST = $(notdir $(CURDIR))
IMAGE_TAG = dev-$(HOST)

BUILD_ARGS = --tag $(IMAGE_TAG) 
BUILD_ARGS += --build-arg REGULAR_USER=$(REGULAR_USER) 
BUILD_ARGS += --build-arg TZ=$(TZ) 

IMAGE_ID := $(shell [ -e image.id ] && cat image.id)

.PHONY : clean

image.id : Dockerfile ssh/authorized_keys
	$(DOCKER) build $(BUILD_ARGS) .
	$(DOCKER) image ls $(IMAGE_TAG) | sed 1d | awk '{ print $$3 }' > $@

ssh/authorized_keys : 
	if [ ! -e ssh ]; then mkdir ssh; fi
	cp $(SSH_PUB_KEY) $@

clean : 
	if [ -e image.id ]; then $(DOCKER) image rm $(IMAGE_ID) ; rm -f image.id ; fi
	rm -f ssh/*
	rmdir ssh
