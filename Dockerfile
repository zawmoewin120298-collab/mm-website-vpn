# ၁။ GitHub Package ထဲက SNI-Spoofing-Rust Image ကို Base အနေနဲ့ ယူပါတယ်
FROM ghcr.io/therealaleph/sni-spoofing-rust:v1.0.2 AS sni_base

# ၂။ Xray Core အလုပ်လုပ်ဖို့အတွက် Standard Alpine Linux ကို ဆက်သုံးပါမယ်
FROM alpine:latest

# လိုအပ်သော Tools များနှင့် cloudflared ကို သွင်းခြင်း
RUN apk add --no-cache curl libc6-compat bash jq

# GitHub Package ထဲက sni-spoofing executable ဖိုင်ကို လက်ရှိ Container ထဲ ကူးထည့်ခြင်း
COPY --from=sni_base /usr/local/bin/sni-spoofing /usr/local/bin/sni-spoofing

# Xray Core နောက်ဆုံးဗားရှင်းကို တိုက်ရိုက် Download ဆွဲပြီး သွင်းခြင်း
RUN curl -L -o xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip \
    && unzip xray.zip -d /usr/bin/ \
    && chmod +x /usr/bin/xray \
    && rm -f xray.zip

# Cloudflare Tunnel Client ကို သွင်းခြင်း
RUN curl -L --output /usr/local/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 && \
    chmod +x /usr/local/bin/cloudflared

RUN mkdir -p /etc/xray

COPY config.json /etc/xray/config.json
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]

