#!/bin/sh
set -eu

UUID_FILE="${HOME}/.xray-uuid"
KEY_FILE="${HOME}/.xray-keys"

if [ ! -f "$UUID_FILE" ]; then
  /usr/local/bin/xray uuid > "$UUID_FILE"
fi
XRAY_UUID=$(cat "$UUID_FILE")

if [ ! -f "$KEY_FILE" ]; then
  /usr/local/bin/xray x25519 > "$KEY_FILE"
fi

PRIV_KEY=$(grep "Private key:" "$KEY_FILE" | awk '{print $3}')
PUB_KEY=$(grep "Public key:" "$KEY_FILE" | awk '{print $3}')
SHORT_ID=$(openssl rand -hex 8)

export XRAY_UUID PRIV_KEY PUB_KEY SHORT_ID

# Update config.json
python3 - <<'PY'
import json
import os
from pathlib import Path

config_path = Path("/etc/config.json")
runtime_path = Path("/tmp/config.runtime.json")

if not config_path.exists():
    print("Config not found")
    exit(1)

data = json.loads(config_path.read_text())
data["inbounds"][0]["settings"]["clients"][0]["id"] = os.environ["XRAY_UUID"]
data["inbounds"][0]["streamSettings"]["realitySettings"]["privateKey"] = os.environ["PRIV_KEY"]
data["inbounds"][0]["streamSettings"]["realitySettings"]["shortIds"] = [os.environ["SHORT_ID"]]

runtime_path.write_text(json.dumps(data, indent=2))
PY

# Update info for Admin GUI
mkdir -p /opt/mrh-admin
python3 - <<'PY'
import json
import os
import urllib.request
from pathlib import Path

def get_ip():
    try: return urllib.request.urlopen("https://api.ipify.org", timeout=5).read().decode().strip()
    except: return "127.0.0.1"

info_path = Path("/opt/mrh-admin/xray-info.json")
info_path.write_text(json.dumps({
    "uuid": os.environ["XRAY_UUID"],
    "pubKey": os.environ["PUB_KEY"],
    "shortId": os.environ["SHORT_ID"],
    "sni": "www.microsoft.com",
    "ip": get_ip(),
    "port": 443
}, indent=2))
PY

echo "Xray starting..."
/usr/local/bin/xray -c /tmp/config.runtime.json >/tmp/xray.log 2>&1 &
