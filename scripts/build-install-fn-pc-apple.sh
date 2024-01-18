#!/usr/bin/env bash
set -x

sudo apt install -y python-is-python3 build-essential cmake libexpat-dev libmbedtls-dev python3-jinja2 python3-yaml

CODE_PATH="${P_FN_PATH:-/home/$P_USERNAME/FujiNet}"
INSTALL_PATH="$CODE_PATH/FujiNet-PC-Apple"
mkdir -p "$CODE_PATH"
cd "$CODE_PATH"

git clone https://github.com/FujiNetWIFI/fujinet-platformio

cd "$CODE_PATH/fujinet-platformio"

./build.sh -cp APPLE

mkdir -p "$INSTALL_PATH"
cp -r "$CODE_PATH/build/*" "$INSTALL_PATH/"

cat <<EOF | sudo tee /etc/system/systemd/fn-pc-atari.service 
[Unit]
Description=FujiNet PC for Apple
After=remote-fs.target
After=syslog.target

[Service]
WorkingDirectory=$INSTALL_PATH
User=vcf
Group=vcf
ExecStart=$INSTALL_PATH/run-fujinet

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload