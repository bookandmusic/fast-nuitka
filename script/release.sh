#!/bin/bash

platform=$1
image_name=$2
tmp_name=$(echo ${image_name} | tr ':' '-')-release
output_file=$(echo ${image_name} | tr ':' '-')-release.tar.gz

# 获取当前脚本的绝对路径
script_path=$(realpath "$0")
# 提取项目路径（脚本路径的上一级）
project_path=$(dirname "$(dirname "$script_path")")

mkdir -p ${project_path}/release

# 创建临时容器
docker create --name ${tmp_name} --platform linux/${platform} ${image_name}

# 复制编译后的文件
rm -rf ${tmp_name} && docker cp ${tmp_name}:/app ${tmp_name}

# 移除临时容器
docker rm -f ${tmp_name}

# 压缩编译后的文件
tar -czvf ${project_path}/release/${output_file} ${tmp_name}

# 清理
rm -rf ${tmp_name}
