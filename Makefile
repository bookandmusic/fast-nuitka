# Makefile

# 获取短的 Git SHA
short_sha := $(shell git rev-parse --short=8 HEAD)
image_name := fastapi-nuitka

# 检查镜像是否存在的通用函数
define check_image_exists
	docker images --format '{{.Repository}}:{{.Tag}}' | grep -q "^$(1):$(2)$$"
endef

# 初始化标志文件路径
INIT_FLAG := .init_done

# 默认为不使用代理
USE_PROXY ?= false

# 初始化构建环境
.PHONY: init
init: $(INIT_FLAG)

$(INIT_FLAG):
	@# 检查并安装 QEMU 二进制格式支持
	@if [ ! -e /proc/sys/fs/binfmt_misc/qemu-arm ] || [ ! -e /proc/sys/fs/binfmt_misc/qemu-aarch64 ]; then \
		docker run --rm --privileged tonistiigi/binfmt --install all; \
		docker run --rm --privileged multiarch/qemu-user-static --reset -p yes; \
	fi
	
	@# 检查并创建 buildx builder
	@if ! docker buildx inspect multi-builder > /dev/null 2>&1; then \
		docker buildx create --name multi-builder --use; \
	fi
	@# 检查 buildx builder 是否已启动
	@docker buildx inspect multi-builder --bootstrap

# 构建目标
.PHONY: build
build: build-amd build-arm

# 构建 AMD64 目标
.PHONY: build-amd
build-amd: init
	/bin/bash ./script/build.sh amd64 ${image_name}-amd64:${short_sha} multi-builder $(USE_PROXY)

# 构建 ARM64 目标
.PHONY: build-arm
build-arm: init
	/bin/bash ./script/build.sh arm64 ${image_name}-arm64:${short_sha} multi-builder $(USE_PROXY)

.PHONY: build
build-multi: build-amd build-arm

# 发布目标
.PHONY: release-amd
release-amd: build-amd
	/bin/bash ./script/release.sh amd64 ${image_name}-amd64:${short_sha}

.PHONY: release-arm
release-arm: build-arm
	/bin/bash ./script/release.sh arm64 ${image_name}-arm64:${short_sha}

# 发布目标
.PHONY: release
release: release-amd release-arm

# 打印 Git SHA
.PHONY: print-sha
print-sha:
	@echo $(short_sha)
