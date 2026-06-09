#!/bin/bash

# Railway ကပေးတဲ့ PORT မရှိရင် Default 8080 ကို သုံးခိုင်းခြင်း
if [ -z "$PORT" ]; then
  PORT=8080
fi

# ၁။ config.json ထဲက port နေရာကို လှည့်ပြင်ခြင်း
if [ -f /etc/v2ray/config.json ]; then
  sed -i "s/\"port\": [0-9]*/\"port\": $PORT/g" /etc/v2ray/config.json
fi

# ၂။ bug.json ရှိခဲ့ရင် config.json ရဲ့ tcpSettings ထဲကို အလိုအလျောက် ပေါင်းထည့်ခြင်း
if [ -f /etc/v2ray/bug.json ] && [ -f /etc/v2ray/config.json ]; then
  echo "📥 Injecting bug.json configurations into config.json..."
  # jq သုံးပြီး bug.json ထဲက request အပိုင်းကို config.json ထဲ ကွက်တိ ထိုးထည့်ခြင်း
  jq '.inbounds[0].streamSettings.tcpSettings.header.request = input' /etc/v2ray/config.json /etc/v2ray/bug.json > /tmp/final_config.json
  mv /tmp/final_config.json /etc/v2ray/config.json
fi

echo "🚀 Starting V2Ray Core on Port: $PORT..."
/usr/bin/v2ray run -c /etc/v2ray/config.json &

echo "🛡️ Starting Cloudflare Tunnel..."
/usr/local/bin/cloudflared tunnel --no-autoupdate run --token eyJhIjoiNTBlNjY3NDA4YTBjMWQ1MmVmNTBhZmIyNGViNmViOGEiLCJ0IjoiODY2MGQ5ZWUtODU0YS00NzY5LWIzYjktN2M3ZmY1ODhiZWQ0IiwicyI6Ik5EUTBOV1JqWm1FdFkySmlOaTAwTW1NeUxUZ3dZV0l0WmpobU5UZGlOV0l5TkRZeiJ9

wait -n
