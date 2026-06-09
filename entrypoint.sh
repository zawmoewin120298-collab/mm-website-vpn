#!/bin/bash

# Railway ကပေးတဲ့ PORT မရှိရင် Default 8080 ကို သုံးခိုင်းခြင်း
if [ -z "$PORT" ]; then
  PORT=8080
fi

# config.json ထဲက port နေရာကို Railway ရဲ့ $PORT အတိုင်း လှည့်ပြင်ခြင်း
if [ -f /etc/xray/config.json ]; then
  sed -i "s/\"port\": [0-9]*/\"port\": $PORT/g" /etc/xray/config.json
fi

echo "🚀 Starting Xray Core on Port: $PORT..."

# Xray Core အား နောက်ကွယ်မှ စတင်မောင်းနှင်ခြင်း
/usr/bin/xray -config /etc/xray/config.json &

# တကယ်လို့ ဆရာက Cloudflare Tunnel သုံးဖို့ Variable ထည့်ခဲ့ရင် ၎င်းကိုပါ တွဲမောင်းပေးခြင်း
if [ ! -z "$TUNNEL_TOKEN" ]; then
  echo "🛡️ Starting Cloudflare Tunnel..."
  /usr/local/bin/cloudflared tunnel --no-autoupdate run --token "$TUNNEL_TOKEN"
else
  echo "💡 No TUNNEL_TOKEN provided, running Xray standalone."
  # Tunnel Token မပါရင် Containerကြီး မပိတ်သွားအောင် ရှေ့တန်းမှာ ထိန်းထားခြင်း
  wait -n
fi

