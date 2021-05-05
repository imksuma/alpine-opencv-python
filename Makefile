export CI_REGISTRY        ?= registry.bukalapak.io


IMAGE           = $(CI_REGISTRY)/bukalapak/coreai/image/alpine-opencv-python
OPENCV_VERSION  ?= 3.4.7
PY_VERSION      ?= 3.7
TAG             ?= py$(PY_VERSION)-$(OPENCV_VERSION)

all: build-base build push deploy

build-base:
	docker build --build-arg OPENCV_VERSION=$(OPENCV_VERSION) \
	-t $(IMAGE)-devel:$(TAG) -f Dockerfile_base .

push-base: build-base
	docker push $(IMAGE)-devel:$(TAG)

build:
	docker build --build-arg DEVEL_IMAGE=$(IMAGE)-devel:$(TAG) \
	-t $(IMAGE):$(TAG) -f Dockerfile .

push: build
	docker push $(IMAGE):$(TAG)