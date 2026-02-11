FROM node:22.19.0 AS build

RUN apt-get install -y git
 
RUN mkdir /opt/app
WORKDIR /opt/app
RUN git clone -b develop https://github.com/TheBarberHub-2/front-admin.git
WORKDIR /opt/app/front-admin
RUN npm ci
RUN npm run build --prod

FROM nginx:1.28.0-alpine3.21
COPY --from=build /opt/app/front-admin/dist/Barber/browser/ /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

