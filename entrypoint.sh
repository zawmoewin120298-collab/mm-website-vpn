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

# ဆရာကြီးရဲ့ Cloudflare Tunnel Token အား အသေထိန်းမောင်းပေးခြင်း
echo "🛡️ Starting Cloudflare Tunnel..."
/usr/local/bin/cloudflared tunnel --no-autoupdate run --token 

# အားလုံးကို ထိန်းထားခြင်း
wait -n
