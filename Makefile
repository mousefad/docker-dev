include setup.mk

SUBDOMAINS = mail fossil
CONTAINER_FLAGS = $(addprefix container.,$(SUBDOMAINS))
IMAGE_FLAGS = $(addprefix image.,$(SUBDOMAINS))


.PHONY : all images

all : $(CONTAINER_FLAGS)

images : $(IMAGE_FILES)

container.% : image.% net.id
	make -C $(subst container.,,$@) container.id
	cp $(subst container.,,$@)/container.id $@

image.% :
	make -C $(subst image.,,$@) image.id
	cp $(subst image.,,$@)/image.id $@

net.id : Makefile
	if docker network ls | grep -E "^[0-9a-f]+ +$(NETWORK) " > $@; then sed -i 's/ .*//' $@; echo network already exists ; else docker network create $(NETWORK) > $@ ; fi

clean : 
	for d in $(SUBDOMAINS); do make -C $$d clean; done
	if [ -e net.id ]; then docker network rm $(shell cat net.id); fi
	rm -f net.id $(CONTAINER_FLAGS) $(IMAGE_FLAGS)
