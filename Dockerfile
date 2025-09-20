# Docker Hubで利用可能なx86_64版のUbuntu 16.04イメージを指定
FROM --platform=linux/amd64 ubuntu:16.04

# 環境変数を設定し、対話的なプロンプトを無効化
ENV DEBIAN_FRONTEND=noninteractive

# タイムゾーン設定とシステムのアップデート、必要なライブラリのインストール
# mpi4py, VizDoom, Gitなどに必要なものをインストールします
RUN apt-get update && apt-get install -y \
    software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa && apt-get update \
    && apt-get install -y \
    python3.5 \
    python3.5-dev \
    python3-pip \
    git \
    cmake \
    libopenmpi-dev \
    zlib1g-dev \
    libjpeg-dev \
    libboost-all-dev \
    libsdl2-dev \
    libfreetype6-dev \
    libsm-dev \
    libxext-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libpng-dev \
    libbz2-dev \
    libfluidsynth-dev \
    libgme-dev \
    libopenal-dev \
    timidity \
    tar \
    build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 古いpipを更新し、uvをインストール
RUN python3.5 -m pip install --upgrade pip
RUN python3.5 -m pip install uv

# 作業ディレクトリを作成
WORKDIR /app

# 次に作成する requirements.txt をコンテナ内にコピー
COPY requirements.txt .

# uvを使ってrequirements.txtに記載されたライブラリをインストール
RUN uv pip install --system --no-cache -r requirements.txt

# VizDoom Gymをインストール
RUN uv pip install --system --no-cache "git+https://github.com/ppaquette/gym-doom.git@60ff576"

# Jupyter Notebookのためにポート8888を開放
EXPOSE 8888

# コンテナ起動時のデフォルトコマンド
CMD ["/bin/bash"]