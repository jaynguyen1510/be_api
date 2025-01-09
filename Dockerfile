# Chạy Puppeteer trên Docker với image chính thức của Puppeteer
FROM ghcr.io/puppeteer/puppeteer:23.10.2

# Chuyển sang user root để cài đặt các thư viện
USER root

# Cập nhật và cài đặt các thư viện cần thiết cho Puppeteer
RUN apt-get update && apt-get install -y \
    ca-certificates \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libc6 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libgbm1 \
    libgcc1 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libstdc++6 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    lsb-release \
    wget \
    xdg-utils

# Thêm kho lưu trữ Google Chrome vào apt
RUN curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | tee /etc/apt/trusted.gpg.d/google.asc

RUN echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list

# Cập nhật lại apt và cài đặt google-chrome-stable
RUN apt-get update && apt-get install -y google-chrome-stable

# Cấu hình cho Puppeteer không tải Chromium và chỉ định đường dẫn đến Google Chrome
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable

# Cài đặt thư viện ứng dụng
WORKDIR /usr/src/app

# Sao chép package.json và cài đặt các phụ thuộc
COPY package*.json ./
RUN npm ci
USER root
RUN npm install -g nodemon
USER pptruser

# Chuyển lại sang user pptruser sau khi cài đặt
USER pptruser

# Sao chép tất cả các tệp khác vào container
COPY . .

# Chạy ứng dụng với Nodemon
CMD ["nodemon", "index.js"]