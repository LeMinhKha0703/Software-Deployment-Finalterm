# Bước 1: Sử dụng Image Node.js bản nhẹ (Alpine) làm nền
FROM node:10-jessie

# Bước 2: Thiết lập thư mục làm việc trong Container
WORKDIR /app

# Bước 3: Copy package.json và package-lock.json trước để tận dụng Docker Cache
COPY package*.json ./

# Bước 4: Cài đặt các thư viện (chỉ cài production để tối ưu dung lượng)
RUN npm install --omit=dev

# Bước 5: Copy toàn bộ mã nguồn vào Container
COPY . .

# Bước 6: Mở cổng 3000 (cổng mà app của bạn đang chạy)
EXPOSE 3000

# Bước 7: Lệnh để khởi chạy ứng dụng
CMD ["node", "main.js"]