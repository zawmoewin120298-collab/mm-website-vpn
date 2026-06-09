#!/bin/bash

# Railway ကပေးတဲ့ PORT မရှိရင် Default 8080 ကို သုံးခိုင်းခြင်း
if [ -z "$PORT" ]; then
  PORT=8080
fi

# config.json ထဲက port နေရာကို Railway ရဲ့ $PORT အတိုင်း စက်ရုပ်စနစ်ဖြင့် လှည့်ပြင်ခိုင်းခြင်း
if [ -f /etc/xray/config.json ]; then
  sed -i "s/\"port\": [0-9]*/\"port\": $PORT/g" /etc/xray/config.json
fi

echo "🚀 Starting Xray Core on Port: $PORT..."

# Xray Core ကို နောက်ကွယ်မှ မဟုတ်ဘဲ ရှေ့တန်း (Foreground) မှာ တိုက်ရိုက် မောင်းနှင်ခြင်း
# (ဒါမှ Container ကြီး အလုပ်လုပ်နေပြီး လုံးဝ သေမသွားမှာ ဖြစ်ပါတယ်)
/usr/bin/xray run -c /etc/xray/config.json
