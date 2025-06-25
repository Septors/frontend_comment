# 1. Этап сборки (builder)
FROM node:18 AS builder

# Рабочая директория внутри контейнера
WORKDIR /app

# Копируем только frontend
COPY frontend/package*.json ./frontend/
WORKDIR /app/frontend
RUN npm install

# Копируем остальной код и билдим
COPY frontend/ ./ 
RUN npm run build

# 2. Этап запуска (nginx)
FROM nginx:stable-alpine

# Копируем собранный фронт в папку Nginx
COPY --from=builder /app/frontend/dist /usr/share/nginx/html

# SPA fallback (если надо)
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
