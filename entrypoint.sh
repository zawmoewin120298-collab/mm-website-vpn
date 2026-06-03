#!/bin/bash

# Xray ကို Port 8080 ဖြင့် နောက်ကွယ်တွင် စတင် Run ခြင်း
xray -config /etc/xray/config.json &

# Cloudflare Tunnel ကို ဆရာ့ Token အသုံးပြုပြီး ချိတ်ဆက်ခြင်း
if [ -z "$TUNNEL_TOKEN" ]; then
    echo "ERROR: TUNNEL_TOKEN Variable မရှိပါ။ ကျေးဇူးပြု၍ Railway Variables တွင် ထည့်ပေးပါ။"
    exit 1
else
    echo "Starting Cloudflare Tunnel with Token..."
    cloudflared tunnel --no-autoupdate run --token "$TUNNEL_TOKEN"
fi

