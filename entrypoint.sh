#!/bin/bash

# Railway ကပေးတဲ့ PORT မရှိရင် Default 8080 ကို သုံးခိုင်းခြင်း
if [ -z "$PORT" ]; then
  PORT=8080
fi

# config.json ထဲက port နေရာကို Railway ရဲ့ $PORT အတိုင်း ကွက်တိ လှည့်ပြင်ခြင်း
if [ -f /etc/v2ray/config.json ]; then
  sed -i "s/\"port\": [0-9]*/\"port\": $PORT/g" /etc/v2ray/config.json
fi

echo "🚀 Starting V2Ray Core on Port: $PORT..."
# V2Ray Core အား နောက်ကွယ်မှ စတင်မောင်းနှင်ခြင်း
/usr/bin/v2ray run -c /etc/v2ray/config.json &

# Railway Variables ထဲက TUNNEL_TOKEN ကို ဖတ်ပြီး မောင်းနှင်ခြင်း
if [ ! -z "$TUNNEL_TOKEN" ]; then
  echo "🛡️ Starting Cloudflare Tunnel using Railway Variable..."
  /usr/local/bin/cloudflared tunnel --no-autoupdate run --token "$TUNNEL_TOKEN"
else
  echo "💡 No TUNNEL_TOKEN provided in Railway, running V2Ray standalone."
  # Tunnel Token မပါခဲ့ရင်လည်း Container ကြီး မပိတ်သွားအောင် ထိန်းထားခြင်း
  wait -n
fi
