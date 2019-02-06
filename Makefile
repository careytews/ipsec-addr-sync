
VERSION=$(shell git describe | sed 's/^v//')

CONTAINER=gcr.io/trust-networks/ipsec-addr-sync:${VERSION}

all: 
	docker build ${BUILD_ARGS} -t ${CONTAINER} -f Dockerfile  .

push:
	gcloud docker -- push ${CONTAINER}

# Continuous deployment support
# addr-alloc is referenced in the vpn-service
BRANCH=master
PREFIX=resources/ipsec-service
FILE=${PREFIX}/ksonnet/ipsec-addr-sync-version.jsonnet
REPO=git@github.com:trustnetworks/vpn-service

tools: phony
	if [ ! -d tools ]; then \
		git clone git@github.com:trustnetworks/cd-tools tools; \
	fi; \
	(cd tools; git pull)

phony:

bump-version: tools
	tools/bump-version

update-cluster-config: tools
	tools/update-version-config ${BRANCH} ${VERSION} ${FILE}


