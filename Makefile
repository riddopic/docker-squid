# encoding: UTF-8
#
# Author:		Stefano Harding <riddopic@gmail.com>
# License:	 Apache License, Version 2.0
# Copyright: (C) 2014-2015 Stefano Harding
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#		 http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

.PHONY: help all build tag push shell run start stop rm release clean

REPO		?= riddopic
NAME		?= squid
VERSION ?= 3.5.4

help:
	@echo "\n\033[0;35mContainer management for:\033[0m\n" \
				" Repository:   [\033[0;33m$(REPO)\033[0m]\n" \
				" Name:         [\033[0;33m$(NAME)\033[0m]\n" \
				" Version:      [\033[0;33m$(VERSION)\033[0m]\n"
	@echo "\033[0;35mUsage:\033[0m"
	@echo
	@echo '  make build    Build a container from the Dockerfile.'
	@echo '  make tag      Tag an image into a repository.'
	@echo '  make push     Push image to the registry.'
	@echo '  make shell    Run container in the foreground with a shell.'
	@echo '  make run      Run the container and attach the console (foreground).'
	@echo '  make start    Start the container in the background (detached).'
	@echo '  make stop     Gracefully stop a running container.'
	@echo '  make rm       Remove the container.'
	@echo '  make release  Create tag, build and push an image to the registry.'
	@echo '  make clean    Remove untagged images.'
	@echo

all: build

build:
	@echo "\n\033[0;35mBuilding $(NAME) container from Dockerfile:\033[0m\n" \
        " Repository:   [\033[0;33m$(REPO)\033[0m]\n" \
				" Name:         [\033[0;33m$(NAME)\033[0m]\n" \
				" Version:      [\033[0;33m$(VERSION)\033[0m]\n"
	docker build -t $(REPO)/$(NAME):$(VERSION) --rm .

test:
	./test.sh

tag: test
	docker tag -f $(REPO)/$(NAME):$(VERSION) $(REPO)/$(NAME):latest

push: test tag
	docker push $(REPO)/$(NAME):$(VERSION)

shell:
	docker run --name $(NAME) --net host --privileged --rm -it \
			$(REPO)/$(NAME):$(VERSION) /bin/ash

run:
	docker run --name $(NAME) --net host --privileged --rm \
			$(REPO)/$(NAME):$(VERSION)

start:
	docker run --name $(NAME) --net host --privileged -d \
			$(REPO)/$(NAME):$(VERSION)

stop:
	docker stop $(NAME)

rm:
	docker rm $(NAME)

release: build test tag
	make push -e version=$(VERSION)

clean:
	docker rmi -f $$(docker images -q --filter 'dangling=true')
	docker rmi -f $(REPO)/$(NAME):$(VERSION)
	docker rmi -f $(REPO)/$(NAME):latest

