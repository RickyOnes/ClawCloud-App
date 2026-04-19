FROM lscr.io/linuxserver/chromium:kasm

ENV PUID=1000 \
    PGID=1000 \
    TZ=Asia/Shanghai \
    TITLE=KasmVNC-Chrome \
    LC_ALL=zh_CN.UTF-8 \
    LANG=zh_CN.UTF-8 \
    LANGUAGE=zh_CN:zh \
    CHROME_CLI="--disable-dev-shm-usage --no-sandbox --disable-gpu"

RUN apt-get update && apt-get install -y --no-install-recommends \
    locales \
    fonts-wqy-zenhei \
    fonts-noto-cjk \
    && locale-gen zh_CN.UTF-8 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 3000


