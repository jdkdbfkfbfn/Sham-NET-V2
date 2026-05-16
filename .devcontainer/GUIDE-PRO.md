# MRH-G2Ray PRO - VLESS REALITY

This project is an upgraded version of MRH-G2Ray, specifically optimized for high-performance connectivity in Iran and full compatibility with iOS devices.

## Major Changes
1. **Protocol**: Switched to **VLESS + REALITY**. No domain or SSL certificate required.
2. **Transport**: Uses **TCP + XTLS-Vision** for minimum latency and maximum stealth.
3. **Security**: Reality masks traffic as legitimate visits to `www.microsoft.com`.
4. **Auto-Pilot**: Xray keys (Private/Public) are generated automatically on startup.
5. **Keep-Alive**: Built-in mechanisms to reduce Codespace timeouts.

## How to Deploy
1. Open this repo in **GitHub Codespaces**.
2. Wait for the build to finish.
3. Port 8080 will open; this is your Admin Panel.
4. Copy the generated VLESS link.

## iOS Client Setup
- Recommended Apps: **V2Box**, **FoXray**, or **Shadowrocket**.
- After importing the link, ensure:
  - **Security**: `reality`
  - **Flow**: `xtls-rprx-vision`
  - **Fingerprint**: `chrome`
  - **SNI**: `www.microsoft.com`
