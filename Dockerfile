# 基本イメージ
FROM nvidia/cuda:12.0.0-cudnn8-runtime-ubuntu22.04

# 環境変数の設定
ENV LANG C.UTF-8

# 必要なパッケージのインストール
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    git \
    ca-certificates \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3-dev \
    python3-pip \
    python3-setuptools \
    zsh \
    && rm -rf /var/lib/apt/lists/*

# Preztoのインストール
RUN zsh -c "\
    git clone --recursive https://github.com/sorin-ionescu/prezto.git '${ZDOTDIR:-$HOME}/.zprezto'; \
    setopt EXTENDED_GLOB; \
    for rcfile in '${ZDOTDIR:-$HOME}'/.zprezto/runcoms/^README.md(.N); do \
    ln -s \"\$rcfile\" \"${ZDOTDIR:-$HOME}/.\${rcfile:t}\"; \
    done; \
"
# .zpreztorcをコピー（もしカスタマイズした.zpreztorcがあれば）
COPY .zpreztorc /root/.zpreztorc

# Minicondaのインストール
ENV PATH=/root/miniconda3/bin:$PATH
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /root/miniconda3 && \
    rm ~/miniconda.sh

# Condaの初期化 (zshのため)
RUN conda init zsh

# environment.ymlをコンテナにコピー
COPY environment.yml /workspace/environment.yml

# Conda環境の作成
RUN conda env create -f /workspace/environment.yml

# Conda環境を自動でアクティブにするための設定
# environment.yml内のnameフィールドで指定された環境名を使用してください。
ENV CONDA_ENV rapids-24.02
RUN echo "conda activate $CONDA_ENV" >> ~/.zshrc

# 作業ディレクトリの設定
WORKDIR /workspace

# コンテナ起動時に実行するコマンド（zshを使用）
CMD ["/bin/zsh", "-l"]





# # 基本イメージ
# FROM nvidia/cuda:12.0.0-cudnn8-runtime-ubuntu22.04

# # 環境変数の設定
# ENV LANG C.UTF-8

# # 必要なパッケージのインストール
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     wget \
#     git \
#     ca-certificates \
#     build-essential \
#     libssl-dev \
#     libffi-dev \
#     python3-dev \
#     python3-pip \
#     python3-setuptools \
#     zsh \
#     && rm -rf /var/lib/apt/lists/*

# # Preztoのインストール
# RUN zsh -c "\
#     git clone --recursive https://github.com/sorin-ionescu/prezto.git '${ZDOTDIR:-$HOME}/.zprezto'; \
#     setopt EXTENDED_GLOB; \
#     for rcfile in '${ZDOTDIR:-$HOME}'/.zprezto/runcoms/^README.md(.N); do \
#     ln -s \"\$rcfile\" \"${ZDOTDIR:-$HOME}/.\${rcfile:t}\"; \
#     done; \
# "
# COPY .zprezto /root/.zprezto

# # Minicondaのインストール
# ENV PATH=/root/miniconda3/bin:$PATH
# RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
#     /bin/bash ~/miniconda.sh -b -p /root/miniconda3 && \
#     rm ~/miniconda.sh

# # Minicondaの初期化を.zshrcに追加
# RUN echo 'eval "$(conda shell.zsh hook)"' >> ~/.zshrc

# # rapids環境の作成
# RUN conda create -y --solver=libmamba -n rapids-24.02 -c rapidsai -c conda-forge -c nvidia \
#     rapids=24.02 python=3.10 cuda-version=12.0 \
#     dask-sql jupyterlab dash graphistry tensorflow xarray-spatial pytorch

# # 作業ディレクトリの設定
# WORKDIR /workspace

# # コンテナ起動時に実行するコマンド
# CMD ["zsh"]
