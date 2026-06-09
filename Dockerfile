FROM alpine:latest

# လိုအပ်သော Tools များကို သွင်းခြင်း
RUN apk add --no-cache curl bash jq unzip

# Xray Core နောက်ဆုံးဗားရှင်းကို တိုက်ရိုက် သွင်းခြင်း
RUN curl -L -o xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip \
    && unzip xray.zip -d /usr/bin/ \
    && chmod +x /usr/bin/xray \
    && rm -f xray.zip

RUN mkdir -p /etc/xray

COPY config.json /etc/xray/config.json
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Railway ပေါ်တွင် အလုပ်လုပ်မည့် Port
EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
