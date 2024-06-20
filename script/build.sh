#!/bin/bash
# 检查是否传递了平台参数
platform=$1
image_name=$2
out_image_file=$(echo ${image_name} | tr ':' '-')-image.tar
# 设置 buildx builder 名称
builder_name=$3
use_proxy=${4:-false}  # 第四个参数，默认值为 false

# 获取当前脚本的绝对路径
script_path=$(realpath "$0")
# 提取项目路径（脚本路径的上一级）
project_path=$(dirname "$(dirname "$script_path")")

# 检查镜像是否存在
image_exists=$(docker images -q ${image_name})

if [ -z "$image_exists" ]; then
  echo "Image does not exist, building image..."

  # 确保 Dockerfile 存在
  if [ ! -f "${project_path}/Dockerfile" ]; then
    echo "Dockerfile not found in project path: ${project_path}"
    exit 1
  fi
  # 构建 Docker 镜像
  docker buildx build --builder $builder_name --platform linux/${platform} --build-arg USE_PROXY=${use_proxy} -t ${image_name} --load ${project_path} -f ${project_path}/Dockerfile

  # 检查构建是否成功
  if [ $? -ne 0 ]; then
    echo "Docker image build failed"
    exit 1
  fi
else
  echo "Image already exists: ${image_name}"
fi

# 检查 tar 文件是否存在
if [ -f "${project_path}/release/${out_image_file}" ]; then
  echo "Image tar file already exists: ${project_path}/release/${out_image_file}"
  exit 0
fi

# 创建发布目录
mkdir -p ${project_path}/release

# 保存镜像到 tar 文件
docker save ${image_name} -o ${project_path}/release/${out_image_file}

# 检查保存是否成功
if [ $? -ne 0 ]; then
  echo "Docker image save failed"
  exit 1
fi

echo "Docker image for platform ${platform} built and saved successfully."
