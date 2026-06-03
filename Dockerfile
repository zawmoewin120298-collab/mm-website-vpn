FROM teddysun/xray:latest

# လိုအပ်သော Tools များနှင့် cloudflared ထည့်သွင်းခြင်း
RUN apk add --no-cache curl libc6-compat bash

# Cloudflare Tunnel Client ကို သွင်းခြင်း
RUN curl -L --output /usr/local/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 && \
    chmod +x /usr/local/bin/cloudflared

RUN mkdir -p /etc/xray

COPY config.json /etc/xray/config.json
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

