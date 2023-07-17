FROM node:18-alpine3.17 as build
WORKDIR /ui
COPY . /ui
RUN rm -rf node_modules package-lock.json
RUN npm install
RUN npm run build

FROM nginx
EXPOSE 80

COPY --from=build /ui/ /usr/share/nginx/html

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]