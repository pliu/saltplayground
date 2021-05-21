SALT_PLAYGROUND_IMAGE_NAME=saltplayground

.PHONY: basic_build
basic_build:
	docker build -t $(SALT_PLAYGROUND_IMAGE_NAME) ./environments/basic

.PHONY: basic_create
basic_create: basic_build basic_destroy
	docker run --name $(SALT_PLAYGROUND_IMAGE_NAME) -v `pwd`/environments/basic/salt:/srv/salt -v `pwd`/environments/basic/pillar:/srv/pillar \
	-v `pwd`/environments/basic/config/minion:/etc/salt/minion -d $(SALT_PLAYGROUND_IMAGE_NAME)

.PHONY: basic_destroy
basic_destroy:
	docker rm $(SALT_PLAYGROUND_IMAGE_NAME) -f

.PHONY: k8s_build
k8s_build:
	docker build -t k8s_base ./environments/kubernetes

.PHONY: k8s_etcd_create
k8s_etcd_create: k8s_build k8s_etcd_destroy
	docker-compose -f environments/kubernetes/docker-compose.yml up -d

.PHONY: k8s_etcd_destroy
k8s_etcd_destroy:
	docker-compose -f environments/kubernetes/docker-compose.yml down

.PHONY: k8s_master_add
k8s_master_add:
	echo 1

.PHONY: k8s_master_destroy
k8s_master_destroy:
	echo 1

.PHONY: k8s_worker_add
k8s_worker_add:
	echo 1

.PHONY: k8s_worker_destroy
k8s_worker_destroy:
	echo 1
