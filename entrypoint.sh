#!/bin/bash

if [ -z "$PORT" ]; then
  PORT=8080
fi

if [ -f /etc/xray/config.json ]; then
  sed -i "s/\"port\": [0-9]*/\"port\": $PORT/g" /etc/xray/config.json
fi

echo "🚀 Starting Xray Core on Port: $PORT..."
/usr/bin/xray -config /etc/xray/config.json
