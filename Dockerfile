# 使用官方Python镜像作为基础镜像
FROM python:3.9-slim-bullseye AS builder

# 设置工作目录
WORKDIR /app

# 安装必要的系统依赖
RUN sed -i s@/deb.debian.org/@/mirrors.tuna.tsinghua.edu.cn/@g /etc/apt/sources.list && \ 
    apt-get update && apt-get install -y gcc g++ patchelf

# 安装Poetry和Nuitka
RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple --no-cache-dir poetry nuitka

# 复制Poetry配置文件
COPY pyproject.toml poetry.lock ./

# 安装项目依赖
RUN poetry config virtualenvs.create false && poetry install --no-interaction --no-ansi

# 复制项目所有文件到容器中
COPY src/ .

# 编译项目为二进制文件
RUN python -m nuitka --follow-imports --standalone --include-package=gunicorn --include-package=uvicorn --output-dir=dist --output-filename=server run.py

# 复制到一个目录中
RUN mkdir -p /app/build && mv /app/dist/run.dist/* /app/build && mv /app/templates /app/build && mv /app/static /app/build

# 使用一个更小的基础镜像来运行二进制文件
FROM debian:bullseye-slim

# 复制编译后的二进制文件到新的基础镜像
COPY --from=builder /app/build /app

# 设置工作目录
WORKDIR /app

# 暴露端口8000
EXPOSE 8000

# 运行二进制文件
CMD ["./server"]
