#!/bin/bash
set -euo pipefail

cd /workspace

# sbv2用の仮想環境有効化
sudo apt update
sudo apt upgrade -y
sudo apt install software-properties-common
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt update

sudo apt-get -y install python3.10 python3.10-venv python3.10-dev
mkdir -p /opt/environments/python/
python3.10 -m venv /opt/environments/python/sbv2/
source /opt/environments/python/sbv2/bin/activate

# セットアップ
if [ ! -d "Style-Bert-VITS2_vastai" ]; then
    git clone https://github.com/mayu4591/Style-Bert-VITS2_vastai.git
fi
bash Style-Bert-VITS2_vastai/script/verup_pytorch_2_8.sh

# 本家リポジトリから最新でインストール
if [ ! -d "/workspace/Style-Bert-VITS2" ]; then
  git clone --recursive https://github.com/litagin02/Style-Bert-VITS2.git /workspace/Style-Bert-VITS2
fi
cd /workspace/Style-Bert-VITS2
git fetch --tags && git checkout master
# requirements.txtの更新(torch<2.4, torchaudio<2.4 のバージョン指定を削除)
if [ -f requirements.txt ]; then
    sed -i 's/torch<2.4/torch/g' requirements.txt
    sed -i 's/torchaudio<2.4/torchaudio/g' requirements.txt
fi
pip install -r requirements.txt
cd /workspace/
