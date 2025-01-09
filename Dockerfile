# Sử dụng Node.js image chính thức làm base
FROM node:18-bullseye-slim

# Chuyển sang quyền root để cài đặt các thư viện cần thiết
USER root

# Cập nhật apt và cài đặt Chromium và các thư viện liên quan
RUN apt-get update && apt-get install -y --no-install-recommends \
    chromium \
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
    wget \
    xdg-utils && \
    rm -rf /var/lib/apt/lists/*

# Đặt đường dẫn thực thi Chromium cho Puppeteer
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# Tạo thư mục làm việc
WORKDIR /usr/src/app

# Sao chép tệp package.json và package-lock.json (nếu có)
COPY package*.json ./
# Chạy cài đặt nodemon toàn cục
RUN npm install -g nodemon

# Cài đặt các dependencies
RUN npm ci

# Sao chép toàn bộ mã nguồn vào container
COPY . .

# Chuyển quyền trở lại user không phải root để tăng bảo mật
USER node

# Mở cổng (nếu ứng dụng sử dụng HTTP)
EXPOSE 3000

# Lệnh chạy ứng dụng
CMD ["nodemon", "index.js"]
