FROM alpine:latest

# JSON ပြင်ဆင်ရန်အတွက် jq ပါ တစ်ခါတည်း သွင်းခြင်း
RUN apk add --no-cache wget unzip ca-certificates bash jq

# V2Ray Core ဒေါင်းလုဒ်ဆွဲခြင်း
RUN wget https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip && \
    unzip v2ray-linux-64.zip -d /usr/bin/ && \
    chmod +x /usr/bin/v2ray && \
    rm v2ray-linux-64.zip

# Cloudflared ดေါင်းလုဒ်ဆွဲခြင်း
RUN wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O /usr/local/bin/cloudflared && \
    chmod +x /usr/local/bin/cloudflared

RUN mkdir -p /etc/v2ray

# ဖိုင် ၃ ခုလုံးအား ကူးထည့်ခြင်း
COPY config.json /etc/v2ray/config.json
COPY bug.json /etc/v2ray/bug.json
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]

