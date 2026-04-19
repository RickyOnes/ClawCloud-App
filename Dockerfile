FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai \
    LANG=zh_CN.UTF-8 \
    LANGUAGE=zh_CN:zh \
    LC_ALL=zh_CN.UTF-8 \
    APP_DATA_DIR=/app/xpra_user_data \
    HOME=/app/xpra_user_data

RUN apt-get update && apt-get install -y \
    wget curl gnupg ca-certificates locales \
    xvfb xauth dbus-x11 net-tools \
    xpra \
    fonts-wqy-zenhei fonts-liberation \
    libasound2 libatk-bridge2.0-0 libatk1.0-0 \
    libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 \
    libgbm1 libgcc1 libglib2.0-0 libgtk-3-0 libnspr4 libnss3 \
    libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 \
    libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 \
    libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 \
    libxss1 libxtst6 lsb-release xdg-utils \
    --no-install-recommends \
    && locale-gen zh_CN.UTF-8 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable --no-install-recommends \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/share/xpra/www \
    && if [ ! -f /usr/share/xpra/www/index.html ] && [ ! -f /usr/share/xpra/www/connect.html ]; then \
        curl -fsSL https://codeload.github.com/Xpra-org/xpra-html5/tar.gz/refs/heads/master -o /tmp/xpra-html5.tar.gz; \
        tar -xzf /tmp/xpra-html5.tar.gz -C /tmp; \
        cp -r /tmp/xpra-html5-master/html5/. /usr/share/xpra/www/; \
        rm -rf /tmp/xpra-html5.tar.gz /tmp/xpra-html5-master; \
    fi

WORKDIR /app

COPY start.sh /start.sh
COPY bin/ /app/bin/

RUN chmod +x /start.sh /app/bin/*.sh \
    && mkdir -p /app/xpra_user_data

EXPOSE 3000

CMD ["/start.sh"]
