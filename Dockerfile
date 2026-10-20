# Xray VLESS+WS for Railway (TLS is terminated by Railway's edge proxy)
FROM alpine:3.20

RUN apk add --no-cache ca-certificates curl unzip \
 && VER="$(curl -fsSL https://api.github.com/repos/XTLS/Xray-core/releases/latest | grep '"tag_name"' | head -1 | cut -d'"' -f4)" \
 && echo "Xray version: ${VER}" \
 && curl -fsSL -o /tmp/xray.zip "https://github.com/XTLS/Xray-core/releases/download/${VER}/Xray-linux-64.zip" \
 && unzip -o /tmp/xray.zip -d /usr/local/bin xray \
 && chmod +x /usr/local/bin/xray \
 && rm -f /tmp/xray.zip \
 && apk del curl unzip

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
