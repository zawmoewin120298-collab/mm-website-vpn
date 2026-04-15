FROM alpine:latest

RUN apk add --no-cache curl unzip caddy
WORKDIR /app

RUN curl -L -o xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip \
    && unzip xray.zip && chmod +x xray && rm -f xray.zip

COPY . .

# Xray ကို 8080 မှာ run ပြီး Caddy ကို 8081 မှာ အနောက်ကနေ run ခိုင်းထားပါတယ်
CMD ./xray -config config.json & caddy file-server --listen :8081

