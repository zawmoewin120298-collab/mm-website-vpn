FROM alpine:latest

# လိုအပ်သော Tools များနှင့် cloudflared ကို သွင်းခြင်း
RUN apk add --no-cache curl libc6-compat bash jq unzip

# Xray Core ကို ဒေါင်းလုဒ်ဆွဲပြီး သွင်းခြင်း
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

