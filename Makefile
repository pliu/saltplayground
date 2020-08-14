SALT_PLAYGROUND_IMAGE_NAME=saltplayground

.PHONY: build
build:
	docker build -t $(SALT_PLAYGROUND_IMAGE_NAME) .

.PHONY: run
run: build
	docker run --name $(SALT_PLAYGROUND_IMAGE_NAME) --mount type=bind,source=`pwd`/salt,target=/srv/salt \
	--mount type=bind,source=`pwd`/pillar,target=/srv/pillar -d $(SALT_PLAYGROUND_IMAGE_NAME)

.PHONY: stop
stop:
	docker rm $(SALT_PLAYGROUND_IMAGE_NAME) -f
