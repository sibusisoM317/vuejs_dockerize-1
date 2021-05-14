# development environment
FROM node:12.2.0-alpine as develop-stage

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# build stage
FROM develop-stage as build-stage
RUN npm build

# production environment
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/conf.d
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
