include setup.mk

SUBDOMAINS = mail fossil gitlab

CONTAINER_FLAGS = $(addprefix container.,$(SUBDOMAINS))
IMAGE_FLAGS = $(addprefix image.,$(SUBDOMAINS)) base.image


.PHONY : all images

.PRECIOUS : $(IMAGE_FLAGS)

all : $(CONTAINER_FLAGS)
	$(DOCKER) container ls

images : $(IMAGE_FILES)

container.% : image.% net.id
	make -C $(subst container.,,$@) container.id
	cp $(subst container.,,$@)/container.id $@

base.image :
	make -C base image.id
	cp base/image.id $@

image.% : base.image
	make -C $(subst image.,,$@) image.id
	cp $(subst image.,,$@)/image.id $@

net.id : Makefile
	if $(DOCKER) network ls | grep -E "^[0-9a-f]+ +$(NETWORK) " > $@; then sed -i 's/ .*//' $@; echo network already exists ; else $(DOCKER) network create $(NETWORK) > $@ ; fi

clean : 
	for d in $(SUBDOMAINS) base; do make -C $$d clean; done
	if [ -e net.id ]; then $(DOCKER) network rm $(shell cat net.id); fi
	rm -f net.id $(CONTAINER_FLAGS) $(IMAGE_FLAGS) base.image
