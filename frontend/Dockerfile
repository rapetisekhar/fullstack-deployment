# Build stage
FROM node:18-alpine AS build
WORKDIR /app
COPY package.json vite.config.js index.html ./
COPY src ./src
RUN npm ci || npm i
RUN npm run build


# Serve stage
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
# Let the Service handle port mapping
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
